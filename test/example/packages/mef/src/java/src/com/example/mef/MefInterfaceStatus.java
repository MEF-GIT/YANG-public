package com.example.mef;

import java.net.Socket;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;

import com.example.mef.namespaces.mefTopology;
import com.tailf.conf.Conf;
import com.tailf.conf.ConfKey;
import com.tailf.conf.ConfNamespace;
import com.tailf.conf.ConfObject;
import com.tailf.conf.ConfUInt64;
import com.tailf.conf.ConfValue;
import com.tailf.dp.DpCallbackException;
import com.tailf.dp.DpTrans;
import com.tailf.dp.annotations.DataCallback;
import com.tailf.dp.annotations.TransCallback;
import com.tailf.dp.proto.DataCBType;
import com.tailf.dp.proto.TransCBType;
import com.tailf.maapi.Maapi;
import com.tailf.navu.NavuContainer;
import com.tailf.navu.NavuContext;
import com.tailf.navu.NavuException;
import com.tailf.navu.NavuList;
import com.tailf.ncs.ns.Ncs;

public class MefInterfaceStatus {

    private static Maapi m = null;
    private long staleCounter;
    private Logger logger;

    public MefInterfaceStatus() {
        this.staleCounter = 0;
        logger = Logger.getLogger(this.getClass());
    }

    private synchronized void checkStale(DpTrans trans) {
        try {
            long now = System.currentTimeMillis();
            if ((now - this.staleCounter) > 5000) {
                // If more than 5 seconds have passed, we want to throw the
                // entire cached navu tree away, and go to the devices again and
                // get the live data
                this.staleCounter = now;
                NavuContext current = (NavuContext)trans.getTransactionUserOpaque();
                trans.setTransactionUserOpaque(new NavuContext(current.getMaapi(), trans.getTransaction()));
            }
        }
        catch (Exception e) {
            ;
        }
    }

    @TransCallback(callType = TransCBType.INIT)
    public void init(DpTrans trans) throws DpCallbackException {
        try {
            // Need a Maapi socket so that we can attach
            Socket s = new Socket("localhost", Conf.NCS_PORT);
            Maapi m = new Maapi(s);

            m.attach(trans.getTransaction(),
                    0,
                    trans.getUserInfo().getUserId());

            trans.setTransactionUserOpaque(new NavuContext(m, trans.getTransaction()));

            return;
        }
        catch (Exception e) {
            throw new DpCallbackException("Failed to attach", e);
        }
    }

    @TransCallback(callType = TransCBType.FINISH)
    public void finish(DpTrans trans) throws DpCallbackException {
        try {
            NavuContext context = (NavuContext) trans.getTransactionUserOpaque();
            context.getMaapi().detach(trans.getTransaction());
            context.getMaapi().getSocket().close();
        }
        catch (Exception e) {
            throw new DpCallbackException("Failed to finish Transaction", e);
        }
    }

    private NavuContext getContext(DpTrans trans) throws DpCallbackException {
        checkStale(trans);
        return (NavuContext)trans.getTransactionUserOpaque();
    }

    private NavuContainer getNcsNavuContainer(DpTrans trans) throws DpCallbackException {
        NavuContext context = getContext(trans);

        NavuContainer mroot = new NavuContainer(context);
        ConfNamespace ncsNs = new Ncs();
        try {
            return mroot.container(ncsNs.hash());
        }
        catch (Exception e) {
            throw new DpCallbackException("Failed to get NcsNavuContainer", e);
        }
    }

    public void checkDevicesSynced(NavuList managedDevices) throws DpCallbackException, NavuException {

        for (NavuContainer device : managedDevices) {
            if (device.list("capability").isEmpty()) {
                String mess = "Device %1$s has no known capabilities, " + "has sync-from been performed?";
                String key = device.getKey().elementAt(0).toString();
                throw new DpCallbackException(String.format(mess, key));
            }
        }
    }

    public NavuList getDevices(NavuContainer ncs) throws NavuException {
        return ncs.container(Ncs._devices).list(Ncs._device);
    }

    public String[] splitInterfaceName(String interfaceName) throws DpCallbackException {
        Pattern numberPattern = Pattern.compile("\\d");
        Matcher matcher = numberPattern.matcher(interfaceName);
        if (!matcher.find()) {
            throw new DpCallbackException(
                    "Interface name should contain a number which denotes the beginning of the ID");
        }
        int index = matcher.start();
        String[] result = { interfaceName.substring(0, index), interfaceName.substring(index) };

        return result;
    }

    private <T> T checkNull(T object, String msg) throws DpCallbackException {
        if (null == object) {
            throw new DpCallbackException(msg);
        }
        return object;
    }

    @DataCallback(callPoint = mefTopology.callpoint_interface_status, callType = DataCBType.GET_ELEM)
    public ConfValue getElem(DpTrans trans, ConfObject[] keyPath) throws DpCallbackException, NavuException {
        NavuContainer ncs = getNcsNavuContainer(trans);
        NavuList managedDevices = getDevices(ncs);
        checkDevicesSynced(managedDevices);

        ConfKey fullInterfaceKey = (ConfKey) (keyPath[2]);
        ConfKey deviceKey = (ConfKey) (keyPath[5]);

        try {
            String interfaceName = fullInterfaceKey.elements()[0].toString();
            String[] interfaceArray = splitInterfaceName(interfaceName);

            NavuContainer device = checkNull(managedDevices.elem(deviceKey),
                    "Couldn't find device: " + deviceKey.toString());

            String[] statsNamespaces = { "ios-stats", "cisco-ios-xr-stats" };
            for (String namespace : statsNamespaces) {
                NavuList interfaceList = device.container(Ncs._live_status_).list(namespace, "interfaces");


                NavuContainer _interface = interfaceList.elem(interfaceArray);
                if (null == _interface) {
                    continue;
                }

                String speedStr = _interface.leaf("speed").valueAsString();

                try {
                    long speed = Long.parseLong(speedStr);
                    return new ConfUInt64(speed);
                } catch (NumberFormatException e) {
                    throw new DpCallbackException("Couldn't convert speed to a long", e);
                }
            }

            throw new DpCallbackException("Couldn't find interface: " + interfaceName);
        }
        catch (DpCallbackException e) {
            logger.info(e);
            return new ConfUInt64(0);
        }
    }
}
