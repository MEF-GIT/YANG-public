import ncs

V = ncs.types.Value

def vpn_path(name) :
   return '/l3vpn:vpn/l3vpn{"' + name + '"}'

def create_service(t, name, asNumber) :
   path = vpn_path(name)

   t.create_allow_exist(path)
   t.set_elem(V(asNumber, V.C_UINT32), path + '/as-number')

def add_endpoint(t, serviceName, endpointId, ceDevice, ceInterface, ipNetwork, bandwidth) :
   path = vpn_path(serviceName) + '/endpoint{"' + endpointId + '"}'

   t.create_allow_exist(path)
   t.set_elem(ceDevice, path + '/ce-device')
   t.set_elem(ceInterface, path + '/ce-interface')
   t.set_elem(V(ipNetwork, V.C_IPV4PREFIX), path + '/ip-network')
   t.set_elem(V(bandwidth, V.C_UINT32), path + '/bandwidth')


def create_volvo(t) :
   serviceName = 'volvo'

   create_service(t, serviceName, 12345)

   add_endpoint(t, serviceName, 'branch-office1',
       'ce1', 'GigabitEthernet0/11', '10.7.7.0/24', 6000000)

   add_endpoint(t, serviceName, 'branch-office2',
       'ce4', 'GigabitEthernet0/18', '10.8.8.0/24', 6000000)

   add_endpoint(t, serviceName, 'main-office',
       'ce0', 'GigabitEthernet0/11', '10.10.1.0/24', 6000000)

def sync_from_devices(maapiSock) :
   print('Syncing from devices ...')
   result = ncs._maapi.request_action(maapiSock,[], 0, fmt = '/ncs:devices/sync-from')
   print('Synced from devices!')


if __name__ == '__main__' :
   with ncs.maapi.wctx.connect(ip = '127.0.0.1', port = ncs._constants.NCS_PORT) as c :
       with ncs.maapi.wctx.session(c, 'admin') as s :
           with ncs.maapi.wctx.trans(s, readWrite = ncs._constants.READ_WRITE) as t :
               sync_from_devices(t.sock)
               create_volvo(t)
               t.apply()
