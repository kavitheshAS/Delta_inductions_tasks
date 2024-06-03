#!/bin/bash

# Define paths for the completed files

#loop thro each line in the mentee_domain.txt to find count of sysad,webdev,appdev applications
sysad_t_no=$(grep -o "sysad" "/home/core/mentees_domain.txt" | wc -l)
webdev_t_no=$(grep -o "webdev" "/home/core/mentees_domain.txt" | wc -l)
appdev_t_no=$(grep -o "appdev" "/home/core/mentees_domain.txt" | wc -l)


touch "/home/core/all_completed.txt"
touch "/home/core/s_completed.txt"
touch "/home/core/w_completed.txt"
touch "/home/core/a_completed.txt"

ALL_COMPLETED="/home/core/all_completed.txt"
S_COMPLETED="/home/core/s_completed.txt"
W_COMPLETED="/home/core/w_completed.txt"
A_COMPLETED="/home/core/a_completed.txt"

# Define the mentees directory
MENTEES_DIR="/home/core/mentees"

# Check if the correct number of arguments is passed
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 {all|sysad|webdev|appdev}"
    exit 1
fi

# Function to update the specified completed file
update_completed_file() {
    local completed_file=$1
    shift
    local task_files=("$@")

    # Loop through each directory in the mentees directory
    for user_dir in "$MENTEES_DIR"/*; do
        if [ -d "$user_dir" ]; then
            # Extract the username from the directory name
            username=$(basename "$user_dir")

            # Check if any of the task files exist in the user's directory
            for task_file in "${task_files[@]}"; do
                if [ -e "$user_dir/$task_file" ]; then
                    # Check if the username is already in the completed file
                    if ! grep -q "^$username$" "$completed_file"; then
                        echo "$username" >> "$completed_file"
                        echo "Added $username to $completed_file"
                    fi
                    break
                fi
            done
        fi
    done
}

# Calculate and print the completion percentage
total_count=$(wc -l < "/home/core/mentee_details.txt")
total_completed_count=$(wc -l < "$ALL_COMPLETED")
total_completed_sysad=$(wc -l < "$S_COMPLETED")
total_completed_webdev=$(wc -l < "$W_COMPLETED")
total_completed_appdev=$(wc -l < "$A_COMPLETED")

total_percent=$(echo "scale=2; 100 * $total_completed_count / $total_count" | bc)
sys_percent=$(echo "scale=2; 100 * $total_completed_sysad / $sysad_t_no" | bc)
web_percent=$(echo "scale=2; 100 * $total_completed_webdev / $webdev_t_no" | bc)
app_percent=$(echo "scale=2; 100 * $total_completed_appdev / $appdev_t_no" | bc)






# Main logic to determine which file to update based on the argument
case "$1" in
    all)
        update_completed_file "$ALL_COMPLETED" "sysad" "webdev" "appdev"
		echo "total completion percentage: $total_percent"
        ;;
    sysad)
        update_completed_file "$S_COMPLETED" "sysad"
		echo " sysad completion percentage: $sys_percent"
        ;;
    webdev)
        update_completed_file "$W_COMPLETED" "webdev"
		echo "webdev completion percentage: $web_percent"
        ;;
    appdev)
        update_completed_file "$A_COMPLETED" "appdev"
		echo "appdev completion percentage: $app_percent"
        ;;
    *)
        echo "Invalid argument. Usage: $0 {all|sysad|webdev|appdev}"
        exit 1
        ;;
esac

