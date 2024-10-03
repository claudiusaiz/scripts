#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo Searches if archive files contain the given symbol
    echo
    echo Usage example: $0 memcpy [dir_to_look_for_archives]
    exit 2
fi

symbol_to_search=$1
search_dir=.
if [[ $# -gt 1 ]]; then
    search_dir=$2
fi

for archive_file in ${search_dir}/*.a; do
    ar x $archive_file
    contains_symbol=0

    for objfile in *.o; do
        objdump -t $objfile | grep " ${symbol_to_search}$" &>/dev/null
        if [[ $? -eq 0 ]]; then
            contains_symbol=1
        else
            other_symbols="`echo $(objdump -t $objfile | grep ${symbol_to_search}$ | awk '{print $NF;}') | tr -s ' \t'`"
            if [ -n "$other_symbols" ]; then
                similar_symbols="$similar_symbols $other_symbols"
                contains_symbol=2
            fi
        fi
        rm $objfile

        if [[ $contains_symbol -eq 1 ]]; then
            break
        fi
    done;

    if [[ $contains_symbol -eq 1 ]]; then
        echo "$archive_file contains the symbol $symbol_to_search";
    elif [[ $contains_symbol -eq 2 ]]; then
        final_symbols=""
        for symbol in $similar_symbols; do
            echo "$final_symbols" | grep "$symbol" &>/dev/null
            if [[ $? -ne 0 ]]; then
                final_symbols="$symbol $final_symbols"
            fi
        done
        echo "$archive_file contains similar symbols: $final_symbols";
        unset final_symbols
        unset similar_symbols
    fi;
done
