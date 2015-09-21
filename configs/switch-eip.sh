#!/bin/bash

echo "Today is $(date)" >> /var/log/state2.log
echo "State: $3 just been rebooted!!!!!!" >> /var/log/state2.log

EIP1=52.18.153.196
INSTANCE_ID=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
STATE=$3

if [ "$STATE" = "MASTER" ]; then
        /usr/local/bin/aws ec2 associate-address --public-ip $EIP1 --instance-id $INSTANCE_ID

        ##check if primary is alive
        logger "checking if primary is alive"
        /home/msmadmin/scripts/check-primary-az.sh
fi


####Call the checker from here
if [ "$STATE" = "BACKUP" ]; then
        ##check if primary is alive
        logger "checking if primary is alive"
        /home/msmadmin/scripts/check-primary-az.sh
        ###/home/msmadmin/scripts/switch-traffic.sh

fi
