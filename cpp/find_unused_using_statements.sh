#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 all|filenames <regex file pattern>"
    exit 1
fi

find_mode="$1"
pattern="$2"

for file in `find -name "$pattern"`; do
    for using_name in `grep using $file | tr -d ';' | cut -d ' ' -f2 | sed -r 's/.+::([^:]+)$/\1/g'`; do
        grep -w $using_name $file | grep -v using 2>&1 >/dev/null
        if [[ $? -ne 0 ]]; then
            if [[ "$find_mode" == "filenames" ]]; then
                echo "Unused using statements in $file"
                break
            else
                echo "Unused 'using $using_name' statement in $file"
            fi
        fi
    done
done
