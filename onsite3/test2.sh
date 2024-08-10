#!/bin/bash

# Base URL of the main server
BASE_URL="http://mainserver.local"

# Messes
MESSAGES=("mess1" "mess2" "mess3")

# Number of requests to send
REQUESTS=100

# Send requests and count hits
for mess in "${MESSAGES[@]}"; do
    echo "Sending requests to $mess"
    for i in $(seq 1 $REQUESTS); do
        curl -s -o /dev/null -X POST -d "roll_number=$i&mess=$mess" $BASE_URL
    done
done
