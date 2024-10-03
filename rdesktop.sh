#!/bin/bash -x

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 hostname"
    exit 1
fi

user="<some user>"
# required sometimes
#extra_args="-0"

if [[ $# -gt 1 ]]; then
    rdesktop -g 1680x1050 $1 -r clipboard:PRIMARYCLIPBOARD -r disk:LocShr=/w/shared/ -u $user $extra_args
else
    rdesktop -g 1680x1050 $1 -r clipboard:PRIMARYCLIPBOARD -u $user $extra_args
fi

