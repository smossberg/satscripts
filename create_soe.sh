#!/usr/bin/bash

# Create SOE Content Views for RHEL7 and RHEl6
ORG="MOSSLAB"

#Enable Red Hat Enterprise Linux 7 Server
hammer repository-set enable --product "Red Hat Enterprise Linux Server" --name "Red Hat Enterprise Linux 7 Server (RPMs)" --basearch "x86_64" --releasever "7Server"
# Enable Satellite Tools 6.2
hammer repository-set enable --product "Red Hat Enterprise Linux Server" --name "Red Hat Satellite Tools 6.2 (for RHEL 7 Server) (RPMs)" --basearch "x86_64"

# Enable Software Collections  for RHEL7
hammer repository-set enable --product "Red Hat Software Collections for RHEL Server" --name "Red Hat Software Collections RPMs for Red Hat Enterprise Linux 7 Server" --basearch "x86_64" --releasever "7Server"


################################
# Sync plan

hammer sync-plan create --description "Daily Sync of all repositories" --enabled true --interval 'daily' --name "DailySync" --organization $ORG --sync-date="$(date +'%Y-%m-%d %H:%M:%S')"
hammer product set-sync-plan --sync-plan "DailySync" --name "Red Hat Enterprise Linux Server"
hammer product set-sync-plan --sync-plan "DailySync" --name "Red Hat Satellite Capsule"
hammer product set-sync-plan --sync-plan "DailySync" --name "Red Hat Software Collections for RHEL Server"

hammer content-view create --name 'CV-RHEL7' --label cv_rhel7 --description "Core build for RHEL 7"
hammer content-view add-repository --name 'CV-RHEL7' --product 'Red Hat Enterprise Linux Server' --repository 'Red Hat Enterprise Linux 7 Server RPMs x86_64 7Server'
hammer content-view add-repository --name 'CV-RHEL7' --product 'Red Hat Enterprise Linux Server' --repository 'Red Hat Satellite Tools 6.2 for RHEL 7 Server RPMs x86_64'
#hammer content-view publish --name 'CV-RHEL7' --description 'Initial Publishing'

