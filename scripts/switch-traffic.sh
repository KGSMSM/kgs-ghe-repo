#!/bin/bash

#switcher to route traffic through forwarder 1 or 2 xxxxx
sudo /sbin/iptables-restore < /etc/iptables.$1

exit
