#!/bin/bash

#url="http://mess.local"
url="http://mainserver.local" #for mess1

mess_name="mess1" # change for other messes
roll_number="108123055"

declare -A hits
hits[1]=0
hits[2]=0
hits[3]=0

for i in {1..100}; do
    response=$(curl -s -X POST -d "roll_number=$roll_number&mess=$mess_name" $url)
    if [[ $response == *"Instance ID: 1"* ]]; then
        hits[1]=$((hits[1] + 1))
    elif [[ $response == *"Instance ID: 2"* ]]; then
        hits[2]=$((hits[2] + 1))
    elif [[ $response == *"Instance ID: 3"* ]]; then
        hits[3]=$((hits[3] + 1))
    fi
done

echo "Hits on Instance 1: ${hits[1]}"
echo "Hits on Instance 2: ${hits[2]}"
echo "Hits on Instance 3: ${hits[3]}"


