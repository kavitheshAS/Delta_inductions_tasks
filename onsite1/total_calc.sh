#!/bin/bash

input_file="/home/blaze/kavithesh/onsite1/unbilled_usage.txt"
cif="/home/blaze/kavithesh/onsite1/c_unb.txt"
lc=$(echo wc -l < "$input_file")
lc=$((lc-1))
head -n "$lc" "$input_file" > "$cif"
a=0
while read -r line; do
    s=$(echo "$line" | awk '{print $2}')
    a=$(echo "$a + $s" | bc)
done < "$cif"

echo "total money tenants owe is: $a"