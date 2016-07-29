########################################## MAINTAINED BY PUPPET ###########################################
#!/bin/bash

# script to check for available updates via /usr/lib/update-notifier/apt-check, if available, for debian based machines.
# if not available query and parse apt-get dist-upgrade's output.
# It also adds a fact including all installed packages and a fact which shows if a reboot is required.
# Ouptput will be added to custom facts, so these values can be read by facter and displayed in our idb.
# done by hbe@bytemine.net June,2015

IDB_REBOOT_REQUIRED="false"
	if [ -e /usr/lib/update-notifier/apt-check ];then

# query for pending updates.
UPDATES=$(/usr/lib/update-notifier/apt-check 2>&1)

		if [ $? -ne 0 ]; then
	
	echo "Querying pending updates failed."
	exit 1
	
		fi

#extract and calculate the values
PENDING_SECURITY=$(echo "$UPDATES" | cut -d ";" -f 2)
PENDING_UPDATES=$(echo "$UPDATES" | cut -d ";" -f 1)
PENDING_UPDATES_PACKAGE_NAMES=$(/usr/lib/update-notifier/apt-check -p 2>&1 | sort -u |tr "\n" " ")
INSTALLED_PACKAGES=$(dpkg -l | grep '^ii' |awk '{print $2, $3}'|tr " " =| sort -u |tr "\n" " ")

#check if a reboot is required/pending
		if [ -f "/var/run/reboot-required" ]; then

IDB_REBOOT_REQUIRED="true"

		fi
#create facts
echo "idb_reboot_required=$IDB_REBOOT_REQUIRED" > /etc/facter/facts.d/idb_reboot_required.txt
echo "idb_pending_updates=$PENDING_UPDATES" > /etc/facter/facts.d/idb_pending_updates.txt
echo "idb_pending_security_updates=$PENDING_SECURITY" > /etc/facter/facts.d/idb_pending_security_updates.txt
echo "idb_pending_updates_package_names=[$PENDING_UPDATES_PACKAGE_NAMES]" > /etc/facter/facts.d/idb_pending_updates_package_names.txt
echo "idb_installed_packages=[$INSTALLED_PACKAGES]" > /etc/facter/facts.d/idb_installed_packages.txt

	else

#extract and calculate the values
PENDING_UPDATES=$(apt-get -s dist-upgrade |grep "^Inst" |wc -l)
PENDING_SECURITY=$(apt-get -s dist-upgrade |grep "^Inst" |grep -i securi |wc -l)
PENDING_UPDATES_PACKAGE_NAMES=$(apt-get -s dist-upgrade |grep "^Inst" |awk '{print $2}'|sort -u |tr "\n" " ")
INSTALLED_PACKAGES=$(dpkg -l | grep '^ii' |awk '{print $2, $3}'|tr " " =| sort -u |tr "\n" " ")

#create facts
echo "idb_pending_updates=$PENDING_UPDATES" > /etc/facter/facts.d/idb_pending_updates.txt
echo "idb_pending_security_updates=$PENDING_SECURITY" > /etc/facter/facts.d/idb_pending_security_updates.txt
echo "idb_pending_updates_package_names=[$PENDING_UPDATES_PACKAGE_NAMES]" > /etc/facter/facts.d/idb_pending_updates_package_names.txt
echo "idb_installed_packages=[$INSTALLED_PACKAGES]" > /etc/facter/facts.d/idb_installed_packages.txt

#check if a reboot is required/pending
        	if [ -f "/var/run/reboot-required" ]; then

IDB_REBOOT_REQUIRED="true"

        	fi

	fi

