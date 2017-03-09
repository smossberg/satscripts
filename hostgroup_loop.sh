#!/bin/sh
# Creates hostgroups

org=""

# 1st /root level
tops=("Sikker sone" "External DMZ sone" "Internal DMZ sone" "Intern sone")

#2:nd level
envs=("Test" "QA" "Production")

# 3rd level
rhel_majors=("RHEL5" "RHEL7"

for top in "${tops[@]}"
do
	echo "Creating root Host Group $top" 
	hammer hostgroup create --name $top --organization '$org' --locations $top
	for env in "${envs[@]}"
	do
		#dc=$(echo $top | sed -r 's/HG/DC/g')
		echo "Adding 2:nd level Host Group for $env"
		hammer hostgroup create --parent $top --name $env --lifecycle-environment $env --organization '"$org"' --locations $top
		
		for rhel_major in "${rhel_majors[@]}"
		do
			PARENT_ID=$(hammer hostgroup list --order | grep "$top/$env " | awk '{print $1}')
			echo "adding 3rd level Host Group for $rhel_major to $top-$env with id $PARENT_ID"
			case "$rhel_major" in

			RHEL7)	hammer hostgroup create --parent-id $PARENT_ID --name RHEL7 --architecture x86_64 --operatingsystem "RedHat 7.2" --organization "$org" --content-view CV-RHEL7 
				;;
			RHEL6)	hammer hostgroup create --parent-id $PARENT_ID --name RHEL6 --architecture x86_64 --operatingsystem "RedHat 6.8" --organization "$org" --content-view CV-RHEL6
				;;
			RHEL5)	hammer hostgroup create --parent-id $PARENT_ID --name RHEL5 --architecture x86_64 --operatingsystem "RedHat 5.11" --organization "$org" --content-view CV-RHEL5 
				;;
			esac
		done	
	done
done

                                                                                                                                                                                                                
                                                                                                                                                                                                                  
                                                                                                                                              
