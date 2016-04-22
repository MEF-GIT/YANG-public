


To generate REST Docs from mpls-vpn.yang but this returned only top level

pyang -f rest-doc -p ../../../mef/src/yang -o mpls-vpn.rest.txt mpls-vpn.yang

So I used the, now deprecated, XSD format of pyang

pyang -f xsd -p ../../../mef/src/yang -o mpls-vpn.xsd.txt mpls-vpn.yang
pyang -f xsd -p ../../../mef/src/yang -o mpls-qos.xsd.txt mpls-qos.yang
pyang -f xsd -o mef-topology.xsd.txt mef-topology.yang
pyang -f xsd -o mef-types.xsd.txt mef-types.yang

curl -k -i 'https://admin:admin@63.221.246.184:443/api/query' -X POST -T rest-json-query-mpls-vpn-by-customer.txt -H "Content-Type: application/vnd.yang.data+json"

curl -k -i 'https://admin:admin@63.221.246.184:443/api/query' -X POST -T rest-json-query-mpls-vpn-fetch-result.txt -H "Content-Type: application/vnd.yang.data+json"

curl -k -i 'https://admin:admin@63.221.246.184:443/api/query' -X POST -T rest-json-query-mpls-vpn-stop-query.txt -H "Content-Type: application/vnd.yang.data+json"

curl -k -u admin:admin  -H "Accept: application/vnd.yang.collection+json" https://63.221.246.184:443/api/running/mpls-vpn/vpn?deep

curl -k -u admin:admin  -H "Accept: application/vnd.yang.data+json" https://63.221.246.184:443/api/running/mpls-vpn/vpn/MEF001?deep

curl -k -u admin:admin  -H "Accept: application/vnd.yang.data+json" https://63.221.246.184:443/api/running/mef-global/profiles/cos-names?deep

curl -k -u admin:admin  -H "Accept: application/vnd.yang.data+json" https://63.221.246.184:443/api/running/mef-global/profiles/cos/cos-profile/COS_DSCP_1?deep

curl -k -u admin:admin  -H "Accept: application/vnd.yang.data+json" https://63.221.246.184:443/api/running/mef-global/profiles/ingress-bwp-flows/bwp-flow/INGRESS_BWP_100mbps?deep

curl -k -u admin:admin  -H "Accept: application/vnd.yang.data+json" https://63.221.246.184:443/api/running/mef-global/profiles/ingress-bwp-flows/bwp-flow/INGRESS_BWP_2mbps?deep

curl -k -u admin:admin  -H "Accept: application/vnd.yang.data+json" https://63.221.246.184:443/api/running/mef-global/profiles/egress-bwp-flows/bwp-flow/EGRESS_BWP_100mbps?deep

curl -k -u admin:admin  -H "Accept: application/vnd.yang.data+json" https://63.221.246.184:443/api/running/mef-global/profiles/egress-bwp-flows/bwp-flow/EGRESS_BWP_2mbps?deep

curl -k -i -u admin:admin -X PATCH -T ./rest-json-patch-mpls-vpn-ebwp-profile-modify.txt  https://63.221.246.184:443/api/running/mpls-vpn:mpls-vpn -H "Content-Type: application/vnd.yang.data+json"

curl -k -i -u admin:admin -X PATCH -T ./rest-json-patch-mpls-vpn-qos-profile-modify.txt https://63.221.246.184:443/api/running/mpls-vpn:mpls-vpn -H "Content-Type: application/vnd.yang.data+json"

curl -k -u admin:admin -X DELETE https://63.221.246.184:443/api/running/mpls-vpn/vpns/vpn/pepsi

curl -k -i 'https://admin:admin@63.221.246.184:443/api/query' -X POST -T rest-json-query-mpls-vpn-by-site.txt -H "Content-Type: application/vnd.yang.data+json"

curl -k -i 'https://admin:admin@63.221.246.184:443/api/query' -X POST -T rest-json-query-mpls-vpn-fetch-result.txt -H "Content-Type: application/vnd.yang.data+json"

curl -k -u admin:admin  -H "Accept: application/vnd.yang.collection+json" https://63.221.246.184:443/api/running/mpls-vpn/vpn?deep

   "operations": {
      "check-sync": "/api/running/mpls-vpn/vpn/MEF001/_operations/check-sync",
      "deep-check-sync": "/api/running/mpls-vpn/vpn/MEF001/_operations/deep-check-sync",
      "re-deploy": "/api/running/mpls-vpn/vpn/MEF001/_operations/re-deploy",
      "get-modifications": "/api/running/mpls-vpn/vpn/MEF001/_operations/get-modifications",
      "un-deploy": "/api/running/mpls-vpn/vpn/MEF001/_operations/un-deploy"
    }

