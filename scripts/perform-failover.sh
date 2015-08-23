#!/bin/bash

if [ $# -lt 1 ]
then
        echo "Usage : $0 failover|failback"
        exit 0
fi


###Call failover script and execute contents on the replica
ssh -i ../ghe-acces.pem -p122 admin@10.68.0.196 "bash -s" < failover.sh $1

if [ $1 == "failback"  ]; then
        ###Call change-maintenance-mode.sh script and execute contents on the primary
        ssh -i ../ghe-acces.pem -p122 admin@10.68.0.135 "bash -s" < change-maintenance-mode.sh
        ###Call switch-traffic.sh script and execute contents on the forwarder 1
        ssh -i ../ghe-acces.pem -p222 msmadmin@10.68.0.35 "bash -s" < switch-traffic.sh primary
else
        ssh -i ../ghe-acces.pem -p222 msmadmin@10.68.0.35 "bash -s" < switch-traffic.sh replica

fi

