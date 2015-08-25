#!/bin/bash

logger ============================================CHECK_PRIMARY Started\=========================================================
##Check if preferred primary is up
check_primary=`nc -z -w1 10.68.0.135 122; echo $?`

##If preferred primary is up, do nothing or log message
if [ $check_primary -eq 0 ]; then

        logger Primary Node is currently running
        logger Nothing To Do
        echo "*******************Primary Node is currently running*******************"
        echo "*****************************Nothing to do*****************************"
else
        sleep 5 ##tweak to 60
        check_primary=`nc -z -w1 10.68.0.135 122; echo $?`
        if [ "$check_primary" -eq 1 ]; then
                logger Initiating a Failover
                echo "*******************Initiate failover*******************"
                ./perform-failover.sh failover
                sleep 5 ##wait for replica to be promoted to primary
                check_primary=`nc -z -w1 10.68.0.135 122; echo $?`
                ##Wait until the preferred primary is back up
                while [ $check_primary -eq 1 ]
                do
                        check_primary=`nc -z -w1 10.68.0.135 122; echo $?`
                        sleep 5 ##tweak 
                done 

                ##check that the preferred primary is really back up
                check_primary=`nc -z -w1 10.68.0.135 122; echo $?`
                if [ $check_primary -eq 0 ]; then
                        echo "Converting preferred primary to a replica. "
                        logger Converting preferred primary to a replica.
                        ./perform-failover.sh convert-primary-to-replica
                        sleep 5 ##60 secs
                        echo "Re promoting back to preferred primary"
                        logger Re promoting back to preferred primary
                        ./perform-failover.sh re-promote
                else
                        echo "Preferred Primary NOT converted OR re promoted"
                        logger *********Preferred Primary NOT converted OR re promote************
                fi

        fi
fi
logger ========================================CHECK_PRIMARY Complete\==============================================
