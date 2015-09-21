#!/bin/bash

EIP=52.18.153.196
INSTANCE_ID=i-354bb599

/usr/local/bin/aws ec2 disassociate-address --public-ip $EIP
/usr/local/bin/aws ec2 associate-address --public-ip $EIP --instance-id $INSTANCE_ID

