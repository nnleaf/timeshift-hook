#!/bin/bash
#Timeshift Hook allowing a pre-update snapshot
user="$1"
find /mnt/x1_backup/timeshift/snapshots-ondemand -mmin -60 | grep $(date +%Y-%m-%d)
if [ $? -eq 0 ]; then
    echo Last timeshift backup was less than 60 minutes ago, aborting backup
else
    /usr/bin/timeshift --create --comments "timeshift--hook_snapshot"
fi
