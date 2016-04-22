

// ssh port for demo mode is 2022
netconf-console -u admin -p admin --host 127.0.0.1 --port 2022 -v 1.0 -s pretty cmd-get-config-all.xml

// tcp port for demo mode is 2023
netconf-console -u admin -p admin --host 127.0.0.1 --port 2023 -v 1.0 -s pretty cmd-get-config-all.xml

netconf-console -u admin -p admin --host 127.0.0.1 --port 830 -v 1.0 -s pretty cmd-get-config-all.xml

//save running config to file
netconf-console -u admin -p admin --host 127.0.0.1 --port 830 -v 1.0 cmd-copy-config-all-from.xml

//Restore from file
netconf-console -u admin -p admin --host 127.0.0.1 --port 830 -v 1.0 cmd-copy-config-all-to.xml

// Examples use the ssh port 2022
ssh -s -p2022 admin@127.0.0.1 netconf < cmd-set-mef-epl01.xml

ssh -s -p22 admin@127.0.0.1 netconf < cmd-edit-config-mef-epl01-modify.xml

ssh -s -p22 admin@127.0.0.1 netconf < cmd-edit-config-mef-epl01-delete.xml

// ssh port for demo mode Confd CLI uses port 2024
ssh -p2024 admin@127.0.0.1
