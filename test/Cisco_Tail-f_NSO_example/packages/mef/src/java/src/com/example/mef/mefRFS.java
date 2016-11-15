package com.example.mef;

import java.util.Properties;

import com.tailf.conf.ConfBool;
import com.tailf.conf.ConfBuf;
import com.tailf.conf.ConfKey;
import com.tailf.conf.ConfObject;
import com.tailf.conf.ConfTag;
import com.tailf.conf.ConfXMLParam;
import com.tailf.conf.ConfXMLParamValue;
import com.tailf.dp.DpActionTrans;
import com.tailf.dp.DpCallbackException;
import com.tailf.dp.annotations.ActionCallback;
import com.tailf.dp.annotations.ServiceCallback;
import com.tailf.dp.proto.ActionCBType;
import com.tailf.dp.proto.ServiceCBType;
import com.tailf.dp.services.ServiceContext;
import com.tailf.navu.NavuContainer;
import com.tailf.navu.NavuList;
import com.tailf.navu.NavuNode;
import com.tailf.ncs.template.Template;
import com.tailf.ncs.template.TemplateVariables;

public class mefRFS {


    /**
     * Create callback method.
     * This method is called when a service instance committed due to a create
     * or update event.
     *
     * This method returns a opaque as a Properties object that can be null.
     * If not null it is stored persistently by Ncs.
     * This object is then delivered as argument to new calls of the create
     * method for this service (fastmap algorithm).
     * This way the user can store and later modify persistent data outside
     * the service model that might be needed.
     *
     * @param context - The current ServiceContext object
     * @param service - The NavuNode references the service node.
     * @param ncsRoot - This NavuNode references the ncs root.
     * @param opaque  - Parameter contains a Properties object.
     *                  This object may be used to transfer
     *                  additional information between consecutive
     *                  calls to the create callback.  It is always
     *                  null in the first call. I.e. when the service
     *                  is first created.
     * @return Properties the returning opaque instance
     * @throws DpCallbackException
     */

    @ServiceCallback(servicePoint="mef-topology-servicepoint",
        callType=ServiceCBType.CREATE)
    public Properties create(ServiceContext context,
                             NavuNode service,
                             NavuNode ncsRoot,
                             Properties opaque)
                             throws DpCallbackException {

        try {
            // check if it is reasonable to assume that devices
            // initially has been sync-from:ed
            NavuList managedDevices = ncsRoot.
                container("devices").list("device");
            for (NavuContainer device : managedDevices) {
                if (device.list("capability").isEmpty()) {
                    String mess = "Device %1$s has no known capabilities, " +
                                   "has sync-from been performed?";
                    String key = device.getKey().elementAt(0).toString();
                    throw new DpCallbackException(String.format(mess, key));
                }
            }
        } catch (DpCallbackException e) {
            throw (DpCallbackException) e;
        } catch (Exception e) {
            throw new DpCallbackException("Not able to check devices", e);
        }

	try {
            Template mefPrestoNetworkTemplate = new Template(context,
                "mef-presto-network"); 

            String servicePath = null;
            servicePath = service.getKeyPath();

            //Now get the single leaf we have in the service instance
            // NavuLeaf sServerLeaf = service.leaf("dummy");
            // Get the container at keypath
            // /services/ethernet-virtual-connection{s1}


            NavuNode evc = service;
            //ConfPath kp = new ConfPath(evc.getKeyPath());

            //..and its value (wich is a ipv4-addrees )
            // ConfIPv4 ip = (ConfIPv4)sServerLeaf.value();

            //Get the list of all managed devices.
            NavuList managedDevices =
                ncsRoot.container("devices").list("device");
            
            TemplateVariables topoVar = new TemplateVariables();
            mefPrestoNetworkTemplate.apply(service, topoVar);
            
            // iterate through all manage devices
            //for(NavuContainer deviceContainer : managedDevices.elements()){

                // here we have the opportunity to do something with the
                // ConfIPv4 ip value from the service instance,
                // assume the device model has a path /xyz/ip, we could
                // deviceContainer.container("config").
                //         .container("xyz").leaf(ip).set(ip);
                //
                // remember to use NAVU sharedCreate() instead of
                // NAVU create() when creating structures that may be
                // shared between multiple service instances


                //NavuContainer ifs = deviceContainer.container("config").
                //    container("r", "sys").container("interfaces");

                // execute as shared create of the path
                //   /interfaces/interface[name='x']/unit[name='i']

         //      NavuContainer unit =
         //           ifs.list("interface").sharedCreate(
          //              evc.leaf("identifier").value()).
          //              list("description").sharedCreate(
          //                  evc.leaf("identifier").value());

         //       unit.leaf("vlan-id").set(new ConfUInt16(1));
         //       unit.leaf("enabled").set(new ConfBool(true));
         //       unit.leaf("unit").set(new ConfInt32(-57));

            //   TemplateVariables vpnVar = new TemplateVariables();
          //      vpnVar.putQuoted("PE",deviceContainer.leaf("device").
           //                                 valueAsString());
            //    vpnVar.putQuoted("LOCATION",deviceContainer.leaf("device").
           //                                 valueAsString());
           //    vpnVar.putQuoted("LOCATION",deviceContainer.leaf("device").
           //                                 valueAsString());
            //   vpnVar.putQuoted("LOCATION",deviceContainer.leaf("device").
            //                                valueAsString());

    


           // }
        } catch (Exception e) {
            throw new DpCallbackException(e.getMessage(), e);
        }
        return opaque;
    }


    /**
     * Init method for selftest action
     */
    @ActionCallback(callPoint="mef-test-point", callType=ActionCBType.INIT)
    public void init(DpActionTrans trans) throws DpCallbackException {
    }

    /**
     * Selftest action implementation for service
     */
    @ActionCallback(callPoint="mef-topology-self-test-point", callType=ActionCBType.ACTION)
    public ConfXMLParam[] selftest(DpActionTrans trans, ConfTag name,
                                   ConfObject[] kp, ConfXMLParam[] params)
    throws DpCallbackException {
        try {
            // Refer to the service yang model prefix
            String nsPrefix = "mef-evc-service";
            // Get the service instance key
            String str = ((ConfKey)kp[0]).toString();

          return new ConfXMLParam[] {
              new ConfXMLParamValue(nsPrefix, "success", new ConfBool(true)),
              new ConfXMLParamValue(nsPrefix, "message", new ConfBuf(str))};

        } catch (Exception e) {
            throw new DpCallbackException("self-test failed", e);
        }
    }

}
