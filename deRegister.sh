#!/bin/bash

file_loc="/home/core/mentees/$username/domain_pref.txt"
pref1=$(awk -F '>' '{print $1}' "file_loc")
pref2=$(awk -F '>' '{print $2}' "file_loc")
pref3=$(awk -F '>' '{print $3}' "file_loc")
if [[ pref1==dereg_dom ]]; then
	pref1=''
elif [[ pref2==dereg_dom ]]; then
	pref2=''
elif [[ pref3==dereg_dom]]; then
	pref3=''
else
	echo 'no change in preference occured,try entering the correct domain spellings'
fi

n=0
for i in "pref*"; do
	if [[ i!='' ]]; then
		a[n]=i
		let n++
	fi
done

IFS='>'
echo "${a[*]}" > "file_loc"










