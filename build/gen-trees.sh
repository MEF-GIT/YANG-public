#!/bin/sh

for i in mef-*\@$(date +%Y-%m-%d).yang
do
	name=$(echo $i | cut -f 1 -d '.')
	echo $name
	pyang -p common:../../../ -f tree $name.yang > $name-tree.txt.tmp
	fold -w 71 $name-tree.txt.tmp > $name-tree.txt
	pyang -p common:../../../ -f swagger $name.yang > $name.json
	yanglint -p ../../../ $name.yang
done
rm *-tree.txt.tmp
