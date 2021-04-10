#!/bin/bash

source ./sourceMeAzInfraVars.sh 

secs_to_human() {
    if [[ -z ${1} || ${1} -lt 60 ]] ;then
        min=0 ; secs="${1}"
    else
        time_mins=$(echo "scale=2; ${1}/60" | bc)
        min=$(echo ${time_mins} | cut -d'.' -f1)
        secs="0.$(echo ${time_mins} | cut -d'.' -f2)"
        secs=$(echo ${secs}*60|bc|awk '{print int($1+0.5)}')
    fi
    echo "************************************************************************"
    echo "Time Elapsed to Start AWS Infra : ${min} minutes and ${secs} seconds."
    echo "************************************************************************"
}
start=$(date +%s)

#####



aws ec2 describe-instances  --query 'Reservations[].Instances[].[Placement.AvailabilityZone, State.Name, InstanceId,InstanceType,Tags[?Key==`Name`].Value[]]' --output text | sed '$!N;s/\n/ /'  > mso.list

nl mso.list | awk '{print $4}' >msoec2.list


while read item; 
do 
  aws ec2 start-instances --instance-ids $item;
  echo starting EC2 Instance $item ;
  echo "-------";
done < msoec2.list


rm mso.list
rm msoec2.list
#  Show current State
aws ec2 describe-instances  --query 'Reservations[].Instances[].[Placement.AvailabilityZone, State.Name, InstanceId,InstanceType,Tags[?Key==`Name`].Value[]]' --output text | sed '$!N;s/\n/ /'
secs_to_human "$(($(date +%s) - ${start}))"
