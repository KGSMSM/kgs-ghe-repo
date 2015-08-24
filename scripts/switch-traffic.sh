#!/bin/bash
#switches traffic through forwarder nodes to primary
sudo /sbin/iptables-restore < /etc/iptables.$1

exit
