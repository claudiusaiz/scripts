#!/bin/bash

# change directory to directory of the script
cd "$(dirname "$0")"

# get all scripts that can be run
files=`ls ./scripts/`
files_no=`echo $files | wc -w`

last_file=""

# run random scripts from the directory
while [[ 1 ]]; do
    # extract a random file
    file_no=$((($RANDOM % $files_no) + 1))
    file=`echo $files | cut -d ' ' -f${file_no}`

    # don't run the previous script again
    if [[ "$file" == "$last_file" && "$file" == "location.sh" ]]; then
        continue
    fi

    # run the script
    eval ./scripts/${file} 2>/dev/null
    if [[ $? -ne 0 ]]; then
        continue
    fi
    echo

    last_file=$file
    sudo killall find &> /dev/null
    sleep 2

    # added this so it can be run from the general settings
    break
done
