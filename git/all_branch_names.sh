#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <JIRA issue number>"
    exit 1
fi

git branch -a | grep "$1" | tr -d ' *' | sed 's/remotes\/origin\///g' | sort | uniq
