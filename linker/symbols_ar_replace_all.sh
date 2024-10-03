#!/bin/bash

if [[ $# -lt 1 ]]; then
    echo Replace all symbols in a static library with other specified symbols
    echo
    echo Usage example: $0 libsomething.a [force_link_glibc_2.4.h]
    exit 2
fi

archive_file=$1
symbols_file=glibc_2_4_symbols.txt

# create symbols file if needed
if [[ ! -f $symbols_file ]]; then
    if [[ $# -eq 1 ]]; then
        echo "Must supply symbols header file!"
        exit 2
    fi
    echo "Generating symbols file $symbols_file from $2..."
    cat $2 | grep .symver | grep -v NOT_PRESENT | sed 's/__asm__(".symver \([^,]*\),\([^,]*\)".*/\1 \2/g' > $symbols_file
fi

# read glibc 2.4 symbols in memory
echo "Reading glibc 2.4 symbols..."
declare -A symbols
while read line; do
    symbols[`echo $line | cut -d ' ' -f1`]=`echo $line | cut -d ' ' -f2`
done < $symbols_file

# search glibc symbols in object files
ar x $archive_file
for objfile in *.o; do
    echo "Processing $objfile"
    for obj_symbol in `objdump -t $objfile | grep UND | tr -s '\t' ' ' | awk '{print $NF}'`; do
        if [[ "${!symbols[@]}" =~ $obj_symbol && "${symbols[$obj_symbol]}" != "" ]]; then
            echo -e "\tReplacing $obj_symbol with ${symbols[$obj_symbol]}"
            objcopy --redefine-sym $obj_symbol=${symbols[$obj_symbol]} $objfile
        fi
    done
done

# recreate archive and clean up
ar -rcs $archive_file.new *.o
echo Created new library: $archive_file.new
rm *.o
