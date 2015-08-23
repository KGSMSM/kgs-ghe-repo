#!/bin/bash
###switchs iptables to replica or back to primary
sudo /sbin/iptables-restore < /etc/iptables.$1

exit

