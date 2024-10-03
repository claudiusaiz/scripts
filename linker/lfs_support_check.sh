#!/bin/sh

if [[ $# -ne 1 ]]; then
    echo "Check if a 32-bit ELF binary has large file support (LFS)"
    echo "Usage: $0 <file path>"
    exit 2
fi

find "$1" -type f | xargs file | grep "ELF 32-bit" | cut -f 1 -d : | {
    ret=0
    while read -r f ; do
        if objdump -dr "$f" 2>/dev/null | grep -q -E '(xstat|readdir)@'; then
            if [ $ret -eq 0 ]; then
                echo "file(s) missing large file support:" >&2 
                ret=1
            fi
            echo "  $f" >&2
        fi
    done
    exit "$ret"
}

