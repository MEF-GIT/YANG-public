#!/bin/sh

# Test for MEF 10.3 [R4]. Use EP-TREE Use Case 1 root UNI.
{ ncs_cli -u admin -C << EOF;
config
!
mef-services carrier-ethernet subscriber-services evc EVC-0001911-ACME-MEGAMART end-points end-point MMPOP1-ce5-Slot5-Port2 role leaf 
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
no mef-services carrier-ethernet subscriber-services evc EVC-0001898-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot1-Port1
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
mef-services carrier-ethernet subscriber-services evc EVC-0001901-ACME-MEGAMART end-points end-point MMPOP1-ce8-Slot8-Port1 role root cos-identifier MEF103_Table23 color-identifier dscp eec-identifier MEF103_Table23 ce-vlans ce-vlan 1
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
no mef-services carrier-ethernet subscriber-services evc EVC-0001901-ACME-MEGAMART end-points end-point MMPOP1-ce6-Slot6-Port1 
no mef-services carrier-ethernet subscriber-services evc EVC-0001901-ACME-MEGAMART end-points end-point MMPOP1-ce7-Slot7-Port1 
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
mef-services carrier-ethernet subscriber-services evc EVC-0001911-ACME-MEGAMART end-points end-point MMPOP1-ce8-Slot8-Port1 role leaf cos-identifier MEF103_Table23 color-identifier dscp eec-identifier MEF103_Table23 source-mac-address-limit 10 ce-vlans ce-vlan 1 
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
no mef-services carrier-ethernet subscriber-services evc EVC-0001911-ACME-MEGAMART end-points end-point MMPOP1-ce6-Slot6-Port2
no mef-services carrier-ethernet subscriber-services evc EVC-0001911-ACME-MEGAMART end-points end-point MMPOP1-ce7-Slot7-Port2
no mef-services carrier-ethernet subscriber-services evc EVC-0001911-ACME-MEGAMART end-points end-point MMPOP1-ce8-Slot8-Port2
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
mef-services carrier-ethernet subscriber-services evc EVC-0001898-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot1-Port1 role leaf 
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
mef-services carrier-ethernet subscriber-services evc EVC-0001901-ACME-MEGAMART end-points end-point MMPOP1-ce7-Slot7-Port1 role leaf
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
mef-services carrier-ethernet subscriber-services evc EVC-0001898-ACME-MEGAMART max-num-of-evc-end-point 3
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
mef-services carrier-ethernet subscriber-services evc EVC-0001901-ACME-MEGAMART max-num-of-evc-end-point 2
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
mef-services carrier-ethernet subscriber-services evc EVC-0001944-ACME-MEGAMART ce-vlan-id-preservation false
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
mef-services carrier-ethernet subscriber-services evc EVC-0001898-ACME-MEGAMART carrier-ethernet-sls sls-id MEF103_Table25 cos-entries cos-entry Krypton pm-entries pm-entry SLS_Krypton_Test1 end-point-pairs sls-uni-exclusions end-point-pair MMPOP1-ce1-Slot1-Port1 MMPOP1-ce0-Slot0-Port1
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
mef-services carrier-ethernet subscriber-services evc EVC-0001898-ACME-MEGAMART carrier-ethernet-sls sls-id MEF103_Table25 cos-entries cos-entry Krypton pm-entries pm-entry SLS_Krypton_Test1 end-point-pairs sls-uni-inclusions end-point-pair MMPOP1-ce1-Slot1-Port1 MMPOP1-ce1-Slot1-Port1
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
mef-services carrier-ethernet subscriber-services evc EVC-0001343-ACME-MEGAMART carrier-ethernet-sls sls-id MEF103_Table25 cos-entries cos-entry Neon pm-entries pm-entry SLS_Neon_Test2 end-point-pairs sls-uni-exclusions end-point-pair MMPOP1-ce1-Slot1-Port3 MMPOP1-ce1-Slot1-Port3
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
mef-services carrier-ethernet subscriber-services evc EVC-0001911-ACME-MEGAMART carrier-ethernet-sls sls-id MEF103_Table25 cos-entries cos-entry Neon pm-entries pm-entry SLS_Neon_Test2 end-point-pairs sls-uni-exclusions end-point-pair MMPOP1-ce6-Slot6-Port2 MMPOP1-ce7-Slot7-Port2
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
mef-services carrier-ethernet subscriber-services evc EVC-0001911-ACME-MEGAMART carrier-ethernet-sls sls-id MEF103_Table25 cos-entries cos-entry Neon pm-entries pm-entry SLS_Neon_Test2 end-point-pairs sls-uni-inclusions end-point-pair MMPOP1-ce6-Slot6-Port2 MMPOP1-ce7-Slot7-Port2
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
mef-services carrier-ethernet subscriber-services evc EVC-0001911-ACME-MEGAMART end-points end-point MMPOP1-ce5-Slot5-Port2 role leaf
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
#{ ncs_cli -u admin -C << EOF;
#config
#mef-interfaces unis uni MMPOP1-ce1-Slot1-Port1 physical-layers links link ce1 GigabitEthernet0/1 ieee8023-phy ieee8023-1000BASE-PX-U
#commit
#end no-confirm
#exit
#EOF
#} | grep 'Aborted:.*1000BASE-PX-D and 1000BASE-PX-U.'
#if [ $? != 0 ]; then
#   echo 'Test 10.3 R60A: FAIL - commit did not fail or did not fail as expected'; exit 1;
#else
#   echo 'Test 10.3 R60A: PASS';
#fi

# Test for MEF 10.3 [R60B]. This test should fail to commit with "The Physical Layer for each physical link implementing the UNI cannot be 1000BASE-PX-D and 1000BASE-PX-U.".
#{ ncs_cli -u admin -C << EOF;
#config
#mef-interfaces unis uni MMPOP1-ce1-Slot1-Port1 physical-layers links link ce1 GigabitEthernet0/1 ieee8023-phy ieee8023-1000BASE-PX-D
#commit
#end no-confirm
#exit
#EOF
#} | grep 'Aborted:.*1000BASE-PX-D and 1000BASE-PX-U.'
#if [ $? != 0 ]; then
#   echo 'Test 10.3 R60B: FAIL - commit did not fail or did not fail as expected'; exit 1;
#else
#   echo 'Test 10.3 R60B: PASS';
#fi

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

# Test for MEF 10.3 [R76]. This test should fail to commit with "At each UNI there MUST be a mapping of each CE-VLAN ID to at most one EVC.".
{ ncs_cli -u admin -C << EOF;
config
no mef-services carrier-ethernet subscriber-services evc EVC-0002343-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot0-Port2 ce-vlans ce-vlan 1343
mef-services carrier-ethernet subscriber-services evc EVC-0002343-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot0-Port2 ce-vlans ce-vlan 33
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*At each UNI there MUST be a mapping of each CE-VLAN ID to at most one EVC.'
if [ $? != 0 ]; then
   echo 'Test 10.3 R76: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test 10.3 R76: PASS';
fi

# Test for MEF 10.3 [R77]. This test should fail to commit with "If both Bundling and All-to-One Bundling are disabled for a UNI, only one CE VLAN ID can be configured for a specific EVC on that UNI.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce0-Slot0-Port3 ce-vlans ce-vlan 1
mef-services carrier-ethernet subscriber-services evc EVC-0001900-ACME-MEGAMART ce-vlan-id-preservation true end-points end-point MMPOP1-ce0-Slot0-Port3 ce-vlans ce-vlan 1
mef-services carrier-ethernet subscriber-services evc EVC-0001900-ACME-MEGAMART ce-vlan-id-preservation true end-points end-point MMPOP1-ce2-Slot2-Port3 ce-vlans ce-vlan 1
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
mef-services carrier-ethernet subscriber-services evc EVC-0001898-ACME-MEGAMART end-points end-point MMPOP1-ce0-Slot0-Port1 ce-vlans ce-vlan 103
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

# Test for MEF 10.3 [R82A].  This test should fail to commit with "If All-to-One Bundling is enabled for any UNI in an EVC, all CE-VLAN IDs for that UNI must map to a single EVC.".
{ ncs_cli -u admin -C << EOF;
config
mef-services carrier-ethernet subscriber-services evc EVC-1101898-ACME-MEGAMART svc-type epl connection-type point-to-point max-num-of-evc-end-point 2 ce-vlan-id-preservation true ce-vlan-pcp-preservation true
mef-services carrier-ethernet subscriber-services evc EVC-1101898-ACME-MEGAMART carrier-ethernet-sls sls-id MEF103_Table25 start-time 2016-06-18T12:00:00Z
mef-services carrier-ethernet subscriber-services evc EVC-1101898-ACME-MEGAMART end-points end-point MMPOP1-ce0-Slot0-Port1 role root cos-identifier MEF103_Table23 color-identifier dscp eec-identifier MEF103_Table23 ce-vlans ce-vlan 100
mef-services carrier-ethernet subscriber-services evc EVC-1101898-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot1-Port1 role root cos-identifier MEF103_Table23 color-identifier dscp eec-identifier MEF103_Table23 ce-vlans ce-vlan 100
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*If All-to-One Bundling is enabled for any UNI in an EVC, all CE-VLAN IDs for that UNI must map to a single EVC.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [R82A]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [R82A]: PASS';
fi

# Test for MEF 10.3 [R82B].  This test should fail to commit with "If All-to-One Bundling is enabled for any UNI in an EVC, all CE-VLAN IDs for that UNI must map to a single EVC.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce0-Slot0-Port1 ce-vlans ce-vlan 1
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*If All-to-One Bundling is enabled for any UNI in an EVC, all CE-VLAN IDs for that UNI must map to a single EVC.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [R82B]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [R82B]: PASS';
fi

# Test for MEF 10.3 [R88].  This test should fail to commit with "ELMI Service Attribute must be Enabled.".
{ ncs_cli -u admin -C << EOF;
config
mef-interfaces unis uni MMPOP1-ce0-Slot0-Port1 elmi-service-attribute false
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*ELMI Service Attribute must be Enabled.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [R88]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [R88]: PASS';
fi

# Test for MEF 10.3 [R111A].  This test should fail to commit with "When the Class of Service Identifier is based on PCP for a given EVC at a given UNI, the Color Identifier must be based on either DEI or PCP.".
{ ncs_cli -u admin -C << EOF;
config
mef-services carrier-ethernet subscriber-services evc EVC-0001898-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot1-Port1 cos-identifier MEF103_Table13
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
mef-services carrier-ethernet subscriber-services evc EVC-0001898-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot1-Port1 eec-identifier MEF62_ApdxA
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
mef-services carrier-ethernet subscriber-services evc EVC-0001899-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot1-Port3 cos-identifier MEF103_Table23
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
mef-services carrier-ethernet subscriber-services evc EVC-0001899-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot1-Port3 eec-identifier MEF103_Table23
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

# Test for MEF 10.3 [R135AI]. All Bandwidth Profile Flows in an Envelope MUST satisfy the same criterion in [R134] (A UNI cannot be configured with a mix of EVC ingress-bwp-flows-per-cos and ingress-bw-profile-per-evc in the same BWP Envelope. This implies configuration from two multiplexed EVCs sharing a UNI.)

# Test for MEF 10.3 [R135AI].  This test should fail to commit with "All EVCs sharing a Ingress Bandwidth Profile Envelope for a UNI must use the same BWP Method ( Per-EVC or Per-CoS).".
{ ncs_cli -u admin -C << EOF;
config
mef-services carrier-ethernet subscriber-services evc EVC-0001900-ACME-MEGAMART end-points end-point MMPOP1-ce0-Slot0-Port3 ingress-bwp-flows-per-cos coupling-enabled false bwp-flow-per-cos Neon envelope-id ienv_EVPL_UNI003_EVC-0001343-ACME-MEGAMART bw-profile high1-bwp-uni
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*All EVCs sharing a Ingress Bandwidth Profile Envelope for a UNI must use the same BWP Method ( Per-EVC or Per-CoS).'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [R135AI]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [R135AI]: PASS';
fi

# Test for MEF 10.3 [R135AE]. All Bandwidth Profile Flows in an Envelope MUST satisfy the same criterion in [R134] (A UNI cannot be configured with a mix of EVC ingress-bwp-flows-per-cos and ingress-bw-profile-per-evc in the same BWP Envelope. This implies configuration from two multiplexed EVCs sharing a UNI.)

# Test for MEF 10.3 [R135AE].  This test should fail to commit with "All EVCs sharing a Egress Bandwidth Profile Envelope for a UNI must use the same BWP Method ( Per-EVC or Per-CoS).".
{ ncs_cli -u admin -C << EOF;
config
mef-services carrier-ethernet subscriber-services evc EVC-0001900-ACME-MEGAMART end-points end-point MMPOP1-ce0-Slot0-Port3 egress-bwp-flows-per-eec coupling-enabled false bwp-flow-per-eec Neon envelope-id eenv_EVPL_UNI003_EVC-0001343-ACME-MEGAMART bw-profile high1-bwp-uni
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*All EVCs sharing a Egress Bandwidth Profile Envelope for a UNI must use the same BWP Method ( Per-EVC or Per-CoS).'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [R135AE]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [R135AE]: PASS';
fi

# Test for MEF 10.3 [R135BI]. All Bandwidth Profile Flows in an Envelope MUST satisfy the same criterion in [R134] (A UNI cannot be configured with a mix of EVC ingress-bwp-flows-per-cos and ingress-bw-profile-per-evc in the same BWP Envelope. This implies configuration from two multiplexed EVCs sharing a UNI.)

# Test for MEF 10.3 [R135BI].  This test should fail to commit with "All EVCs sharing a Ingress Bandwidth Profile Envelope for a UNI must use the same BWP Method (Per-CoS or Per-EVC).".
{ ncs_cli -u admin -C << EOF;
config
mef-services carrier-ethernet subscriber-services evc EVC-0002900-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot0-Port2 ingress-bw-profile-per-evc envelope-id ienv_EVPL_UNI003_EVC-0002343-ACME-MEGAMART bw-profile high1-bwp-uni
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*All EVCs sharing a Ingress Bandwidth Profile Envelope for a UNI must use the same BWP Method (Per-CoS or Per-EVC).'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [R135BI]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [R135BI]: PASS';
fi

# Test for MEF 10.3 [R135BE]. All Bandwidth Profile Flows in an Envelope MUST satisfy the same criterion in [R134] (A UNI cannot be configured with a mix of egress-bwp-flows-per-eec and egress-bw-profile-per-evc in the same BWP Envelope. This implies configuration from two multiplexed EVCs sharing a UNI.)

# Test for MEF 10.3 [R135BE].  This test should fail to commit with "All EVCs sharing a Egress Bandwidth Profile Envelope for a UNI must use the same BWP Method (Per-CoS or Per-EVC).".
{ ncs_cli -u admin -C << EOF;
config
mef-services carrier-ethernet subscriber-services evc EVC-0002900-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot0-Port2 egress-bw-profile-per-evc envelope-id eenv_EVPL_UNI003_EVC-0002343-ACME-MEGAMART bw-profile high1-bwp-uni
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*All EVCs sharing a Egress Bandwidth Profile Envelope for a UNI must use the same BWP Method (Per-CoS or Per-EVC).'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [R135BE]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [R135BE]: PASS';
fi

# Test for MEF 10.3 [EVC CoS1]. A set of must-statements were added to mef-services.yang to ensure all CoS dependencies are consistent with the CoS Names configured for the EVC.

# Test for MEF 10.3 [EVC CoS1].  This test should fail to commit with "When the Class of Service Identifier is based on PCP for a given EVC at a given UNI, all cos-pcp CoS Names must be in the the EVC Cos Names List.".
{ ncs_cli -u admin -C << EOF;
config
mef-global profiles cos cos-profile MEF103_Table13 cos-pcp pcp 6 cos-name H color green
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*When the Class of Service Identifier is based on PCP for a given EVC at a given UNI, all cos-pcp CoS Names must be in the the EVC Cos Names List.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [EVC CoS1]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [EVC CoS1]: PASS';
fi

# Test for MEF 10.3 [EVC CoS2]. A set of must-statements were added to mef-services.yang to ensure all CoS dependencies are consistent with the CoS Names configured for the EVC.

# Test for MEF 10.3 [EVC CoS2].  This test should fail to commit with "When the Class of Service Identifier is based on DSCP for a given EVC at a given UNI, all IPv4 cos-dscp CoS Names must be in the the EVC Cos Names List.".
{ ncs_cli -u admin -C << EOF;
config
mef-global profiles cos cos-profile MEF103_Table23 cos-dscp ipv4-dscp 37 discard-value false cos-name M color green
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*When the Class of Service Identifier is based on DSCP for a given EVC at a given UNI, all IPv4 cos-dscp CoS Names must be in the the EVC Cos Names List.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [EVC CoS2]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [EVC CoS2]: PASS';
fi

# Test for MEF 10.3 [EVC CoS3]. A set of must-statements were added to mef-services.yang to ensure all CoS dependencies are consistent with the CoS Names configured for the EVC.

# Test for MEF 10.3 [EVC CoS3].  This test should fail to commit with "When the Class of Service Identifier is based on DSCP for a given EVC at a given UNI, all IPv6 cos-dscp CoS Names must be in the the EVC Cos Names List.".
{ ncs_cli -u admin -C << EOF;
config
mef-global profiles cos cos-profile MEF103_Table23 cos-dscp ipv6-dscp 45 discard-value false cos-name L color green
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*When the Class of Service Identifier is based on DSCP for a given EVC at a given UNI, all IPv6 cos-dscp CoS Names must be in the the EVC Cos Names List.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [EVC CoS3]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [EVC CoS3]: PASS';
fi

# Test for MEF 10.3 [EVC CoS4]. A set of must-statements were added to mef-services.yang to ensure all CoS dependencies are consistent with the CoS Names configured for the EVC.

# Test for MEF 10.3 [EVC CoS4].  This test should fail to commit with "When the Class of Service Identifier is based on PCP for a given EVC at a given UNI, the default-pcp-cos-name must be in the the EVC Cos Names List.".
{ ncs_cli -u admin -C << EOF;
config
mef-global profiles cos cos-profile MEF103_Table13 cos-pcp default-pcp-cos-name H default-pcp-color green
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*When the Class of Service Identifier is based on PCP for a given EVC at a given UNI, the default-pcp-cos-name must be in the the EVC Cos Names List.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [EVC CoS4]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [EVC CoS4]: PASS';
fi

# Test for MEF 10.3 [EVC CoS5]. A set of must-statements were added to mef-services.yang to ensure all CoS dependencies are consistent with the CoS Names configured for the EVC.

# Test for MEF 10.3 [EVC CoS5].  This test should fail to commit with "When the Class of Service Identifier is based on DSCP for a given EVC at a given UNI, the default-ipv4-cos-name must be in the the EVC Cos Names List.".
{ ncs_cli -u admin -C << EOF;
config
mef-global profiles cos cos-profile MEF103_Table23 cos-dscp default-ipv4-cos-name M default-ipv4-color yellow
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*When the Class of Service Identifier is based on DSCP for a given EVC at a given UNI, the default-ipv4-cos-name must be in the the EVC Cos Names List.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [EVC CoS5]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [EVC CoS5]: PASS';
fi

# Test for MEF 10.3 [EVC CoS6]. A set of must-statements were added to mef-services.yang to ensure all CoS dependencies are consistent with the CoS Names configured for the EVC.

# Test for MEF 10.3 [EVC CoS6].  This test should fail to commit with "When the Class of Service Identifier is based on DSCP for a given EVC at a given UNI, the default-ipv6-cos-name must be in the the EVC Cos Names List.".
{ ncs_cli -u admin -C << EOF;
config
mef-global profiles cos cos-profile MEF103_Table23 cos-dscp default-ipv6-cos-name M default-ipv6-color yellow
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*When the Class of Service Identifier is based on DSCP for a given EVC at a given UNI, the default-ipv6-cos-name must be in the the EVC Cos Names List.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [EVC CoS6]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [EVC CoS6]: PASS';
fi

# Test for MEF 10.3 [EVC CoS7]. A set of must-statements were added to mef-services.yang to ensure all CoS dependencies are consistent with the CoS Names configured for the EVC.

# Test for MEF 10.3 [EVC CoS7].  This test should fail to commit with "When the Class of Service Identifier is based on EVC for a given EVC at a given UNI, the default-evc-cos-name must be in the the EVC Cos Names List.".
{ ncs_cli -u admin -C << EOF;
config
mef-global profiles cos cos-profile MEF62_ApdxA_CoS cos-evc default-evc-cos-name H default-evc-color green
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*When the Class of Service Identifier is based on EVC for a given EVC at a given UNI, the default-evc-cos-name must be in the the EVC Cos Names List.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [EVC CoS7]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [EVC CoS7]: PASS';
fi

# Test for MEF 10.3 [EVC EEC1]. A set of must-statements were added to mef-services.yang to ensure all EEC dependencies are consistent with the CoS Names configured for the EVC.

# Test for MEF 10.3 [EVC EEC1].  This test should fail to commit with "When the EEC Identifier is based on PCP for a given EVC at a given UNI, all eec-pcp CoS Names must be in the the EVC Cos Names List.".
{ ncs_cli -u admin -C << EOF;
config
mef-global profiles eec eec-profile MEF62_ApdxA eec-pcp pcp 3 eec-name H color green
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*When the EEC Identifier is based on PCP for a given EVC at a given UNI, all eec-pcp CoS Names must be in the the EVC Cos Names List.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [EVC EEC1]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [EVC EEC1]: PASS';
fi

# Test for MEF 10.3 [EVC EEC2]. A set of must-statements were added to mef-services.yang to ensure all EEC dependencies are consistent with the CoS Names configured for the EVC.

# Test for MEF 10.3 [EVC EEC2].  This test should fail to commit with "When the EEC Identifier is based on DSCP for a given EVC at a given UNI, all IPv4 eec-dscp CoS Names must be in the the EVC Cos Names List.".
{ ncs_cli -u admin -C << EOF;
config
mef-global profiles eec eec-profile MEF103_Table23 eec-dscp ipv4-dscp 8 discard-value false eec-name H color green
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*When the EEC Identifier is based on DSCP for a given EVC at a given UNI, all IPv4 eec-dscp CoS Names must be in the the EVC Cos Names List.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [EVC EEC2]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [EVC EEC2]: PASS';
fi

# Test for MEF 10.3 [EVC EEC3]. A set of must-statements were added to mef-services.yang to ensure all EEC dependencies are consistent with the CoS Names configured for the EVC.

# Test for MEF 10.3 [EVC EEC3].  This test should fail to commit with "When the EEC Identifier is based on DSCP for a given EVC at a given UNI, all IPv6 eec-dscp CoS Names must be in the the EVC Cos Names List.".
{ ncs_cli -u admin -C << EOF;
config
mef-global profiles eec eec-profile MEF103_Table23 eec-dscp ipv6-dscp 37 discard-value false eec-name M color green
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*When the EEC Identifier is based on DSCP for a given EVC at a given UNI, all IPv6 eec-dscp CoS Names must be in the the EVC Cos Names List.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [EVC EEC3]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [EVC EEC3]: PASS';
fi

# Test for MEF 10.3 [EVC EEC4]. A set of must-statements were added to mef-services.yang to ensure all EEC dependencies are consistent with the CoS Names configured for the EVC.

# Test for MEF 10.3 [EVC EEC4].  This test should fail to commit with "When the EEC Identifier is based on PCP for a given EVC at a given UNI, the default-pcp-eec-name must be in the the EVC Cos Names List.".
{ ncs_cli -u admin -C << EOF;
config
mef-global profiles eec eec-profile MEF62_ApdxA eec-pcp default-pcp-eec-name L default-pcp-color green
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*When the EEC Identifier is based on PCP for a given EVC at a given UNI, the default-pcp-eec-name must be in the the EVC Cos Names List.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [EVC EEC4]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [EVC EEC4]: PASS';
fi

# Test for MEF 10.3 [EVC EEC5]. A set of must-statements were added to mef-services.yang to ensure all EEC dependencies are consistent with the CoS Names configured for the EVC.

# Test for MEF 10.3 [EVC EEC5].  This test should fail to commit with "When the EEC Identifier is based on DSCP for a given EVC at a given UNI, the default-ipv4-eec-name must be in the the EVC Cos Names List.".
{ ncs_cli -u admin -C << EOF;
config
mef-global profiles eec eec-profile MEF103_Table23 eec-dscp default-ipv4-eec-name M default-ipv4-color green
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*When the EEC Identifier is based on DSCP for a given EVC at a given UNI, the default-ipv4-eec-name must be in the the EVC Cos Names List.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [EVC EEC5]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [EVC EEC5]: PASS';
fi

# Test for MEF 10.3 [EVC EEC6]. A set of must-statements were added to mef-services.yang to ensure all EEC dependencies are consistent with the CoS Names configured for the EVC.

# Test for MEF 10.3 [EVC EEC6].  This test should fail to commit with "When the EEC Identifier is based on DSCP for a given EVC at a given UNI, the default-ipv6-eec-name must be in the the EVC Cos Names List.".
{ ncs_cli -u admin -C << EOF;
config
mef-global profiles eec eec-profile MEF103_Table23 eec-dscp default-ipv6-eec-name M default-ipv6-color green
commit
end no-confirm
exit
EOF
} | grep 'Aborted:.*When the EEC Identifier is based on DSCP for a given EVC at a given UNI, the default-ipv6-eec-name must be in the the EVC Cos Names List.'
if [ $? != 0 ]; then
   echo 'Test MEF 10.3 [EVC EEC6]: FAIL - commit did not fail or did not fail as expected'; exit 1;
else
   echo 'Test MEF 10.3 [EVC EEC6]: PASS';
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
mef-global profiles bwp-flows-parameter-set bwp-flow-parameter-set high2-bwp-uni coupling-enabled true
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
mef-global profiles bwp-flows-parameter-set bwp-flow-parameter-set high1-bwp-uni coupling-enabled true
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
mef-services carrier-ethernet subscriber-services evc EVC-0001898-ACME-MEGAMART end-points end-point MMPOP1-ce0-Slot0-Port1 egress-bwp-flows-per-eec coupling-enabled false bwp-flow-per-eec EEC-Neon envelope-id eenv_EPL_UNI001_EVC-0001898_Neon bw-profile low1-bwp-uni
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
mef-services carrier-ethernet subscriber-services evc EVC-0001898-ACME-MEGAMART end-points end-point MMPOP1-ce0-Slot0-Port1 source-mac-address-limit 10
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
mef-services carrier-ethernet subscriber-services evc EVC-0001898-ACME-MEGAMART connection-type multipoint-to-multipoint max-num-of-evc-end-point 3
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
mef-services carrier-ethernet subscriber-services evc EVC-0001898-ACME-MEGAMART unicast-frame-delivery conditional
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
mef-services carrier-ethernet subscriber-services evc EVC-0001898-ACME-MEGAMART multicast-frame-delivery conditional
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
mef-services carrier-ethernet subscriber-services evc EVC-0001898-ACME-MEGAMART broadcast-frame-delivery conditional
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
no mef-services carrier-ethernet subscriber-services evc EVC-0001898-ACME-MEGAMART end-points end-point MMPOP1-ce0-Slot0-Port1 ce-vlans ce-vlan 101
no mef-services carrier-ethernet subscriber-services evc EVC-0001898-ACME-MEGAMART end-points end-point MMPOP1-ce0-Slot0-Port1 ce-vlans ce-vlan 102
no mef-services carrier-ethernet subscriber-services evc EVC-0001898-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot1-Port1 ce-vlans ce-vlan 101
no mef-services carrier-ethernet subscriber-services evc EVC-0001898-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot1-Port1 ce-vlans ce-vlan 102
mef-services carrier-ethernet subscriber-services evc EVC-0001898-ACME-MEGAMART ce-vlan-id-preservation false
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
mef-services carrier-ethernet subscriber-services evc EVC-0001898-ACME-MEGAMART ce-vlan-pcp-preservation false
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
mef-services carrier-ethernet subscriber-services evc EVC-0001898-ACME-MEGAMART svc-type evpl ce-vlan-pcp-preservation false
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
mef-services carrier-ethernet subscriber-services evc EVC-0001899-ACME-MEGAMART end-points end-point MMPOP1-ce1-Slot1-Port3 source-mac-address-limit 10
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
mef-services carrier-ethernet subscriber-services evc EVC-0001899-ACME-MEGAMART connection-type rooted-multipoint max-num-of-evc-end-point 3 unicast-frame-delivery conditional
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
mef-services carrier-ethernet subscriber-services evc EVC-0001901-ACME-MEGAMART connection-type rooted-multipoint
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
mef-services carrier-ethernet subscriber-services evc EVC-0001901-ACME-MEGAMART ce-vlan-id-preservation false
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
mef-services carrier-ethernet subscriber-services evc EVC-0001901-ACME-MEGAMART ce-vlan-pcp-preservation false
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
no mef-services carrier-ethernet subscriber-services evc EVC-0002947-ACME-MEGAMART end-points end-point MMPOP1-ce7-Slot7-Port3 ce-vlans ce-vlan 153
no mef-services carrier-ethernet subscriber-services evc EVC-0002947-ACME-MEGAMART end-points end-point MMPOP1-ce7-Slot7-Port3
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
mef-services carrier-ethernet subscriber-services evc EVC-0001944-ACME-MEGAMART connection-type rooted-multipoint
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
mef-services carrier-ethernet subscriber-services evc EVC-0001911-ACME-MEGAMART end-points end-point MMPOP1-ce6-Slot6-Port2 role root
no mef-services carrier-ethernet subscriber-services evc EVC-0001911-ACME-MEGAMART end-points end-point MMPOP1-ce7-Slot7-Port2
no mef-services carrier-ethernet subscriber-services evc EVC-0001911-ACME-MEGAMART end-points end-point MMPOP1-ce8-Slot8-Port2
mef-services carrier-ethernet subscriber-services evc EVC-0001911-ACME-MEGAMART connection-type point-to-point max-num-of-evc-end-point 2
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
mef-services carrier-ethernet subscriber-services evc EVC-0001911-ACME-MEGAMART ce-vlan-id-preservation false
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
mef-services carrier-ethernet subscriber-services evc EVC-0001911-ACME-MEGAMART ce-vlan-pcp-preservation false
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
mef-services carrier-ethernet subscriber-services evc EVC-0002947-ACME-MEGAMART end-points end-point MMPOP1-ce6-Slot6-Port3 role root
no mef-services carrier-ethernet subscriber-services evc EVC-0002947-ACME-MEGAMART end-points end-point MMPOP1-ce7-Slot7-Port3
no mef-services carrier-ethernet subscriber-services evc EVC-0002947-ACME-MEGAMART end-points end-point MMPOP1-ce8-Slot8-Port3
mef-services carrier-ethernet subscriber-services evc EVC-0002947-ACME-MEGAMART connection-type point-to-point max-num-of-evc-end-point 2
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


