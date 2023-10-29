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

osname=$(uname -s);

if [ "$osname" = "Darwin" ]; then
    while(true) do
        have_connection=$(scutil --nc list | grep FoXray | grep Connected)
        wifi=$(networksetup -getairportnetwork en0 | grep "You are not" )
        if [  -z "$wifi" ]; then
            wifi_status="enabled"
        else
            wifi_status="disabled"
        fi
        current_date=$(date)
        if [ -z "$have_connection" ]; then
            networksetup -setairportpower en0 off
            exit
            echo "WIFI turned OFF ${current_date}"
            elif [ "$wifi_status" = "disabled" ]; then
            networksetup -setairportpower en0 on
            echo -e "WIFI turned ${RED_COLOR_CODE}ON ${TRANSPARENT}${current_date}";
        else
            echo -e "WIFI is still ${BLUE_COLOR_CODE}ON ${TRANSPARENT}"
        fi
        sleep 0.1
    done
    
else
    while(true) do
        have_connection=$(nmcli con show --active | grep "$app_name");
        wifi_status=$(nmcli radio wifi);
        current_date=$(date)
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
fi
