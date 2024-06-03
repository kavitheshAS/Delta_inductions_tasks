#!/bin/bash

# Declare associative arrays to store mentor details and allocations
declare -A mentor_capacity
declare -A mentor_domain
declare -A mentor_allocations

# File paths
mentor_details_file="/home/core/mentor_details.txt"
mentee_details_file="/home/core/mentee_details.txt"

# Read mentor details and store in associative arrays
while read -r name domain capacity; do
    mentor_capacity["$name"]=$capacity
    mentor_domain["$name"]=$domain
    mentor_allocations["$name"]=""
done < "$mentor_details_file"

# Read mentee details and store in an array
declare -a mentee_list
while read -r name roll_no; do
    mentee_list+=("$name:$roll_no")
done < "$mentee_details_file"

# Allocate mentees to mentors
for mentee in "${mentee_list[@]}"; do
    mentee_name="${mentee%%:*}"
    mentee_roll="${mentee##*:}"
    
    for mentor in "${!mentor_capacity[@]}"; do
        if (( mentor_capacity["$mentor"] > 0 )); then
            mentor_allocations["$mentor"]+="$mentee_name $mentee_roll"$'\n'
            ((mentor_capacity["$mentor"]--))
            break
        fi
    done
done

# Write allocations to allocatedMentees.txt files in mentor home directories
for mentor in "${!mentor_allocations[@]}"; do
    domain=${mentor_domain["$mentor"]}
    allocation_file="/home/core/mentors/$domain/$mentor/allocatedMentees.txt"
    echo -e "${mentor_allocations[$mentor]}" > "$allocation_file"
done

echo "Mentee allocation completed."
export mentor_allocations
export mentor 


