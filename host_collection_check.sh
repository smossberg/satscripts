#!/bin/sh
# This Script checks all hosts so that they belong to at least one hostcollection in three different categories
# It fetches all the id's for all Hosts and then all Host id's in the different Host Collections
#
# The relationship between Host Collection and a Host is many to many
# A host can belong to many Host Collections and a Host Collection can have many hosts
# By fetching all the Host ID's related to a specific Host collection, we can
# group together different Host Collections and create Categories.
# RHEL6 and RHEL7 makes out a category of RHEL Major versions
# These together contains a set of Host ID's
#
# We make a looping comparison: if the Host ID appears in the list of related Host ID's from the grouping of two Host Collection groups, it's green
# otherwise it's missing that Category.
#
# 2017-02-06
# smossber@redhat.com

# Save all hosts to hash table
# ID | HOSTNAME
echo "Running.."
echo "Fetchning all Host ID's"
declare $(hammer --output csv host list | tail -n +2 | awk -F ',' '{print "hosts["$1"]="$2}')
for host_id in "${!hosts[@]}"; do
	echo "$host_id ${hosts[$host_id]}"
done

# Get all host ids from the Host Collections.
# Make a Category Host ID list.
rhel_majors=('RHEL6' 'RHEL7')
rhel_majors_host_ids=()
for RHEL_MAJOR in ${rhel_majors[@]}; do
	echo "Fetchning RHEL Category Host $RHEL_MAJOR ID's"
	rhel_majors_host_ids+=($(hammer --output csv host-collection hosts --name $RHEL_MAJOR | tail -n +2 | awk -F ',' '{print $1}'))
done

lifecycle_environments=('UTV' 'TEST' 'UTB' 'PROD')
lcenv_host_ids=()
for life_cycle in ${lifecycle_environments[@]}; do
	echo "Fetchning Life Cycle Environment $life_cycle Host ID's"
	lcenv_host_ids+=($(hammer --output csv host-collection hosts --name $life_cycle | tail -n +2 | awk -F ',' '{print $1}'))
done

network_environments=('EXTERN' 'INTERN')
network_environment_host_ids=()
for network in ${network_environments[@]}; do
	echo "Fetchning Network Environment $network Host ID's"
	network_environment_host_ids+=($(hammer --output csv host-collection hosts --name $network | tail -n +2 | awk -F ',' '{print $1}'))
done

missing_host_collections=false
# Check if host ID appears in the Category Host ID list
echo ""
echo "Check for missing Host Collections for all Hosts:"
echo ""

echo "# RHEL Host Collections: "
for host_id in ${!hosts[@]}; do
	if ! echo "${rhel_majors_host_ids[@]}" | fgrep --word-regexp "$host_id" 1> /dev/null 2>&1; then
		missing_host_collections=true
		echo "- ${hosts[$host_id]} is MISSING a RHEL Host Collection"
	fi
done
echo ""
echo "# Lifecycle Host Collections:"
for host_id in ${!hosts[@]}; do
	if ! echo "${lcenv_host_ids[@]}" | fgrep --word-regexp "$host_id" 1> /dev/null 2>&1; then
		missing_host_collections=true
		echo "- ${hosts[$host_id]} is MISSING a Life Cycle Host collection"
	fi
done 
echo ""
echo "# Network Host Collections:"
for host_id in ${!hosts[@]}; do
	if ! echo "${network_environment_host_ids[@]}" | fgrep --word-regexp "$host_id" 1> /dev/null 2>&1; then
		missing_host_collections=true
		echo "- ${hosts[$host_id]} is MISSING a Network Environment Host collection"
	fi
done
echo ""
if  $missing_host_collections; then
	echo "There are hosts missing necessary Host Collections"
	echo "Add the hosts to the missing Host Collection categories: https://nrkxpsat001.migrationsverket.se/host_collections"
else
	echo "All Hosts belong to at least one of the necessary Host Collection categories"
fi

