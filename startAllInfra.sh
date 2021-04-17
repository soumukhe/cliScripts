#!/bin/bash
./startAwsMso.sh
./startRadius.sh
./startAzInfra.sh
now=$(date +"%r")
echo "--- Please wait 20 minutes from now for CSRs to spin up. Time now is $now ---"
