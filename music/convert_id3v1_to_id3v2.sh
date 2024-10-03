#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <dir>"
    exit 2
fi

dir=$1

while read mp3file; do
    echo "=== $mp3file ==="

    # skip if no id3v1 tag present
    id3v2 -l "$mp3file" | grep "No ID3v1 tag" &>/dev/null
    if [[ $? -eq 0 ]]; then
        echo "No id3v1 tag"
        continue
    fi

    # skip if no id tag present at all
    id3v2 -l "$mp3file" | grep "No ID3 tag" &>/dev/null
    if [[ $? -eq 0 ]]; then
        echo "No id3 tag at all"
        continue
    fi

    # copy id3v1 to id3v2
    id3v2 -C "$mp3file"

    # delete id3v1 tag
    id3v2 --delete-v1 "$mp3file"
done < <(find $dir -name '*.mp3')
