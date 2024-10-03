#!/bin/bash

if [[ $1 == "-h" ]]; then
    echo "Usage: $0 [<JIRA issue number>]"
    exit 1
fi

if [ -z "$1" ]; then
    branch_name=`git branch | grep -E "^\*" | cut -d ' ' -f2`
else
    branch_name=`git branch -a | grep "$1" | tail -n 1 | tr -d ' '`
    if [[ "$branch_name" =~ "remote" ]]; then
        branch_name=`echo -n $branch_name | cut -d/ -f3-`
    fi
fi

echo $branch_name
