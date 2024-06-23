#!/bin/bash

time="@daily"
script="/home/core/displayStatus.sh"
n1_cronjob="$time $script"

c_cronjobs=$( crontab -l 2>/dev/null )

time2="10 10 * 5-7 0,1,3,5"
script2="/home/core/clean_mentees.sh"
n2_cronjob="$time2 $script2"


echo "$c_cronjobs" | { cat; echo "$n1_cronjob"; echo "$n2_cronjob"} | crontab -

