#!/bin/bash

if [ $# -lt 1 ]
then
<<<<<<< HEAD
        echo "Usage : $0 fileover|failback|convert-primary|re-promote"
=======
        echo "Usage : $0 failover|convert-primary-to-replica|failback|re-promote|convert-replica-to-primary"
>>>>>>> f8ac800f9ab236f3559ce3f6e07566d0837a9014
        exit 0
fi


case "$1" in
        failover)
                ###Call failover script and execute contents on the preferred replica
                ssh -i ../ghe-acces.pem -p122 admin@10.68.0.196 "bash -s" < failover.sh $1
                ###Call change-maintenance-mode.sh script and execute contents on the primary
<<<<<<< HEAD
                ssh -i ../ghe-acces.pem -p222 msmadmin@10.68.0.35 "bash -s" < switch-traffic.sh replica
                ###Make preferred primary the replica
                ######ssh -i ../ghe-acces.pem -p122 admin@10.68.0.135 "bash -s" < failover.sh convert-primary
        ;;
=======
                ssh -i ../ghe-acces.pem -p222 msmadmin@10.68.0.35 "bash -s" < switch-traffic.sh replica 
                ###Make preferred primary the replica
                ######ssh -i ../ghe-acces.pem -p122 admin@10.68.0.135 "bash -s" < failover.sh convert-primary 
        ;;

        convert-primary-to-replica)
                ###Call failover script and execute contents on the preferred primary
                ssh -i ../ghe-acces.pem -p122 admin@10.68.0.135 "bash -s" < failover.sh $1

        ;;

>>>>>>> f8ac800f9ab236f3559ce3f6e07566d0837a9014
        failback)
                ###Call failover script and execute contents on the preferred replica
                ssh -i ../ghe-acces.pem -p122 admin@10.68.0.196 "bash -s" < failover.sh $1
                ###Call change-maintenance-mode.sh script and execute contents on the primary
                ssh -i ../ghe-acces.pem -p122 admin@10.68.0.135 "bash -s" < change-maintenance-mode.sh u
                ###Call switch-traffic.sh script and execute contents on the forwarder 1
                ssh -i ../ghe-acces.pem -p222 msmadmin@10.68.0.35 "bash -s" < switch-traffic.sh primary
        ;;
<<<<<<< HEAD
        convert-primary)
                ###Call failover script and execute contents on the preferred primary
                ssh -i ../ghe-acces.pem -p122 admin@10.68.0.135 "bash -s" < failover.sh $1

        ;;
        re-promote)
                ###Call failover script and execute contents on the new replica to re-promote the preferred Primary
                ssh -i ../ghe-acces.pem -p122 admin@10.68.0.135 "bash -s" < failover.sh $1
=======

        convert-replica-to-primary)
                ###Call failover script and execute contents on the preferred primary
                ssh -i ../ghe-acces.pem -p122 admin@10.68.0.196 "bash -s" < failover.sh $1

        ;;

        re-promote)
                ###Call failover script and execute contents on the new replica to re-promote the preferred Primary
                ssh -i ../ghe-acces.pem -p122 admin@10.68.0.135 "bash -s" < failover.sh $1
                ssh -i ../ghe-acces.pem -p222 msmadmin@10.68.0.35 "bash -s" < switch-traffic.sh primary
                ssh -i ../ghe-acces.pem -p122 admin@10.68.0.196 "bash -s" < failover.sh backout
>>>>>>> f8ac800f9ab236f3559ce3f6e07566d0837a9014
        ;;
        *)
                echo Option not supported""
        ;;
esac
