#!/bin/bash

##SHREP="ssh -p122 admin@10.68.0.196 'bash -s'"
#SSHPRI="ssh -p122 admin@10.68.0.135 'bash -s'"
FW1="ssh -i ghe-acces.pem -p222 msmadmin@10.68.0.35 'bash -s'"
FW2="ssh -i ghe-acces.pem -p222 msmadmin@10.68.0.79 'bash -s'"

##echo $SSHPRI

if [ $# -lt 1 ]
then
        echo "Usage : $0 failover|failback"
        exit 0
fi


function check1 {
        ##exec $SSHREP
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
        ##exec $SSHREP
        echo "**************Checking Replication has been or is already stopped successfully.***************"
        check2=`ghe-repl-status |grep OK |wc | awk '{ print $1 }'`  ###should be 0
        if [ $check2 -eq 0  ]; then
                echo "***************Replication has been or is stopped successfully.*****************"
                if [ $1 == "primary"  ]; then
                        backout1
                fi
                ##switch-traffic $1
        else
                echo "******************Unexpected status returned from check2, failing back to Primary.****************"
                backout1
        fi
}


function switch-traffic() {
                #exec $FW1
                echo "**********Switching traffic from Forwarder 1 to $1 (iptables.xxxx)********** (DO IT MANUALLY)"
                #/sbin/iptables-restore < /etc/iptables.$1
                ##exec `ssh -i ghe-acces.pem -p222 msmadmin@10.68.0.35 "bash -s" < -- switch-traffic.sh $1`
                ##exec switch-traffic.sh $1
                echo "*************Traffic Switched to $1 (iptables.xxxx)*********"
}


function backout1 {
                ###exec $SSHREP
                yes | ghe-repl-setup 10.68.0.135
                ghe-repl-start
                sleep 5
                backout-check1
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



function change-maintenance-mode() {
        ##exec `ssh -i ghe-acces.pem -p122 admin@10.68.0.135 "bash -s" < change-maintenance-mode.sh $1`
        ##exec change-maintenance-mode.sh $1
        echo "Maintenace Mode Re-enabled On Primary."

}



case "$1" in
        failover)
                check1
                check2 replica
        ;;

        failback)
                check2 primary
        ;;

        *) echo "Invalid option failover|failback"
   ;;

esac

