#!/bin/bash

read -p "enter rollno: " roll_no
read -p "enter username: " username

read -p "enter first preference: " a[0]
read -p "enter second preference(n for null): " a[1]
read -p "enter third preference(n for null): " a[2]


for (( i=${#a[@]}-1 ; i>=0 ; i-- ));
do
	if [[ "${a[i]}" == "n" ]];
	then
		unset "a[i]"
	fi
done

a=("${a[@]}")

#echo "${a[@]}"

IFS='>'
echo -p  "${a[*]}" > "/home/core/mentees/$username/domainpref.txt"

first_line=$(head -n 1 "/home/core/mentees_domain.txt")
if [[ "$first_line" != "ROLLNO NAME DOMAIN" ]]; then
	echo "ROLLNO NAME DOMAIN" >> "/home/core/mentees_domain.txt"
fi
echo "$roll_no $username ${a[*]}" >> "/home/kavithesh/Delta_ind/mentees_domain.txt"

if [[ $? == 0 ]]; then
	echo "information has been updated succesfully!"
fi
echo "********************************"
cat "/home/core/mentees_domain.txt"
echo "********************************"




