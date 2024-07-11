#!/bin/bash

image="mystery.jpg"
opfile="extracted.txt"

steghide extract -sf mystery.jpg -p "123" -xf "$opfile"

if [ $? -eq 0 ]; then
	echo "extraction was succesful"
	echo "decoding..."

	base64 -d "$opfile" > "decoded.txt"
	if [ $? -eq 0 ]; then
		echo "decoding was succesful"
	else
		echo "error decoding"

	fi
fi
