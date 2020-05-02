#!/bin/bash
#Timeshift Hook allowing a pre-update snapshot
user="$1"

#Configuration
readonly CONF_FILE=/etc/pacman.d/timeshift-hook/timeshift-hook.conf
readonly COMMENT=$(get_property "comment" "string")
readonly TIME=$(get_propety "time" "string")

find /run/timeshift/backup/timeshift/snapshots-ondemand -mmin -"$time" | grep $(date +%Y-%m-%d)
if [ $? -eq 0 ]; then
    echo Last timeshift backup was less than 60 minutes ago, aborting backup
else
    /usr/bin/timeshift --create --comments "$COMMENT"
fi
