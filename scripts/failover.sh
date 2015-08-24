#!/bin/bash

if [ $# -lt 1 ]
then
        echo "Usage : $0 failover|failback"
        exit 0
fi


function check1 {
        echo "**********Checking replication is in place before attempting failover.***********"
                check1=`ghe-repl-status |grep OK |wc | awk '{ print $1 }'` ##should be 6
                if [ $check1 -eq 6  ]; then
                        echo "***********Promoting Replica to Primary.**********"
                        ghe-repl-promote
                        sleep 5
                else
                        echo "*******Unexpected status count, aborting failover.*******"
                        exit 0
                fi
}


function check2() {
        echo "**************Checking Replication has been or is already stopped successfully.***************"
        check2=`ghe-repl-status |grep OK |wc | awk '{ print $1 }'`  ###should be 0
        if [ $check2 -eq 0  ]; then
                echo "***************Replication has been or is stopped successfully.*****************"
                if [ $1 == "primary"  ]; then
                        backout1
                fi
        else
                echo "******************Unexpected status returned from check2, failing back to Primary.****************"
                backout1
        fi
}


function backout1 {
                yes | ghe-repl-setup -f 10.68.0.135
                ghe-repl-start
                sleep 5
                backout-check1
}

function convert-primary-to-replica {
                yes | ghe-repl-setup 10.68.0.196
                ghe-repl-start
                sleep 5
                check-convert
}


function check-convert {
                check4=`ghe-repl-status |grep OK |wc | awk '{ print $1 }'`
                if [ $check4 -eq 6  ]; then
                        exit 1
                        echo "Convertion completed successfully."
                else
                        echo "***************Raise a CRITICAL alarm, something went really wrong.****************"
                        exit 0
                fi
}


function backout-check1 {
                check3=`ghe-repl-status |grep OK |wc | awk '{ print $1 }'`
                if [ $check3 -eq 6  ]; then
                        exit 1
                        echo "Backout completed successfully."
                        echo "Disabling Maintenace Mode On Primary."
                        ##change-maintenance-mode u

                else
                        echo "***************Raise a CRITICAL alarm, something went really wrong.****************"
                        exit 0
                fi
}


case "$1" in
        failover)
                check1
                check2 replica
        ;;

        convert-primary)
                convert-primary-to-replica
                check1
        ;;


        failback)
                check2 primary
        ;;

        re-promote)
                convert-primary-to-replica
                check1
        ;;

        *) echo "Invalid option failover|failback"
   ;;

esac
