#!/bin/bash

if id "core" &>/dev/null; then
    echo "core user exists"
else
    echo "core user doesn't exist"
    useradd core
    if [[ $? == 0 ]]; then
        echo "core has been created"
        passwd core
        if [[ $? == 0 ]]; then
            echo "Password set successfully for core"
        else
            echo "Error: Failed to set password for core"
        fi
    else
        echo "Error: Failed to create core user"
    fi
fi

usermod -aG sudo core

mkdir -p /home/core/mentors
mkdir -p /home/core/mentees
mkdir -p /home/core/mentors/webdev /home/core/mentors/appdev /home/core/mentors/sysad

read -p "ENTER THE TYPE OF USER(mentor or mentee): " usertype
read -p "ENTER THE NAME: " username

if [[ "$usertype" == "mentor" ]]; then
    read -p "enter domain(webdev,appdev,sysad): " mentor_domain
fi

if [[ "$usertype" != "mentee" ]] && [[ "$usertype" != "mentor" ]]; then
    echo "invalid input, please enter either 'mentor' or 'mentee'."
    exit 1
fi

if [[ "$usertype" == "mentor" ]]; then
	mkdir -p "/home/core/mentors/$mentor_domain/$username"
    useradd "$username" -d "/home/core/mentors/$mentor_domain/$username" -m
	passwd "$username"
    if [[ $? -eq 0 ]]; then
        echo "mentor $username has been added successfully"
        touch "/home/core/mentors/$mentor_domain/$username/allocatedMentees.txt"
        pathvar1="/home/core/mentors/$mentor_domain/$username/submittedTasks"
        mkdir -p "$pathvar1/task1" "$pathvar1/task2" "$pathvar1/task3"
    else
        echo "failed to add mentor $username"
    fi
elif [[ "$usertype" == "mentee" ]]; then
	mkdir -p "/home/core/mentees/$username"
	useradd "$username" -d "/home/core/mentees/$username" -m
	passwd "$username"
    if [[ $? -eq 0 ]]; then
        echo "mentee $username has been added successfully"
        pathvar2="/home/core/mentees/$username"
        touch "$pathvar2/domain_pref.txt" "$pathvar2/task_completed.txt" "$pathvar2/task_submitted.txt"
    else
        echo "failed to add mentee $username"
    fi
else
    echo "this shouldn't be displayed, if it is, some error has occurred!"
fi

# Set permissions for core access
chown -R core:core /home/core
chmod -R 700 /home/core/mentors
chmod -R 700 /home/core/mentees
#if didnt work , change above path to "/home/core/mentees/$username"
# Mentors should not access other mentors' directories
if [[ "$usertype"==mentor ]]; then
	chown -R "$username" "/home/core/mentors/$mentor_domain/$username"
	chmod 700 "/home/core/mentors/$mentor_domain/$username"
	if [[ $?==0 ]]; then
		echo "here 75"
	fi

elif [[ "$usertype"==mentee ]]; then
	chown -R "$username" "/home/core/mentees/$username"
	chmod 700 "/home/core/mentees/$username"
else
	echo "enter correct usertype!"
fi

# Core file for mentees_domain.txt with specific permissions
touch /home/core/mentees_domain.txt
chmod 622 /home/core/mentees_domain.txt

#creating a mentees grp and add the core in it

if ! grep -q "^mentees:" /etc/group; then
	if [[ "$usertype"==mentee ]]; then
		sudo groupadd mentees
		sudo usermod -aG mentees core "$username"
	else
		echo "did u mean mentee? enter again!"
	fi
fi

#elif [[ "$usertype"==mentor ]]; then
#	sudo groupadd mentors
#	sudo usermod -aG mentors core "$username"














