#!/bin/bash
#switches traffic through forwarder nodes to primary or replica....
sudo /sbin/iptables-restore < /etc/iptables.$1

exit
