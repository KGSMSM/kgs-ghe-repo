#!/bin/bash

function check-replication-mode() {

                ##check that the preferred replica is really back up
                check_replica=`nc -z -w1 10.68.0.196 122; echo $?`
                if [ $check_replica -eq 0 ]; then
                        echo "Checking that Preferred Replica has come back with replication mode set."
                        logger Checking that Preferred Replica has come back with replication mode set.
                        sleep 30
                        check_result=`ssh -i ../ghe-acces.pem -p122 admin@10.68.0.196 "bash -s" < failover.sh check-replication `
                        #check_replication=`ghe-repl-status |grep OK |wc | awk '{ print $1 }'`
                        if [ $check_result -eq 6  ]; then
                                echo "Replica configured For Replication mode"
                                logger "Replica configured For Replication mode"
                        else
                                echo "Configuring Preferred Replica For Replication mode"
                                ###call script here...
                        fi
                fi
}

logger ============================================CHECK REPLICA STARTED\=========================================================
##Check if preferred replica is up
check_replica=`nc -z -w1 10.68.0.196 122; echo $?`

##If preferred replica is up, do nothing logs message
if [ $check_replica -eq 0 ]; then

        logger Preferred Replica Node is currently running
        logger Nothing To Do
        echo "*******************Preferred Replica Node is currently running*******************"
        echo "*****************************Nothing to do, just log to syslog*****************************"
else
        sleep 90 ##tweak to 90
        check_replica=`nc -z -w1 10.68.0.196 122; echo $?`
        if [ "$check_replica" -eq 1 ]; then
                logger Preferred replica is down
                echo "Preferred replica is down"
                check_replica=`nc -z -w1 10.68.0.196 122; echo $?`
                ##Wait until the preferred replica is back up
                while [ $check_replica -eq 1 ]
                do
                        echo "Waiting for Preferred Replica to come back online"
                        logger Waiting For Preferred Replica to come back online
                        check_replica=`nc -z -w1 10.68.0.196 122; echo $?`
                        sleep 10 ##tweak
                done
          fi
                ###call check-replication-mode funtion
                check-replication-mode
fi
logger ========================================CHECK REPLICA COMPLETE\==============================================

