#!/bin/bash

details_file="/home/blaze/kavithesh/onsite1/details.txt"
input_file="/home/blaze/kavithesh/onsite1/unbilled_usage.txt"
log="/home/blaze/kavithesh/onsite1/network_usage.log"

while read -r line; do
    user=$(echo "$line" | awk '{print $1}')
    grep $user $log >> "$details_file"
done < "$input_file"

