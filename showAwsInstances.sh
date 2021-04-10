#!/bin/bash

source ./sourceMeAzInfraVars.sh 

echo ""
echo "======================================="
echo "      AWS EC2 State   "
echo " "

aws ec2 describe-instances  --query 'Reservations[].Instances[].[Placement.AvailabilityZone, State.Name, InstanceId,InstanceType,Tags[?Key==`Name`].Value[]]' --output text | sed '$!N;s/\n/ /'


echo""
echo "======================================="
echo ""
