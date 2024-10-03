#!/bin/bash

DIFF_TOOL=kompare
USAGE="Usage: $0 [file1] [file2] ... [filen]"
MAX_LINE=5000

if [ $# == 0 ];then
    echo $USAGE
    exit 1
fi

output="cvs diff -C $MAX_LINE"
while (( "$#" )); do
    output="${output} $1"
    shift
done

eval $output > /tmp/diff.out
$DIFF_TOOL /tmp/diff.out&
