#!/bin/bash

#switcher to route traffic through forwarder 1 or 2
#switcher to route traffic through forwarder 1 or 2
sudo /sbin/iptables-restore < /etc/iptables.$1

exit
