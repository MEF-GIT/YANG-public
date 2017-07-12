#!/bin/sh

# Test for MEF 10.3 [R4]. Use EP-TREE Use Case 1 root UNI.
{ ncs_cli -u admin -C << EOF;
config
!
mef-services mef-service EVC-0001911-ACME-MEGAMART end-points end-point MMPOP1-ce5-Slot5-Port2 role leaf 
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*one or more UNI Roles must be root.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R4: Fail - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R4: PASS';
fi

# Test for MEF 10.3 [R9 B P2P]. This test should fail to commit with "If EVC Type is Point-to-Point, there must be exactly 2 UNI configured for the EVC.".
{ ncs_cli -u admin -C << EOF;
config
! 
no mef-services mef-service EVC-0001898-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot1-Port1
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*there must be exactly 2 UNI configured for the EVC.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R9B P2P: Fail - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R9B P2P: PASS';
fi

# Test for MEF 10.3 [R9 B M2M1]. This test should fail to commit with "If EVC Type is Multipoint-to-Multipoint, there must be at least 2 and no more than 'max-num-of-evc-end-point' UNI configured for the EVC.".
{ ncs_cli -u admin -C << EOF;
config
!
mef-interfaces unis uni MMPOP1-ce8-Slot8-Port1 admin-state false max-svc-frame-size 1600 max-num-of-evcs 1 all-to-one-bundling-enabled true physical-layers links link ce8 GigabitEthernet0/1 ieee8023-phy ieee8023-1000BASE-SX
mef-interfaces unis uni MMPOP1-ce8-Slot8-Port1  ce-vlans ce-vlan 1
mef-services mef-service EVC-0001901-ACME-MEGAMART end-points end-point MMPOP1-ce8-Slot8-Port1 role root ce-vlans ce-vlan 1
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*UNI configured for the EVC.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R9B M2M1: Fail - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R9B M2M1: PASS';
fi

# Test for MEF 10.3 [R9 B M2M2]. This test should fail to commit with "If EVC Type is Multipoint-to-Multipoint, there must be at least 2 and no more than 'max-num-of-evc-end-point' UNI configured for the EVC.".
{ ncs_cli -u admin -C << EOF;
config
!
no mef-services mef-service EVC-0001901-ACME-MEGAMART end-points end-point MMPOP1-ce6-Slot6-Port1 
no mef-services mef-service EVC-0001901-ACME-MEGAMART end-points end-point MMPOP1-ce7-Slot7-Port1 
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*UNI configured for the EVC.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R9B M2M2: Fail - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R9B M2M2: PASS';
fi

# Test for MEF 10.3 [R9 B RM1]. This test should fail to commit with "If EVC Type is Rooted-Multipoint, there must be at least 2 and no more than 'max-num-of-evc-end-point' UNI configured for the EVC.".
{ ncs_cli -u admin -C << EOF;
config
!
mef-interfaces unis uni MMPOP1-ce8-Slot8-Port1 admin-state false max-svc-frame-size 1600 max-num-of-evcs 1 all-to-one-bundling-enabled true physical-layers links link ce8 GigabitEthernet0/1 ieee8023-phy ieee8023-1000BASE-SX
mef-interfaces unis uni MMPOP1-ce8-Slot8-Port1  ce-vlans ce-vlan 1
mef-services mef-service EVC-0001911-ACME-MEGAMART end-points end-point MMPOP1-ce8-Slot8-Port1 role leaf source-mac-address-limit-enabled true ce-vlans ce-vlan 1 
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*UNI configured for the EVC.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R9B RM1: Fail - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R9B RM1: PASS';
fi

# Test for MEF 10.3 [R9 B RM2]. This test should fail to commit with "If EVC Type is Rooted-Multipoint, there must be at least 2 and no more than 'max-num-of-evc-end-point' UNI configured for the EVC.".
{ ncs_cli -u admin -C << EOF;
config
!
no mef-services mef-service EVC-0001911-ACME-MEGAMART end-points end-point MMPOP1-ce6-Slot6-Port2
no mef-services mef-service EVC-0001911-ACME-MEGAMART end-points end-point MMPOP1-ce7-Slot7-Port2
no mef-services mef-service EVC-0001911-ACME-MEGAMART end-points end-point MMPOP1-ce8-Slot8-Port2
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*UNI configured for the EVC.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R9B RM2: Fail - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R9B RM2: PASS';
fi

# Test for MEF 10.3 [R12A P2P] This test should fail to commit with "If EVC Type is Point-to-Point, all UNI Roles must be root.".
{ ncs_cli -u admin -C << EOF;
config
!
mef-services mef-service EVC-0001898-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot1-Port1 role leaf 
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*all UNI Roles must be root.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R12A P2P: Fail - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R12A P2P: PASS';
fi

# Test for MEF 10.3 [R12A M2M] This test should fail to commit with "If EVC Type is Multipoint-to-Multipoint, all UNI Roles must be root.".
{ ncs_cli -u admin -C << EOF;
config
!
mef-services mef-service EVC-0001901-ACME-MEGAMART end-points end-point MMPOP1-ce7-Slot7-Port1 role leaf
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*all UNI Roles must be root.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R12A M2M: Fail - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R12A M2M: PASS';
fi

# Test for MEF 10.3 [R13]. This test should fail to commit with "If EVC Type is Point-to-Point, the value of max-num-of-evc-end-point must be 2.".
{ ncs_cli -u admin -C << EOF;
config
!
mef-services mef-service EVC-0001898-ACME-MEGAMART max-num-of-evc-end-point 3
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*the value of max-num-of-evc-end-point must be 2.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R13: Fail - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R13: PASS';
fi

# Test for MEF 10.3 [R14] and MEF 6.2 [R54]. This test should fail to commit with "If EVC Type is Multipoint-to-Multipoint, the value of max-num-of-evc-end-point must be at least 3.".
{ ncs_cli -u admin -C << EOF;
config
!
mef-services mef-service EVC-0001901-ACME-MEGAMART max-num-of-evc-end-point 2
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*the value of max-num-of-evc-end-point must be at least 3.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R14: Fail - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R14: PASS';
fi

# Test for MEF 10.3 [R25]. This test should fail to commit with "When more than one CE-VLAN-ID is mapped to an EVC at a UNI, the EVC must have CE-VLAN ID Preservation Enabled.".
{ ncs_cli -u admin -C << EOF;
config
!
mef-services mef-service EVC-0001944-ACME-MEGAMART ce-vlan-id-preservation false
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*the EVC must have CE-VLAN ID Preservation Enabled.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R25: Fail - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R25: PASS';
fi

# Test for MEF 10.3 [R32A]. This test should fail to commit with "The EVC Performance SLS Exclusions and Inclusions List cannot both be configured for an EVC.".
{ ncs_cli -u admin -C << EOF;
config
!
mef-services mef-service EVC-0001898-ACME-MEGAMART carrier-ethernet-sls sls-id MEF103_Table25 cos-entries cos-entry Krypton pm-entries pm-entry SLS_Krypton_Test1 end-point-pairs sls-uni-exclusions end-point-pair MMPOP1-ce1-Slot1-Port1 MMPOP1-ce0-Slot0-Port1
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*SLS Exclusions and Inclusions List cannot both be configured for an EVC.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R32A: Fail - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R32A: PASS';
fi

# Test for MEF 10.3 [R32B]. This test should fail to commit with "The two UNI IDs for a given inclusion cannot be the same.".
{ ncs_cli -u admin -C << EOF;
config
!
mef-services mef-service EVC-0001898-ACME-MEGAMART carrier-ethernet-sls sls-id MEF103_Table25 cos-entries cos-entry Krypton pm-entries pm-entry SLS_Krypton_Test1 end-point-pairs sls-uni-inclusions end-point-pair MMPOP1-ce1-Slot1-Port1 MMPOP1-ce1-Slot1-Port1
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*two UNI IDs for a given inclusion cannot be the same.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R32B: Fail - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R32B: PASS';
fi

# Test for MEF 10.3 [R32C]. This test should fail to commit with "The two UNI IDs for a given exclusion cannot be the same.".
{ ncs_cli -u admin -C << EOF;
config
!
mef-services mef-service EVC-0001343-ACME-MEGAMART carrier-ethernet-sls sls-id MEF103_Table25 cos-entries cos-entry Neon pm-entries pm-entry SLS_Neon_Test2 end-point-pairs sls-uni-exclusions end-point-pair MMPOP1-ce1-Slot1-Port3 MMPOP1-ce1-Slot1-Port3
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*two UNI IDs for a given exclusion cannot be the same.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R32C: Fail - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R32C: PASS';
fi

# Test for MEF 10.3 [R37A]. This test should fail to commit with "If EVC Type is Rooted-Multipoint, sls-uni-inclusions must be used instead of sls-uni-exclusions.".
{ ncs_cli -u admin -C << EOF;
config
!
mef-services mef-service EVC-0001911-ACME-MEGAMART carrier-ethernet-sls sls-id MEF103_Table25 cos-entries cos-entry Neon pm-entries pm-entry SLS_Neon_Test2 end-point-pairs sls-uni-exclusions end-point-pair MMPOP1-ce6-Slot6-Port2 MMPOP1-ce7-Slot7-Port2
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*Rooted-Multipoint, sls-uni-inclusions must be used instead of sls-uni-exclusions.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R37A: Fail - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R37A: PASS';
fi

# Test for MEF 10.3 [R37B]. This test should fail to commit with "If EVC Type is Rooted-Multipoint, sls-uni-inclusion UNI Pairs cannot both be role 'leaf'.".
{ ncs_cli -u admin -C << EOF;
config
!
mef-services mef-service EVC-0001911-ACME-MEGAMART carrier-ethernet-sls sls-id MEF103_Table25 cos-entries cos-entry Neon pm-entries pm-entry SLS_Neon_Test2 end-point-pairs sls-uni-inclusions end-point-pair MMPOP1-ce6-Slot6-Port2 MMPOP1-ce7-Slot7-Port2
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*Rooted-Multipoint, sls-uni-inclusion UNI Pairs cannot both be role*.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R37B: Fail - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R37B: PASS';
fi

# Test for MEF 10.3 [R54]. This test should fail to commit with "If EVC Type is Rooted-Multipoint, one or more UNI Roles must be root.".
{ ncs_cli -u admin -C << EOF;
config
!
mef-services mef-service EVC-0001911-ACME-MEGAMART end-points end-point MMPOP1-ce5-Slot5-Port2 role leaf
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*one or more UNI Roles must be root.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R54: Fail - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R54: PASS';
fi

# Test for MEF 10.3 [R59].  Character restriction testing is TBD.

# Test for MEF 10.3 [R60A]. This test should fail to commit with "The Physical Layer for each physical link implementing the UNI cannot be 1000BASE-PX-D and 1000BASE-PX-U.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce1-Slot1-Port1 physical-layers links link ce1 GigabitEthernet0/1 ieee8023-phy ieee8023-1000BASE-PX-U
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*1000BASE-PX-D and 1000BASE-PX-U.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R60A: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R60A: PASS';
fi

# Test for MEF 10.3 [R60B]. This test should fail to commit with "The Physical Layer for each physical link implementing the UNI cannot be 1000BASE-PX-D and 1000BASE-PX-U.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce1-Slot1-Port1 physical-layers links link ce1 GigabitEthernet0/1 ieee8023-phy ieee8023-1000BASE-PX-D
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*1000BASE-PX-D and 1000BASE-PX-U.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R60B: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R60B: PASS';
fi

# Test for MEF 10.3 [R62]. This test should fail to commit with "The quality of the clock reference must be set if Synchronous Mode is enabled.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce1-Slot1-Port1 physical-layers links link ce1 GigabitEthernet0/1 sync-mode true
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*must be set if Synchronous Mode is enabled.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R62: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R62: PASS';
fi

# Test for MEF 10.3 [R64]. NOTE: LAG not tested yet. This test should fail to commit with "If link-aggregation is 'none', number-of-links must be 1.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce1-Slot1-Port1 link-aggregation none physical-layers number-of-links 2 links link ce1 GigabitEthernet0/2
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*number-of-links must be 1.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R64: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R64: PASS';
fi

# Test for MEF 10.3 [R65]. This test should fail to commit with "If link-aggregation is 'dual-link-aggregation', number-of-links must be 2.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce1-Slot1-Port1 link-aggregation dual-link-aggregation
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*number-of-links must be 2.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R65: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R65: PASS';
fi

# Test for MEF 10.3 [R67]. This test should fail to commit with "If link-aggregation is 'other', number-of-links must be 3 or greater.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce1-Slot1-Port1 link-aggregation other
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*number-of-links must be 3 or greater.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R67: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R67: PASS';
fi

# Test for MEF 10.3 [R77]. This test should fail to commit with "If both Bundling and All-to-One Bundling are disabled for a UNI, only one CE VLAN ID can be configured for a specific EVC on that UNI.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce0-Slot0-Port3 ce-vlans ce-vlan 1
mef-services mef-service EVC-0001900-ACME-MEGAMART ce-vlan-id-preservation true end-points end-point MMPOP1-ce0-Slot0-Port3 ce-vlans ce-vlan 1
mef-services mef-service EVC-0001900-ACME-MEGAMART ce-vlan-id-preservation true end-points end-point MMPOP1-ce2-Slot2-Port3 ce-vlans ce-vlan 1
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*only one CE VLAN ID can be configured for a specific EVC on that UNI.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R77: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R77: PASS';
fi

# Test for MEF 10.3 [R81].  This test should fail to commit with "If more than one CE-VLAN ID is configured for a UNI as part of an EVC, every CE VLAN-ID mapped to that EVC must be configured for all UNIs within that EVC.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce0-Slot0-Port1 ce-vlans ce-vlan 103
mef-services mef-service EVC-0001898-ACME-MEGAMART end-points end-point MMPOP1-ce0-Slot0-Port1 ce-vlans ce-vlan 103
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.* to that EVC must be configured for all UNIs within that EVC.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [R81]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [R81]: PASS';
fi

# Test for MEF 10.3 [R82].  This test should fail to commit with "If All-to-One Bundling is enabled for any UNI in an EVC, all CE-VLAN IDs mapped to any EVC for that UNI must map to the same EVC ID.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-1101898-ACME-MEGAMART user-label NegativeTunnel svc-type epl connection-type point-to-point max-num-of-evc-end-point 2 ce-vlan-id-preservation true ce-vlan-pcp-preservation true
mef-services mef-service EVC-1101898-ACME-MEGAMART end-points end-point MMPOP1-ce0-Slot0-Port1 role root source-mac-address-limit-enabled false ce-vlans ce-vlan 100
mef-services mef-service EVC-1101898-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot1-Port1 role root source-mac-address-limit-enabled false ce-vlans ce-vlan 100
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*all CE-VLAN IDs mapped to any EVC for that UNI must map to the same EVC ID.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [R82]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [R82]: PASS';
fi

# Test for MEF 10.3 [R88].  This test should fail to commit with "ELMI Profile must be set if ELMI is Enabled.".
{ ncs_cli -u admin -C << EOF;
config
no mef-interfaces unis uni MMPOP1-ce0-Slot0-Port1 elmi-profile
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*Profile must be set if ELMI is Enabled.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [R88]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [R88]: PASS';
fi

# Test for MEF 10.3 [R111A].  This test should fail to commit with "When the Class of Service Identifier is based on PCP for a given EVC at a given UNI, the Color Identifier must be based on either DEI or PCP.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-0001898-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot1-Port1 cos-identifier MEF103_Table13
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*UNI, the Color Identifier must be based on either DEI or PCP.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [R111A]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [R111A]: PASS';
fi

# Test for MEF 10.3 [R111B].  This test should fail to commit with "When the Egress Equivalence Class Identifier is based on PCP for a given EVC at a given UNI, the Color Identifier must be based on either DEI or PCP.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-0001898-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot1-Port1 eec-identifier MEF62_ApdxA
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*UNI, the Color Identifier must be based on either DEI or PCP.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [R111B]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [R111B]: PASS';
fi

# Test for MEF 10.3 [R112A].  This test should fail to commit with "When the Class of Service Identifier is based on DSCP for a given EVC at a given UNI, the Color Identifier must be based DSCP.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-0001899-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot1-Port3 cos-identifier MEF103_Table23
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*UNI, the Color Identifier must be based DSCP.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [R112A]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [R112A]: PASS';
fi

# Test for MEF 10.3 [R112B].  This test should fail to commit with "When the Egress Equivalence Class Identifier is based on DSCP for a given EVC at a given UNI, the Color Identifier must be based on DSCP.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-0001899-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot1-Port3 eec-identifier MEF103_Table23
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*UNI, the Color Identifier must be based DSCP.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [R112B]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [R112B]: PASS';
fi

# Test for MEF 10.3 [R140]. Character Restriction Tests are TBD.

# Test for MEF 10.3 [R142A].  This test should fail to commit with "When only one Bandwidth Profile Flow is mapped to an envelope, Envelope Coupling must be Disabled.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce2-Slot2-Port1 ingress-envelopes envelope MM_EPL_Medium coupling-enabled true
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*is mapped to an envelope, Envelope Coupling must be Disabled.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [R142A]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [R142A]: PASS';
fi

# Test for MEF 10.3 [R142B].  This test should fail to commit with "When only one Bandwidth Profile Flow is mapped to an envelope, Envelope Coupling must be Disabled.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce2-Slot2-Port1 egress-envelopes envelope eMM_EPL_Medium coupling-enabled true
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*is mapped to an envelope, Envelope Coupling must be Disabled.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [R142B]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [R142B]: PASS';
fi
# Test for MEF 10.3 [R150A].  This test should fail to commit with "If an Egress Envelope's Coupling Flag is Enabled, then the Coupling Flags must be disabled for all Bandwidth Profile Flows mapped to the Envelope.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce2-Slot2-Port1 token-share-enabled true
mef-interfaces unis uni MMPOP1-ce2-Slot2-Port1 egress-envelopes envelope eMM_EPL_Medium coupling-enabled true bwp-flows bwp-flow high2-bwp-uni
mef-global profiles egress-bwp-flows bwp-flow high2-bwp-uni coupling-enabled true
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*disabled for all Bandwidth Profile Flows mapped to the Envelope.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [R150A]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [R150A]: PASS';
fi

# Test for MEF 10.3 [R150B].  This test should fail to commit with "If an Ingress Envelope's Coupling Flag is Enabled, then the Coupling Flags must be disabled for all Bandwidth Profile Flows mapped to the Envelope.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce2-Slot2-Port1 token-share-enabled true
mef-interfaces unis uni MMPOP1-ce2-Slot2-Port1 ingress-envelopes envelope MM_EPL_Medium coupling-enabled true bwp-flows bwp-flow high1-bwp-uni
mef-global profiles ingress-bwp-flows bwp-flow high1-bwp-uni coupling-enabled true
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*disabled for all Bandwidth Profile Flows mapped to the Envelope.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [R150B]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [R150B]: PASS';
fi

# Test for MEF 10.3 [O8A].  This test should fail to commit with "If there is a per UNI Ingress Bandwidth Profile, then there cannot be any other Ingress Bandwidth Profiles at that UNI.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce8-Slot8-Port3 ingress-bw-profile-per-uni high1-bwp-uni
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*there cannot be any other Ingress Bandwidth Profiles at that UNI.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [O8A]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [O8A]: PASS';
fi

# Test for MEF 10.3 [O8B].  This test should fail to commit with "If there is a per EVC Ingress Bandwidth Profile on an EVC, then there cannot be any per Class of Service Ingress Bandwidth Profiles on that EVC.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-0001944-ACME-MEGAMART end-points end-point MMPOP1-ce5-Slot5-Port3 ingress-bw-profile-per-evc ienv_EVPLAN_UNI553_EVC-0001944_Neon
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*there cannot be any per Class of Service Ingress Bandwidth Profiles on that EVC.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [O8B]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [O8B]: PASS';
fi

# Test for MEF 10.3 [O9A].  This test should fail to commit with "If there is a per UNI Egress Bandwidth Profile, then there cannot be any other Egress Bandwidth Profiles at that UNI.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce8-Slot8-Port3 egress-bw-profile-per-uni high1-bwp-uni
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*there cannot be any other Egress Bandwidth Profiles at that UNI.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [O9A]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [O9A]: PASS';
fi

# Test for MEF 10.3 [O9B].  This test should fail to commit with "If there is a per EVC Egress Bandwidth Profile on an EVC, then there cannot be any per Egress Equivalence Class Identifier Bandwidth Profiles on that EVC.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-0001944-ACME-MEGAMART end-points end-point MMPOP1-ce5-Slot5-Port3 egress-bw-profile-per-evc eenv_EVPLAN_UNI553_EVC-0001944_Neon
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*there cannot be any per Egress Equivalence Class Identifier Bandwidth Profiles on that EVC.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [O9B]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [O9B]: PASS';
fi

#  MEF 6.2 Tests

echo "\nMEF 6.2 EPL Testing\n";

# Test for MEF 6.2 [R3A] Problem.  This test should fail to commit with "A UNI with Token Share Disabled MUST have exactly one Bandwidth Profile Flow per envelope.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce0-Slot0-Port3 ingress-envelopes envelope ienv_EVPL_UNI003_EVC-0001899-ACME-MEGAMART bwp-flows bwp-flow high1-bwp-uni
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*Token Share Disabled MUST have exactly one Bandwidth Profile Flow per envelope.'
if [ $? != 0 ]; then
   echo 'Test MEF 6.2 [R3A]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 6.2 [R3A]: PASS';
fi

# Test for MEF 6.2 [R3B].  This test should fail to commit with "A UNI with Token Share Disabled MUST have exactly one Bandwidth Profile Flow per envelope.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce0-Slot0-Port3 egress-envelopes envelope eenv_EVPL_UNI003_EVC-0001899-ACME-MEGAMART bwp-flows bwp-flow high1-bwp-uni
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*Token Share Disabled must have exactly one Bandwidth Profile Flow per envelope.'
if [ $? != 0 ]; then
   echo 'Test MEF 6.2 [R3B]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 6.2 [R3B]: PASS';
fi

# Test for MEF 6.2 [R4A].  This test should fail to commit with "If no Ingress Bandwidth Profiles are specied for this UNI (BW Profile Per UNI, BWP Flows Per CoS, nor BW Profile Per EVC), then the UNI Ingress Envelopes list must be empty.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce5-Slot5-Port4 ingress-envelopes envelope ienv_EVPTREE_UNI554_EVC-0002947_Neon coupling-enabled false bwp-flows bwp-flow low1-bwp-uni
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*nor BW Profile Per EVC), then the UNI Ingress Envelopes list must be empty.'
if [ $? != 0 ]; then
   echo 'Test MEF 6.2 [R4A]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 6.2 [R4A]: PASS';
fi

# Test for MEF 6.2 [R4B].  This test should fail to commit with "If no Egress Bandwidth Profiles are specied for this UNI (BW Profile Per UNI, BWP Flows Per EEC, nor BW Profile Per EVC), then the UNI Egress Envelopes list must be empty.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce5-Slot5-Port4 egress-envelopes envelope eenv_EVPTREE_UNI554_EVC-0002947_Neon coupling-enabled false bwp-flows bwp-flow low1-bwp-uni
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*nor BW Profile Per EVC), then the UNI Egress Envelopes list must be empty.'
if [ $? != 0 ]; then
   echo 'Test MEF 6.2 [R4B]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 6.2 [R4B]: PASS';
fi

# Test for MEF 6.2 [R5].  Requirement does not make sense. Bandwidth related.

# Test for MEF 6.2 [R19]. This test should fail to commit with "For EPL, Service Multiplexing must be disabled for all UNIs in the EVC UNI List.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce0-Slot0-Port1 service-multiplexing-enabled true
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*Service Multiplexing must be disabled for all UNIs in the EVC UNI List.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R19: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R19: PASS';
fi


# Test for MEF 6.2 [R20].  This test should fail to commit with "For EPL, Bundling must be disabled for all UNIs in the EVC UNI List.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce0-Slot0-Port1 bundling-enabled true
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*Bundling must be disabled for all UNIs in the EVC UNI List.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R20: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R20: PASS';
fi

# Test for MEF 6.2 [R21].  This test should fail to commit with "For EPL, All-to-One Bundling must be enabled for all UNIs in the EVC UNI List.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce0-Slot0-Port1 bundling-enabled true all-to-one-bundling-enabled false
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*All-to-One Bundling must be enabled for all UNIs in the EVC UNI List.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R21: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R21: PASS';
fi

# Test for MEF 6.2 [R22].  This test should fail to commit with "For EPL, Max EVC Count must be 1 for all UNIs in the EVC UNI List.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce0-Slot0-Port1 max-num-of-evcs 2
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*Max EVC Count must be 1 for all UNIs in the EVC UNI List.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R22: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R22: PASS';
fi

# Test for MEF 6.2 [R23].  This test should fail to commit with "For EPL, Egress Bandwidth Profile per Egress Equivalence Class cannot be set for all UNIs in the EVC per UNI List.".
{ ncs_cli -u admin -C << EOF;
config
no mef-interfaces unis uni MMPOP1-ce0-Slot0-Port1 egress-bw-profile-per-uni
mef-interfaces unis uni MMPOP1-ce0-Slot0-Port1 egress-envelopes envelope eenv_EPL_UNI001_EVC-0001898_Neon coupling-enabled false bwp-flows bwp-flow low1-bwp-uni
mef-services mef-service EVC-0001898-ACME-MEGAMART end-points end-point MMPOP1-ce0-Slot0-Port1 egress-bwp-flows-per-eec coupling-enabled false bwp-flow-per-eec EEC-Neon bw-profile eenv_EPL_UNI001_EVC-0001898_Neon
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*Egress Equivalence Class cannot be set for all UNIs in the EVC per UNI List.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R23: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R23: PASS';
fi

# Test for MEF 6.2 [R24].  This test should fail to commit with "For EPL, Source MAC Address Limit must be disabled.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-0001898-ACME-MEGAMART end-points end-point MMPOP1-ce0-Slot0-Port1 source-mac-address-limit-enabled true
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*Source MAC Address Limit must be disabled.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R24: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R24: PASS';
fi

# Test for MEF 6.2 [R25].  This test should fail to commit with "For EPL, EVC Type must be Point-to-Point.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-0001898-ACME-MEGAMART connection-type multipoint-to-multipoint max-num-of-evc-end-point 3
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*EVC Type must be Point-to-Point.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R25: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R25: PASS';
fi

# Test for MEF 6.2 [R26].  This test should fail to commit with "For EPL, unicast-frame-delivery must be unconditional.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-0001898-ACME-MEGAMART unicast-frame-delivery conditional
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*unicast-frame-delivery must be unconditional.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R26: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R26: PASS';
fi

# Test for MEF 6.2 [R27].  This test should fail to commit with "For EPL, multicast-frame-delivery must be unconditional.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-0001898-ACME-MEGAMART multicast-frame-delivery conditional
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*multicast-frame-delivery must be unconditional.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R27: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R27: PASS';
fi

# Test for MEF 6.2 [R28].  This test should fail to commit with "For EPL, broadcast-frame-delivery must be unconditional.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-0001898-ACME-MEGAMART broadcast-frame-delivery conditional
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*broadcast-frame-delivery must be unconditional.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R28: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R28: PASS';
fi

# Test for MEF 6.2 [R29].  This test should fail to commit with "For EPL, CE-VLAN ID Preservation must be enabled.".
{ ncs_cli -u admin -C << EOF;
config
no mef-services mef-service EVC-0001898-ACME-MEGAMART end-points end-point MMPOP1-ce0-Slot0-Port1 ce-vlans ce-vlan 101
no mef-services mef-service EVC-0001898-ACME-MEGAMART end-points end-point MMPOP1-ce0-Slot0-Port1 ce-vlans ce-vlan 102
no mef-services mef-service EVC-0001898-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot1-Port1 ce-vlans ce-vlan 101
no mef-services mef-service EVC-0001898-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot1-Port1 ce-vlans ce-vlan 102
mef-services mef-service EVC-0001898-ACME-MEGAMART ce-vlan-id-preservation false
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*CE-VLAN ID Preservation must be enabled.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R29: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R29: PASS';
fi

# Test for MEF 6.2 [R30].  This test should fail to commit with "For EPL, CE-VLAN ID CoS Preservation must be enabled.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-0001898-ACME-MEGAMART ce-vlan-pcp-preservation false
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*CE-VLAN ID CoS Preservation must be enabled.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R30: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R30: PASS';
fi

echo "\nMEF 6.2 EVPL Testing\n";

# Test for MEF 6.2 [R31].  This test should fail to commit with "For EVPL, All-to-One Bundling must be disabled for all UNIs in the EVC UNI List.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-0001898-ACME-MEGAMART svc-type evpl ce-vlan-pcp-preservation false
no mef-interfaces unis uni MMPOP1-ce0-Slot0-Port1 ce-vlans ce-vlan 1
no mef-interfaces unis uni MMPOP1-ce0-Slot0-Port1 ce-vlans ce-vlan 101
no mef-interfaces unis uni MMPOP1-ce0-Slot0-Port1 ce-vlans ce-vlan 102
no mef-interfaces unis uni MMPOP1-ce1-Slot1-Port1 ce-vlans ce-vlan 1
no mef-interfaces unis uni MMPOP1-ce1-Slot1-Port1 ce-vlans ce-vlan 101
no mef-interfaces unis uni MMPOP1-ce1-Slot1-Port1 ce-vlans ce-vlan 102
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*All-to-One Bundling must be disabled for all UNIs in the EVC UNI List.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R31: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R31: PASS';
fi

# Test for MEF 6.2 [R32].  This test should fail to commit with "For EVPL, Source MAC Address Limit must be disabled for all UNIs in the EVC per UNI List if all 3 -svc-frm-delivery values are unconditional.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-0001899-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot1-Port3 source-mac-address-limit-enabled true
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*EVC per UNI List if all 3 -svc-frm-delivery values are unconditional.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R32: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R32: PASS';
fi

# Test for MEF 6.2 [R33].  This test should fail to commit with "For EVPL, EVC Type must be Point-to-Point.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-0001899-ACME-MEGAMART connection-type rooted-multipoint max-num-of-evc-end-point 3 unicast-frame-delivery conditional
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*EVC Type must be Point-to-Point.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R33: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R33: PASS';
fi

echo "\nMEF 6.2 EP-LAN Testing\n";

# Test for MEF 6.2 [R34].  This test should fail to commit with "For EP-LAN, Service Multiplexing must be disabled for all UNIs in the EVC UNI List.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce7-Slot7-Port1 service-multiplexing-enabled true
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*Service Multiplexing must be disabled for all UNIs in the EVC UNI List.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R34: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R34: PASS';
fi

# Test for MEF 6.2 [R35].  This test should fail to commit with "For EP-LAN, Bundling must be disabled for all UNIs in the EVC UNI List.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce7-Slot7-Port1 bundling-enabled true
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*Bundling must be disabled for all UNIs in the EVC UNI List.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R35: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R35: PASS';
fi

# Test for MEF 6.2 [R36].  This test should fail to commit with "For EP-LAN, All-to-One Bundling must be enabled for all UNIs in the EVC UNI List.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce7-Slot7-Port1 all-to-one-bundling-enabled false
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*All-to-One Bundling must be enabled for all UNIs in the EVC UNI List.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R36: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R36: PASS';
fi


# Test for MEF 6.2 [R37].  This test should fail to commit with "For EP-LAN, Max EVC Count must be 1 for all UNIs in the EVC UNI List.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce7-Slot7-Port1 max-num-of-evcs 2
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*Max EVC Count must be 1 for all UNIs in the EVC UNI List.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R37: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R37: PASS';
fi

# Test for MEF 6.2 [R38].  This test should fail to commit with "For EP-LAN, EVC Type must be Multipoint-to-Multipoint.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-0001901-ACME-MEGAMART connection-type rooted-multipoint
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*EVC Type must be Multipoint-to-Multipoint.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R38: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R38: PASS';
fi

# Test for MEF 6.2 [R39].  This test should fail to commit with "For EP-LAN, CE-VLAN ID Preservation must be enabled.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-0001901-ACME-MEGAMART ce-vlan-id-preservation false
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*CE-VLAN ID Preservation must be enabled.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R39: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R39: PASS';
fi

# Test for MEF 6.2 [R40].  This test should fail to commit with "For EP-LAN, CE-VLAN ID CoS Preservation must be enabled.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-0001901-ACME-MEGAMART ce-vlan-pcp-preservation false
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*CE-VLAN ID CoS Preservation must be enabled.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R40: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R40: PASS';
fi

echo "\nMEF 6.2 EVP-LAN Testing\n";

# Test for MEF 6.2 [R41].  This test should fail to commit with "For EVP-LAN, All-to-One Bundling must be disabled for all UNIs in the EVC UNI List.".
{ ncs_cli -u admin -C << EOF;
config
no mef-services mef-service EVC-0002947-ACME-MEGAMART end-points end-point MMPOP1-ce7-Slot7-Port3 ce-vlans ce-vlan 153
no mef-services mef-service EVC-0002947-ACME-MEGAMART end-points end-point MMPOP1-ce7-Slot7-Port3
no mef-interfaces unis uni MMPOP1-ce7-Slot7-Port3 ce-vlans ce-vlan 153
mef-interfaces unis uni MMPOP1-ce7-Slot7-Port3 all-to-one-bundling-enabled true
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*All-to-One Bundling must be disabled for all UNIs in the EVC UNI List.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R41: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R41: PASS';
fi

# Test for MEF 6.2 [R42].  This test should fail to commit with "For EVP-LAN, EVC Type must be Multipoint-to-Multipoint.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-0001944-ACME-MEGAMART connection-type rooted-multipoint
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*EVC Type must be Multipoint-to-Multipoint.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R42: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R42: PASS';
fi

echo "\nMEF 6.2 EP-TREE Testing\n";

# Test for MEF 6.2 [R43].  This test should fail to commit with "For EP-TREE, Service Multiplexing must be disabled for all UNIs in the EVC UNI List.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce6-Slot6-Port2 service-multiplexing-enabled true
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*Service Multiplexing must be disabled for all UNIs in the EVC UNI List.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R43: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R43: PASS';
fi

# Test for MEF 6.2 [R44].  This test should fail to commit with "For EP-TREE, Bundling must be disabled for all UNIs in the EVC UNI List.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce6-Slot6-Port2 bundling-enabled true
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*Bundling must be disabled for all UNIs in the EVC UNI List.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R44: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R44: PASS';
fi

# Test for MEF 6.2 [R45].  This test should fail to commit with "For EP-TREE, All-to-One Bundling must be enabled for all UNIs in the EVC UNI List.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce6-Slot6-Port2 all-to-one-bundling-enabled false
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*All-to-One Bundling must be enabled for all UNIs in the EVC UNI List.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R45: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R45: PASS';
fi

# Test for MEF 6.2 [R46].  This test should fail to commit with "For EP-TREE, Max EVC Count must be 1 for all UNIs in the EVC UNI List.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce6-Slot6-Port2 max-num-of-evcs 2
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*Max EVC Count must be 1 for all UNIs in the EVC UNI List.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R46: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R46: PASS';
fi

# Test for MEF 6.2 [R47].  This test should fail to commit with "For EP-TREE, EVC Type must be Rooted-Multipoint.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-0001911-ACME-MEGAMART end-points end-point MMPOP1-ce6-Slot6-Port2 role root
no mef-services mef-service EVC-0001911-ACME-MEGAMART end-points end-point MMPOP1-ce7-Slot7-Port2
no mef-services mef-service EVC-0001911-ACME-MEGAMART end-points end-point MMPOP1-ce8-Slot8-Port2
mef-services mef-service EVC-0001911-ACME-MEGAMART connection-type point-to-point max-num-of-evc-end-point 2
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*EVC Type must be Rooted-Multipoint.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R47: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R47: PASS';
fi

# Test for MEF 6.2 [R48].  This requirement is redundant with MEF 10.3 requirements for EVC Type [R14].

# Test for MEF 6.2 [R49].  This test should fail to commit with "For EP-TREE, CE-VLAN ID Preservation must be enabled.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-0001911-ACME-MEGAMART ce-vlan-id-preservation false
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*CE-VLAN ID Preservation must be enabled.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R49: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R49: PASS';
fi

# Test for MEF 6.2 [R50].  This test should fail to commit with "For EP-TREE, CE-VLAN ID CoS Preservation must be enabled.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-0001911-ACME-MEGAMART ce-vlan-pcp-preservation false
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*CE-VLAN ID CoS Preservation must be enabled.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R50: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R50: PASS';
fi

echo "\nMEF 6.2 EVP-TREE Testing\n";

# Test for MEF 6.2 [R51].  This test should fail to commit with "For EVP-TREE, All-to-One Bundling must be disabled for all UNIs in the EVC UNI List.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce5-Slot5-Port4 all-to-one-bundling-enabled true
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*All-to-One Bundling must be disabled for all UNIs in the EVC UNI List.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R51: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R51: PASS';
fi

# Test for MEF 6.2 [R52].  This test should fail to commit with "For EVP-TREE, EVC Type must be Rooted-Multipoint.".
{ ncs_cli -u admin -C << EOF;
config
mef-services mef-service EVC-0002947-ACME-MEGAMART end-points end-point MMPOP1-ce6-Slot6-Port3 role root
no mef-services mef-service EVC-0002947-ACME-MEGAMART end-points end-point MMPOP1-ce7-Slot7-Port3
no mef-services mef-service EVC-0002947-ACME-MEGAMART end-points end-point MMPOP1-ce8-Slot8-Port3
mef-services mef-service EVC-0002947-ACME-MEGAMART connection-type point-to-point max-num-of-evc-end-point 2
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*EVC Type must be Rooted-Multipoint.'
if [ $? != 0 ]; then
   echo 'Test 6.2 R52: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 6.2 R52: PASS';
fi

# Test for MEF 6.2 [R53A].  This requirement is redundant with MEF 10.3 requirements for EVC Type [R14].
# Test for MEF 6.2 [R53B].  This requirement is redundant with MEF 10.3 requirements for EVC Type [R14].
# Test for MEF 6.2 [R54].  This requirement is redundant with MEF 10.3 requirements for EVC Type [R14].

echo "\nMEF 6.2 Testing Complete\n";