$ curl -k -u admin:admin -X POST -H "Accept:application/vnd.yang.data+json" "https://63.221.246.184:443/api/running/devices/_operations/check-sync"
{
  "output": {
    "sync-result": [
      {
        "device": "dcvar01.hkg08",
        "result": "unsupported"
      },
      {
        "device": "dcvar01.rst01",
        "result": "unsupported"
      },
      {
         "device": "var01.hkg08",
         "result": "out-of-sync",
         "info": "got: fa0286814d5d06f024f26cdcac5882e2 expected: 5cc27dd3841942a646dd8b9b6b91545"
      },
      {
        "device": "var02.rst01",
        "result": "in-sync"
      },
      {
        "device": "var05.frf02",
        "result": "in-sync"
      }
    ]
  }
}

$ curl -u admin:admin -X POST -H "Accept:application/vnd.yang.data+json" "https://63.221.246.184:443/api/running/devices/_operations/sync-from"
{
  "output": {
    "sync-result": [
      {
        "device": "dcvar01.hkg08",
        "result": true
      },
      {
        "device": "dcvar01.rst01",
        "result": true
      },
      {
        "device": "var01.hkg08",
        "result": true
      },
      {
        "device": "var02.rst01",
        "result": true
      },
      {
        "device": "var05.frf02",
        "result": true
      }
    ]
  }
}

$ curl -u admin:admin -X POST -H "Accept:application/vnd.yang.data+json" "https://63.221.246.184:443/api/running/devices/_operations/sync-to"
{
  "output": {
    "sync-result": [
      {
        "device": "dcvar01.hkg08",
        "result": true
      },
      {
        "device": "dcvar01.rst01",
        "result": true
      },
      {
        "device": "var01.hkg08",
        "result": true
      },
      {
        "device": "var02.rst01",
        "result": true
      },
      {
        "device": "var05.frf02",
        "result": true
      }
    ]
  }
}

ALL DEVICES

curl -k -u admin:admin  -H "Accept:application/vnd.yang.data+json" https://63.221.246.184:443/api/running/devices?deep

....

    "operations": {
      "connect": "/api/running/devices/_operations/connect",
      "sync": "/api/running/devices/_operations/sync",
      "sync-to": "/api/running/devices/_operations/sync-to",
      "sync-from": "/api/running/devices/_operations/sync-from",
      "disconnect": "/api/running/devices/_operations/disconnect",
      "check-sync": "/api/running/devices/_operations/check-sync",
      "check-yang-modules": "/api/running/devices/_operations/check-yang-modules",
      "fetch-ssh-host-keys": "/api/running/devices/_operations/fetch-ssh-host-keys",
      "clear-trace": "/api/running/devices/_operations/clear-trace"
    }

JUST ONE DEVICE

curl -k -u admin:admin  -H "Accept:application/vnd.yang.data+json" https://63.221.246.184:443/api/running/devices/device/var01.hkg08?deep

   "operations": {
      "apply-template": "/api/running/devices/device/var01.hkg08/_operations/apply-template",
      "instantiate-from-other-device": "/api/running/devices/device/var01.hkg08/_operations/instantiate-from-other-device",
      "compare-config": "/api/running/devices/device/var01.hkg08/_operations/compare-config",
      "sync": "/api/running/devices/device/var01.hkg08/_operations/sync",
      "sync-from": "/api/running/devices/device/var01.hkg08/_operations/sync-from",
      "sync-to": "/api/running/devices/device/var01.hkg08/_operations/sync-to",
      "check-sync": "/api/running/devices/device/var01.hkg08/_operations/check-sync",
      "check-yang-modules": "/api/running/devices/device/var01.hkg08/_operations/check-yang-modules",
      "connect": "/api/running/devices/device/var01.hkg08/_operations/connect",
      "disconnect": "/api/running/devices/device/var01.hkg08/_operations/disconnect",
      "ping": "/api/running/devices/device/var01.hkg08/_operations/ping",
      "delete-config": "/api/running/devices/device/var01.hkg08/_operations/delete-config"
    }
    
    

$ curl -k -u admin:admin -X POST -H "Accept:application/vnd.yang.data+json" "https://63.221.246.184:443/api/running/devices/device/var05.frf02/_operations/ping"
{
  "output": {
    "result": "PING 63.218.14.14 (63.218.14.14) 56(84) bytes of data.\n64 bytes from 63.218.14.14: icmp_seq=1 ttl=248 time=87.9 ms\n\n--- 63.218.14.14 ping statistics ---\n1 packets transmitted, 1 received, 0% packet loss, time 0ms\nrtt min/avg/max/mdev = 87.939/87.939/87.939/0.000 ms\n"
  }
}

EXAMPLE OF INSERT ON Ordered-by User List:

