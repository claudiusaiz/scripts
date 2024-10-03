#!/bin/bash

function usage
{
    echo "Usage: $0 file_containing_filenames_to_revert"
}

if [[ $# == 0 ]]; then
    usage
    exit 1
fi

while read filename; do
    mv $filename ${filename}.bkp
    cvs up -A $filename
    mv ${filename}.bkp $filename
    cvs stat $filename
    echo
done < $1
