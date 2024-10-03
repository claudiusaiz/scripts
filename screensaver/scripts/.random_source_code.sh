#!/bin/bash

source_files="/tmp/source_files"

find / -type f ! -size 0 \( -iname '*.c' -o -iname '*.cpp' -o -iname '*.py' -o -iname '*.pl' -o -iname '*.java' -o -iname 'Makefile*' -o -iname '*.pm' \) 2>/dev/null >$source_files &

# wait a while for the file to be filled with source names
while [[ `wc -l $source_files | cut -d ' ' -f1` -eq 0 ]]; do
	sleep 0.5
done

# choose a number line from the file
files=`wc -l $source_files | cut -d ' ' -f1`
line=$((($RANDOM % $files) + 1))

# now read some lines from that random source file
file=`sed -n -e ${line}p $source_files`
file_lines=`wc -l $file | cut -d ' ' -f1`
start_line=$((($RANDOM % $file_lines) + 1))
for i in `seq $start_line $((start_line + 10))`; do
	sed -n -e ${i}p $file
done

sudo killall find &> /dev/null
rm -f $source_files