We use the POST method to add a new element into the list.
         Here the insert=before is used where also the resource 
         parameter is required to get the position in the list.
         Note, since the list only contain one element the insert=first
         could have been used to create the same result.

    $ curl -w "HTTP/1.1 %{http_code}\n" -u admin:admin -T ./inputsec20.xml -X POST "http://127.0.0.1:8080/api/running/devices/device/ex0/config/sys/dns?insert=before&resource=/api/running/${FRAGMENT}sys/dns/server/10.2.3.4" -H "Content-Type: application/vnd.yang.data+xml"
    
    
EXAMPLE of ROLLBACK

First make a change:
$ ncs_cli -u admin -C 

admin connected from 127.0.0.1 using console on mylo
admin@ncs# config
Entering configuration mode terminal
admin@ncs(config)# mpls-vpn vpn MEF001 endpoints endpoint SR111120
admin@ncs(config-endpoint-SR111120)# qos ingress port-rate 3000
admin@ncs(config-endpoint-SR111120)# qos egress port-rate 3000
admin@ncs(config-endpoint-SR111120)# top
admin@ncs(config)# commit dry-run outformat native
device dcvar01.hkg08_0
  policy-map demo-mef-in
   class class-default
    police rate 3000 kbps
    !
   !
   end-policy-map
  !
  policy-map demo-mef-out
   class class-default
    shape average 3000 kbps
   !
   end-policy-map
  !
admin@ncs(config)# commit
Commit complete.
admin@ncs(config)# exit
admin@ncs# exit



Next, get a list of rollbacks. Note that most most recent one is indexed by the number 0.

curl -u admin:admin  -H "Accept: application/vnd.yang.api+json" http://192.168.1.10:10888/api/rollbacks?deep

$ curl -u admin:admin  -H "Accept: application/vnd.yang.api+json" http://192.168.1.10:10888/api/rollbacks?deep
{
"rollbacks":{
"file":{"name":"0","creator":"admin","date":"2015-12-21 13:13:34","via":"cli","label":"","comment":""},
"file":{"name":"1","creator":"admin","date":"2015-12-21 10:52:54","via":"cli","label":"","comment":""},
"file":{"name":"2","creator":"admin","date":"2015-12-21 10:52:42","via":"cli","label":"","comment":""},
"file":{"name":"3","creator":"admin","date":"2015-12-21 10:52:41","via":"cli","label":"","comment":""},
"file":{"name":"4","creator":"admin","date":"2015-12-21 10:52:32","via":"cli","label":"","comment":""}
}
}

Next, Check that the rollback selected is the one you want.:

$ curl -u admin:admin  -H "Accept: application/vnd.yang.api+json" http://192.168.1.10:10888/api/rollbacks/0?deep

# Created by: admin
# Date: 2015-12-21 13:13:34
# Via: cli
# Type: delta
# Label: 
# Comment: 
# No: 10032

mpls-vpn:mpls-vpn {
    mpls-vpn:vpn MEF001 {
        mpls-vpn:endpoints {
            mpls-vpn:endpoint SR111120 {
                mpls-vpn:qos {
                    mpls-vpn:egress {
                        mpls-vpn:port-rate 2000;
                    }
                    mpls-vpn:ingress {
                        mpls-vpn:port-rate 2000;
                    }
                 }
             }
         }
     }
 }

Next, Create the rollback configuration file. 

$ cat rest-xml-query-mpls-vpn-rollback-file-0.txt
<file>0</file>

$ curl -v -u admin:admin -X POST -T rest-xml-query-mpls-vpn-rollback-file-0.txt -H "Accept: application/vnd.yang.data+xml" "http://192.168.1.10:10888/api/running/_rollback"

* Hostname was NOT found in DNS cache
*   Trying 192.168.1.10...
* Connected to 192.168.1.10 (192.168.1.10) port 10888 (#0)
* Server auth using Basic with user 'admin'
> POST /api/running/_rollback HTTP/1.1
> Authorization: Basic YWRtaW46YWRtaW4=
> User-Agent: curl/7.38.0
> Host: 192.168.1.10:10888
> Accept: application/vnd.yang.data+xml
> Content-Length: 16
> Expect: 100-continue
> 
< HTTP/1.1 100 Continue
* Server  is not blacklisted
< Server: 
< Allow: GET, POST, OPTIONS, HEAD
< Content-Length: 0
* We are completely uploaded and fine
< HTTP/1.1 204 No Content
* Server  is not blacklisted
< Server: 
< Date: Mon, 21 Dec 2015 18:42:04 GMT
< Allow: GET, POST, OPTIONS, HEAD
< Cache-Control: private, no-cache, must-revalidate, proxy-revalidate
< Content-Length: 0
< Content-Type: text/html
< Pragma: no-cache
< 
* Connection #0 to host 192.168.1.10 left intact







