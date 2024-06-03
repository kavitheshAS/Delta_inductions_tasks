#!/bin/bash

read-p "enter the task number" task_no
total_no=$(wc -l /home/core/mentee_details.txt)

#loop thro each user,look for the task_completed.txt, if not empty , mark them done

mkdir /home/core/submission_count
sub_cnt="/home/core/submission_count"

touch "sub_cnt/task1.txt" "sub_cnt/task2.txt" "sub_cnt/task3.txt"


# Define the root directory to search in
root_dir="/home/core/mentees"

# Define the filename to check
file_to_check="task_completed.txt"

# Loop through each directory at the given level
n=x
for dir in "$root_dir"/*/; do
    # Check if the file exists in the current directory
    if [ -f "${dir}${file_to_check}" ]; then
        # Check if the file is empty
        if [ ! -s "${dir}${file_to_check}" ]; then
            echo "The file ${dir}${file_to_check} is empty."
        else
            echo "The file ${dir}${file_to_check} is not empty."
			echo "#dir name" >> "/home/core/submission_count/task$task_no.txt"
			a[n]="#dir name"
        fi
    else
        echo "The file ${dir}${file_to_check} does not exist."
    fi
done
x=$(n)
