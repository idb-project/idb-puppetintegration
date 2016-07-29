#!/bin/bash

#get the idrac ip via racadm or ipmitool to be used as a fact in our IDB. 
#actually using idracadm7 as this works on all our current dell boxes
#hbe@bytemine.net,06/2016

MANUFACTURER=$(facter manufacturer)

		if [ "$MANUFACTURER" == "Supermicro" ];then

#2 possible ways to get the ip for ipmi. via ipmitool or bmc-config. use what's available

IPMITOOL=$(which ipmitool)
BMCWATCHDOG=$(which bmc-watchdog)

		if [ $BMCWATCHDOG ]; then

IDRAC_IP=$(bmc-config --checkout |grep "IP_Address" |sed 1,3d |sed 2,3d|awk '{print $2}')

		elif [ $IPMITOOL ]; then

DRAC_IP=$(ipmitool lan print 1 |grep "IP Address" |sed 1d |awk '{print $4}')i
		
		fi
		
		if [ $IDRAC_IP ]; then

	echo "idrac_ip=$IDRAC_IP" > /etc/facter/facts.d/idrac_ip.txt
	exit 0

		else 

	echo "couldn't get the required info from racadm"
	exit 1
		fi

		elif [ "$MANUFACTURER" == "Dell Inc." ];then

RACADM=idracadm7

IDRAC_IP=$($RACADM getniccfg |grep "IP Address"|head -1 |awk '{print $4}')

		if [ $IDRAC_IP ]; then

	echo "idrac_ip=$IDRAC_IP" > /etc/facter/facts.d/idrac_ip.txt
	exit 0

		else 

	echo "couldn't get the required info from racadm"
	exit 1
		fi

		fi

