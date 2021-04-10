#!/bin/bash

./source sourceMeAzInfraVars.sh 

az login --service-principal --username $USERNAME --tenant $TENANT --password $PASSWORD
az account set -s $SUBSID
