#!/bin/bash

index=0
addr=()

# print addresses at ctrl-c
trap print_addr INT
function print_addr() {
    echo
    for crt_addr in ${addr[@]}; do
        printf '0x%x ' $crt_addr
    done
    echo
    exit 0
}

while read line; do
    # get the address from the line
    crt_addr=`echo "$line" | sed -r "s/.+\[(0x[0-9a-f]+)\].*/\1/g"`

    # skip lines that don't contain an address
    if [[ ! "$crt_addr" =~ "0x" ]]; then
        continue
    fi

    # subtract 5 from the address - this is the length of the CALL instruction
    addr[$((index++))]=$((crt_addr - 5))
done
