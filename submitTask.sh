#!/bin/bash

# Check if the script is run by mentor or mentee

read -p "Enter user type (mentor/mentee): " usertype
read -p "Enter username: " username
read -p "Enter task number: " task_no
read -p "Enter domain to submit: " domain

if [ "$usertype" == "mentee" ]; then
	read -p "Enter roll number(for mentee): " roll_no
    echo "$roll_no $username task$task_no" > "/home/core/mentees/$username/task_submitted.txt"
	

    pathvar="/home/core/mentees/$username"

    mkdir -p "$pathvar/webdev" "$pathvar/appdev" "$pathvar/sysad"

    touch "$pathvar/$domain/task1.txt" "$pathvar/$domain/task2.txt" "$pathvar/$domain/task3.txt"

elif [ "$usertype" == "mentor" ]; then
    n=1
    while IFS= read -r line; do
        mentee=$(echo "$line" | awk '{print $1}')
        a[n]="$mentee"
        ((n++))
    done < "/home/core/mentors/$domain/$username/allocatedMentees.txt"

    for mentee in "${a[@]}"; do
        if [ -s "/home/core/mentees/$mentee/$domain/task$task_no.txt" ]; then
            echo "Task$task_no has been done"
        else
            echo "Task$task_no has not been done"
        fi

        ln -s "/home/core/mentors/$domain/$username/submittedTasks/task$task_no.txt" "/home/core/mentees/$mentee/$domain"

        echo "$roll_no $username task$task_no" >> "/home/core/mentees/$mentee/task_completed.txt"
    done
else
    echo "Invalid user type. Please enter 'mentor' or 'mentee'."
fi

