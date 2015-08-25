#!/bin/bash

#switches traffic to primary or replica node 

sudo /sbin/iptables-restore < /etc/iptables.$1

exit
