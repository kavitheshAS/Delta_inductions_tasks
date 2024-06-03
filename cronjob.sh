#!/bin/bash

time="@daily"
script="/home/core/displayStatus.sh"

n_cronj="$time $script"

c_cronjobs=$( crontab -l 2>/dev/null )

time2="10 10 */3 5-7 0"
script2=""









echo "$c_cronjobs" | { cat; echo "$n_cronjob"; } | crontab -

