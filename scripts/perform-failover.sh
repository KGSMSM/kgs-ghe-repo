#!/bin/bash

if [ $# -lt 1 ]
then
        echo "Usage : $0 fileover|failback|convert-primary|re-promote"
        exit 0
fi


case "$1" in
        failover)
                ###Call failover script and execute contents on the preferred replica
                ssh -i ../ghe-acces.pem -p122 admin@10.68.0.196 "bash -s" < failover.sh $1
                ###Call change-maintenance-mode.sh script and execute contents on the primary
                ssh -i ../ghe-acces.pem -p222 msmadmin@10.68.0.35 "bash -s" < switch-traffic.sh replica
                ###Make preferred primary the replica
                ######ssh -i ../ghe-acces.pem -p122 admin@10.68.0.135 "bash -s" < failover.sh convert-primary
        ;;
        failback)
                ###Call failover script and execute contents on the preferred replica
                ssh -i ../ghe-acces.pem -p122 admin@10.68.0.196 "bash -s" < failover.sh $1
                ###Call change-maintenance-mode.sh script and execute contents on the primary
                ssh -i ../ghe-acces.pem -p122 admin@10.68.0.135 "bash -s" < change-maintenance-mode.sh u
                ###Call switch-traffic.sh script and execute contents on the forwarder 1
                ssh -i ../ghe-acces.pem -p222 msmadmin@10.68.0.35 "bash -s" < switch-traffic.sh primary
        ;;
        convert-primary)
                ###Call failover script and execute contents on the preferred primary
                ssh -i ../ghe-acces.pem -p122 admin@10.68.0.135 "bash -s" < failover.sh $1

        ;;
        re-promote)
                ###Call failover script and execute contents on the new replica to re-promote the preferred Primary
                ssh -i ../ghe-acces.pem -p122 admin@10.68.0.135 "bash -s" < failover.sh $1
        ;;
        *)
                echo Option not supported""
        ;;
esac
