#!/bin/sh
# This script will use hammer to create a given list of Host Collection on the local Satellite Server

HOST_COLLECTIONS=("RHEL7" "RHEL6" "RHEL5" "TEST" "QA" "PROD" "OracleDB" "Physical")
ORG=""

for hc in "${HOST_COLLECTIONS[@]}"; do
	echo "Creating Host Collection $hc"
	hammer host-collection create --name $hc --organization '"$ORG"'

done
