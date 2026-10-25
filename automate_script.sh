#!/bin/bash

val=$1
inp=""
out=""
for i in {0..32}; do
	out=$(./$val $inp)
	inp="$inp${out:0:1}"
	echo $inp
done
echo $inp
