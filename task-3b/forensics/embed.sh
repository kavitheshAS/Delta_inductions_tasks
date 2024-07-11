#!/bin/bash


cat secret.txt | base64 > encoded.txt
steghide embed -ef encoded.txt -cf mystery.jpg -p "123"

if [ $? -eq 0 ]; then
	echo "secret text has been embedded"
else
	echo "error embedding text into image"
fi



