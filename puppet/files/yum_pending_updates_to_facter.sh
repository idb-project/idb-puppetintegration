########################################## MAINTAINED BY PUPPET ###########################################
#!/bin/bash

#script to check for available updates via yum list updates for redhat based machines
#amount of updates will be added to custom facts, so these values can be read and displayed in our idb
#it also compares kernel versions to see if a reboot is needed
#done by hbe@bytemine.net September,2015

IDB_REBOOT_REQUIRED="false"

#compare kernel versions to check if a reboot is needed. not the only reason for a reboot, but the best indicator available 
LATEST_INSTALLED_KERNEL=$(rpm -q --last kernel | awk '{print $1}'|head -1 |cut -f2,3 -d"-")
CURRENT_KERNEL=$(uname -r)

		if [ "$LATEST_INSTALLED_KERNEL" != "$CURRENT_KERNEL" ] ; then

IDB_REBOOT_REQUIRED="true"

		fi

echo "idb_reboot_required=$IDB_REBOOT_REQUIRED" > /etc/facter/facts.d/idb_reboot_required.txt

# query for pending updates.
PENDING_UPDATES_NAMES=$(yum list updates --quiet | grep -v "^$" |grep -v "Updated Packages" |awk '{print $1}' |sed 's/[.].*$/ /'|paste -sd "" 2>&1)

		if [ $? -ne 0 ]; then
	echo "Querying pending updates failed."
	        exit 1
		fi

PENDING_SECURITY=$(yum list updates --security --quiet|wc -l )
INSTALLED_PACKAGES=$(rpm -qa --qf "%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH} ")
#create facts
echo "idb_pending_security_updates=$PENDING_SECURITY" > /etc/facter/facts.d/idb_pending_security_updates.txt
echo "idb_pending_updates_package_names=[$PENDING_UPDATES_NAMES]" > /etc/facter/facts.d/idb_pending_updates_package_names.txt
echo "idb_installed_packages=[$INSTALLED_PACKAGES]" > /etc/facter/facts.d/idb_installed_packages.txt
