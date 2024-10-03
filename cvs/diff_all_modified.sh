#!/bin/bash

grep_default_flags="-e ^M  -e ^U  -e ^P  -e ^A  -e ^C "
MAX_LINE=5000
grep_flags=""

if [[ $# -gt 0 ]]; then
    while (( "$#" )); do
        grep_flags="$grep_flags -e ^$1 "
        shift
    done
else
    grep_flags=$grep_default_flags
fi

res=`cvs -nq up 2> /dev/null | grep $grep_flags | cut -f2 -d ' '`
output="cvs -q diff -rHEAD -U $MAX_LINE"
for file in $res; do
    output="${output} ${file}"
done

eval $output > /tmp/diff.out
kompare /tmp/diff.out
