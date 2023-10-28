#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "run as root"
  exit 1
fi


if [ -z "$1" ]; then
  app_name='nekoray'  # Default value when no argument is provided
else
  app_name="$1"
fi


RED_COLOR_CODE='\033[0;31m'
BLUE_COLOR_CODE='\033[0;34m'
TRANSPARENT='\033[0m'

echo "START CHECKING $app_name"

while(true) do
  current_date=$(date)
  have_connection=$(nmcli con show --active | grep "$app_name");
  wifi_status=$(nmcli radio wifi);
  if [ -z "$have_connection" ]; then
    nmcli radio wifi off
    echo "WIFI turned OFF ${current_date}"
  elif [ "$wifi_status" = "disabled" ]; then
    nmcli radio wifi on
    echo -e "WIFI turned ${RED_COLOR_CODE}ON ${TRANSPARENT}${current_date}";
  else
   echo -e "WIFI is still ${BLUE_COLOR_CODE}ON ${TRANSPARENT}"
  fi
  sleep 0.1
done
