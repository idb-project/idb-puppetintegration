########################################## MAINTAINED BY PUPPET ###########################################
#!/bin/bash

#script to check for available updates via zypper for suse machines
#amount of updates will be added to custom facts, so these values can be read and displayed in our idb
#it also compares kernel versions to see if a reboot is needed
#done by hbe@bytemine.net February,2017

IDB_REBOOT_REQUIRED="false"

#compare kernel versions to check if a reboot is needed. not the only reason for a reboot, but the best indicator available 
LATEST_INSTALLED_KERNEL=$(rpm -q --last kernel-default | awk '{print $1}' |cut -f3,4 -d"-" |cut -f1,2,3 -d".")
CURRENT_KERNEL=$(uname -r |cut -f1,2 -d"-")

		if [ "$LATEST_INSTALLED_KERNEL" != "$CURRENT_KERNEL" ] ; then

IDB_REBOOT_REQUIRED="true"

		fi

echo "idb_reboot_required=$IDB_REBOOT_REQUIRED" > /etc/facter/facts.d/idb_reboot_required.txt

# query for pending updates.
PENDING_UPDATES_NAMES=$(zypper list-updates |sed 1,4d |awk '{print $5}'|paste -sd " " 2>&1)

		if [ $? -ne 0 ]; then
	echo "Querying pending updates failed."
	        exit 1
		fi

PENDING_SECURITY=$(zypper pchk |sed '$!d' |awk '{print $4}'|sed 's/(//' )
INSTALLED_PACKAGES=$(rpm -qa --qf "%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH} ")
#create facts
echo "idb_pending_security_updates=$PENDING_SECURITY" > /etc/facter/facts.d/idb_pending_security_updates.txt
echo "idb_pending_updates_package_names=[$PENDING_UPDATES_NAMES]" > /etc/facter/facts.d/idb_pending_updates_package_names.txt
echo "idb_installed_packages=[$INSTALLED_PACKAGES]" > /etc/facter/facts.d/idb_installed_packages.txt
