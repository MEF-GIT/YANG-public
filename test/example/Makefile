# The order of packages is significant as there are dependencies between
# the packages. Typically generated namespaces are used by other packages.
PACKAGES = l3vpn l3vpnui mef

# The create-network argument to ncs-netsim
NETWORK = create-network cisco-ios 9 ce \
          	  create-network ./packages/cisco-ios 2 ce \
          	  create-network ./packages/cisco-ios 2 ce \
		  create-network cisco-iosxr 2 pe \
		  create-network juniper-junos 1 pe \
		  create-network cisco-iosxr 1 pe \
          	  create-network ./packages/cisco-ios 1 CSR-1_ \
          	  create-network ./packages/cisco-ios 1 CSR-2_ \
          	  create-network ./packages/cisco-ios 1 CSR-3_ \
          	  create-network ./packages/cisco-ios 1 CSR-4_ \
		  create-network cisco-iosxr 4 p

NETSIM_DIR = netsim

.PHONY: test settest

all: build-all $(NETSIM_DIR)

#	cp ../../src/model/draft/mef*.yang ./packages/mef/src/yang
build-all: models
	for i in $(PACKAGES); do \
		$(MAKE) -C packages/$${i}/src all || exit 1; \
	done

$(NETSIM_DIR): packages/cisco-ios packages/cisco-iosxr packages/juniper-junos
	ncs-netsim --dir netsim $(NETWORK)
	cp initial_data/ios.xml netsim/ce/ce0/cdb
	cp initial_data/ios.xml netsim/ce/ce1/cdb
	cp initial_data/ios.xml netsim/ce/ce2/cdb
	cp initial_data/ios.xml netsim/ce/ce3/cdb
	cp initial_data/ios.xml netsim/ce/ce4/cdb
	cp initial_data/ios.xml netsim/ce/ce5/cdb
	cp initial_data/ios.xml netsim/ce/ce6/cdb
	cp initial_data/ios.xml netsim/ce/ce7/cdb
	cp initial_data/ios.xml netsim/ce/ce8/cdb
	cp initial_data/iosxr.xml netsim/pe/pe0/cdb
	cp initial_data/iosxr.xml netsim/pe/pe1/cdb
	cp initial_data/iosxr.xml netsim/pe/pe3/cdb
	cp initial_data/iosxr.xml netsim/p/p0/cdb
	cp initial_data/iosxr.xml netsim/p/p1/cdb
	cp initial_data/iosxr.xml netsim/p/p2/cdb
	cp initial_data/iosxr.xml netsim/p/p3/cdb
	cp initial_data/device-icons.xml ncs-cdb
	ncs-netsim ncs-xml-init > ncs-cdb/netsim_devices_init.xml

models: ../../src/model/draft/mef-global.yang ../../src/model/draft/mef-legato-services.yang ../../src/model/draft/mef-legato-interfaces.yang
	mkdir -p ../../build
	sed -e"s/YYYY-MM-DD/$(shell date +%Y-%m-%d)/" ../../src/model/draft/mef-global.yang  > ../../build/mef-global\@$(shell date +%Y-%m-%d).yang
	sed -e"s/YYYY-MM-DD/$(shell date +%Y-%m-%d)/" ../../src/model/draft/mef-legato-services.yang  > ../../build/mef-legato-services\@$(shell date +%Y-%m-%d).yang
	sed -e"s/YYYY-MM-DD/$(shell date +%Y-%m-%d)/" ../../src/model/draft/mef-legato-interfaces.yang  > ../../build/mef-legato-interfaces\@$(shell date +%Y-%m-%d).yang
	sed -e"s/YYYY-MM-DD/$(shell date +%Y-%m-%d)/" ../../src/model/draft/common/mef-types.yang  > ../../build/mef-types\@$(shell date +%Y-%m-%d).yang

	ln -fs ../../../../../../build/mef-global\@$(shell date +%Y-%m-%d).yang packages/mef/src/yang/mef-global.yang
	ln -fs ../../../../../../build/mef-legato-services\@$(shell date +%Y-%m-%d).yang packages/mef/src/yang/mef-legato-services.yang
	ln -fs ../../../../../../build/mef-legato-interfaces\@$(shell date +%Y-%m-%d).yang packages/mef/src/yang/mef-legato-interfaces.yang
	ln -fs ../../../../../../build/mef-types\@$(shell date +%Y-%m-%d).yang packages/mef/src/yang/mef-types.yang

	cd ../../build; ./gen-trees.sh;

#Patch to add ios-stats
packages/cisco-ios:
	ln -s $(NCS_DIR)/packages/neds/cisco-ios packages/cisco-ios

packages/juniper-junos:
	ln -s $(NCS_DIR)/packages/neds/juniper-junos packages/juniper-junos

packages/cisco-iosxr:
	ln -s $(NCS_DIR)/packages/neds/cisco-iosxr packages/cisco-iosxr

clean:
	for i in $(PACKAGES); do \
		$(MAKE) -C packages/$${i}/src clean || exit 1; \
	done
	rm -rf netsim running.DB logs/* state/* ncs-cdb/*.cdb *.trace
	rm -f packages/cisco-ios
	rm -f packages/juniper-junos
	rm -f packages/cisco-iosxr
	rm -rf bin
	rm -rf ncs-cdb/*.xml
	-rm -rf ../../build/mef-*\@*.yang
	-rm -rf ../../build/mef-*-tree.txt
	-rm -rf ../../build/mef-*.json
	-rm -rf packages/mef/src/yang/mef-legato-*.yang
	-rm -rf packages/mef/src/yang/mef-types.yang
	-rm -rf ../../build/Legato-YANG-Machinefiles*

.PHONY: package-archives
package-archives: all
	mkdir -p package-archives
	for package_name in $(PACKAGES); do \
		cd packages/$${package_name}; \
		package_version=$$(cat package-meta-data.xml | grep package-version | sed 's/.*<package-version>\(.*\)<\/package-version>/\1/g'); \
		cd ..; \
		tar -cz $${package_name} > ../package-archives/ncs-$$(ncs --version)-$${package_name}-$${package_version}.tar.gz; \
		cd ..; \
	done


start:
	ncs-netsim start
	ncs

stop:
	-ncs-netsim stop
	-ncs --stop

reset:
	ncs-setup --reset

cli:
	ncs_cli -u admin

test:
	test/run_tests.sh

settest:
	test/run_tests.sh --set-out

zip:
	mkdir -p ../../build/Legato-YANG-Machinefiles
	-rm -rf  ../../build/Legato-YANG-Machinefiles.zip
	cp ../../build/mef-*\@$(shell date +%Y-%m-%d)*.* ../../build/Legato-YANG-Machinefiles
	cp MEF6.2-a1-example.xml ../../build/Legato-YANG-Machinefiles
	zip -r ../../build/Legato-YANG-Machinefiles.zip ../../build/Legato-YANG-Machinefiles
        