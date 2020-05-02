#!/bin/bash
#Timeshift Hook allowing a pre-update snapshot
user="$1"
get_property() {
  if [ ! -f $CONF_FILE ]; then
  echo "$CONF_FILE not found! Using $1=$3" >&2;
    param_value=$3
  else
    param_value=`sed '/^\#/d' $CONF_FILE | grep $1 | tail -n 1 |\
    cut -d "=" -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'`

    if ([ "$2" == "boolean" ] && [ "$param_value" != true ] && [ "$param_value" != false ]) || \
      ([ "$2" == "integer" ] && [[ ! "$param_value" =~ ^[-+]?([1-9][[:digit:]]*|1)$ ]]) || \
      ([ "$2" == "string" ] && [ "$param_value" == "" ]) ; then
        echo "Wrong paramater in $CONF_FILE. Using $1=$3" >&2
        param_value=$3
    fi
  fi

  echo $param_value
}

#Configuration
readonly CONF_FILE=/etc/pacman.d/timeshift-hook/timeshift-hook.conf
readonly LOCATION=$(get_property "location" "string")
readonly COMMENT=$(get_property "comment" "string")
readonly TIME=$(get_property "time" "integer")

find "$LOCATION" -mmin -"$TIME" | grep $(date +%Y-%m-%d)
if [ $? -eq 0 ]; then
  echo Last timeshift backup was less than "$TIME" minutes ago, aborting backup
else
  /usr/bin/timeshift --create --comments "$COMMENT"
fi
