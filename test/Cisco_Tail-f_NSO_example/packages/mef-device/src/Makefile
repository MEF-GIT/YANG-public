all:	fxs javac
	cd ../netsim && $(MAKE) all
# Include standard NCS examples build definitions and rules
include $(NCS_DIR)/src/ncs/build/include.ncs.mk


JAVA_PACKAGE = com.example.mefdevice
JDIR = $(shell echo $(JAVA_PACKAGE) | sed 's/\./\//g')
YANGPATH = --yangpath ./yang:../../mef/src/yang:$(NCS_DIR)/src/ncs/snmp/yang
NS  = namespaces

JFLAGS = --java-disable-prefix \
         --exclude-enums \
         --fail-on-warnings \
         --java-package $(JAVA_PACKAGE).$(NS) \
         --emit-java java/src/$(JDIR)/$(NS)

javac:
	cd java && ant -q all
SRC = $(wildcard yang/*.yang ../../mef/src/yang/*.yang)
FXS = $(SRC:yang/%.yang=ncsc-out/modules/fxs/%.fxs)

fxs:	ncsc-out/.done

ncsc-out/.done:	$(SRC)
	$(NCSC) $(YANGPATH) --ncs-compile-bundle yang \
                 --ncs-device-dir ncsc-out   \
                 --ncs-device-type netconf && \
        cp ncsc-out/modules/fxs/*.fxs ../load-dir;
	for f in `echo ../load-dir/*.fxs`; do \
           n=`basename $$f | sed 's/\.fxs//'`; \
	   $(NCSC) $(JFLAGS)/$${n}.java $$f  || exit 1; \
        done
	touch -m ncsc-out/.done

clean:
	rm -rf ncsc-out/* ncsc-out/.done ../fxs/* ../load-dir/*
	cd ../netsim && $(MAKE) clean || true
	rm -f ../*jar/*.jar
	cd java && ant -q clean || true
	rm -f java/src/$(JDIR)/$(NS)/*.java
