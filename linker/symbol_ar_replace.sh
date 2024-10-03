#!/bin/bash

if [[ $# -ne 3 ]]; then
    echo Replace all occurrences of a symbol in an archive file with another symbol
    echo
    echo Usage example: $0 libsomething.a memcpy memcpy@GLIBC_2.2.5
    exit 2
fi

archive_file=$1
symbol_to_search=$2
symbol_to_replace=$3

ar x $archive_file
replaced_symbol=0
for objfile in *.o; do
    objdump -t $objfile | grep " ${symbol_to_search}$" &>/dev/null
    if [[ $? -eq 0 ]]; then
        replaced_symbol=1
    fi
    objcopy --redefine-sym $symbol_to_search=$symbol_to_replace $objfile
    echo Replaced symbol in $objfile...
done

if [[ $replaced_symbol -eq 1 ]]; then
    ar -rcs $archive_file.new *.o
    echo Created new archive: $archive_file.new
else
    echo "Symbol $symbol_to_search was not found in $archive_file, so nothing was replaced"
fi

rm *.o
