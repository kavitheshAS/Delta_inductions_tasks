#!/bin/bash

# Define paths and domains
mentees_dir="/home/core/mentees"
domains=("sysad" "appdev" "webdev")
mentors_base_dir="/home/core"
tasks_file="/home/core/submittedtasks/t1.txt"

# Function to remove mentee from a given file
remove_mentee_from_file() {
    mentee_name=$1
    file_path=$2
    if [ -f "$file_path" ]; then
        grep -v "$mentee_name" "$file_path" > /tmp/tempfile && mv /tmp/tempfile "$file_path"
    fi
}

# Function to check and clean mentees
check_and_clean_mentees() {
    for mentee_name in $(ls $mentees_dir); do
        mentee_dir="$mentees_dir/$mentee_name"
        if [ ! -d "$mentee_dir" ]; then
            continue
        fi

        deregistered_domains=()
        for domain in "${domains[@]}"; do
            if [ ! -d "$mentee_dir/$domain" ]; then
                deregistered_domains+=("$domain")
            fi
        done

        # If mentee is deregistered from some domains
        if [ ${#deregistered_domains[@]} -gt 0 ]; then
            for domain in "${deregistered_domains[@]}"; do
                domain_mentors_dir="$mentors_base_dir/$domain"
                if [ -d "$domain_mentors_dir" ]; then
                    for mentor_name in $(ls $domain_mentors_dir); do
                        mentor_file="$domain_mentors_dir/$mentor_name/allocatedMentees.txt"
                        remove_mentee_from_file "$mentee_name" "$mentor_file"
                    done
                fi
            done
        fi

        # If mentee is deregistered from all domains
        if [ ${#deregistered_domains[@]} -eq ${#domains[@]} ]; then
            rm -rf "$mentee_dir"
            userdel "$mentee_name"
        fi

        # Remove mentee info from submitted tasks
        remove_mentee_from_file "$mentee_name" "$tasks_file"
    done
}

# Main script execution
check_and_clean_mentees

