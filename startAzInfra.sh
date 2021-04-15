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
    echo "***********************************************************************************"
    echo "Time Elapsed to Run Stop Azure Infra Script : ${min} minutes and ${secs} seconds."
    echo "***********************************************************************************"
}
start=$(date +%s)


echo " "
echo " --------- trying to log in ......."
az login --service-principal --username $USERNAME --tenant $TENANT --password $PASSWORD > /dev/null
az account set -s $SUBSID
echo " --------- login complete ----------"
echo "---------- gathering status ........" 
az vm list -d -o table
echo "about to stop AZ-Infra..........."

az vm start --resource-group capic-azure --name CloudAPIC --no-wait > /dev/null


echo "---------- gathering status ........"
az vm list -d -o table
# az logout
echo $(date), $USER, Started AzureInfra 
#
secs_to_human "$(($(date +%s) - ${start}))"
echo " adding dummy rule for REACHABILITY WORKAROUND" ....
az network nsg rule create -g capic-azure --nsg-name controllers_cloudapp-cloud-infra -n dummy4000Rule --priority 4000 --source-port-ranges '*' --destination-port-ranges 4000 --access Deny
