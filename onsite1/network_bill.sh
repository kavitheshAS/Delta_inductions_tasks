#!/bin/bash

log_file="/home/blaze/kavithesh/onsite1/network_usage.log"
output_file="/home/blaze/kavithesh/onsite1/unbilled_usage.txt"
error_file="/home/tbd.txt"
declare -A amount_due

while read -r line; do

    username=$(echo "$line" | awk '{print $3}')
    usage1=$(echo "$line" | awk '{print $5}')
    usage2=$(echo "$line" | awk '{print $6}')
    #usage=$((echo "$suage1+$usage2" | bc))
    usage=$(expr $usage1 + $usage2)
    #rate=$(0.05 | bc) &> 
    billed=$(echo "$line" | awk '{print $7}')

    if [[ "$billed" == "Billed" ]]; then
        continue
    fi

    if [ -z "${amount_due[$username]}" ]; then
        amount_due["$username"]=0
    fi

    amount=$(echo "$usage * 0.05" | bc)
    amount_due["$username"]=$(echo "${amount_due[$username]} + $amount" | bc)
done < "$log_file" 

for user in "${!amount_due[@]}"; do
    echo "$user ${amount_due[$user]}"
done | sort -k2,2nr > "$output_file"




cat "$output_file" | head -n 3
