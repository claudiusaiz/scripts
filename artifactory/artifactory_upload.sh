#!/bin/bash

set -euo pipefail

ARTIFACTORY_BASE_URL=https://hostname/path
ARTIFACTORY_USERNAME=
ARTIFACTORY_TOKEN=


if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <file|dir> <artifactory target directory>"
    echo
    echo "Examples:"
    echo
    echo "$0 test.exe test/packages -> will upload test.exe to $ARTIFACTORY_BASE_URL/test/packages/test.exe"
    echo "$0 dir/test.exe test/packages -> will upload test.exe to $ARTIFACTORY_BASE_URL/test/packages/test.exe"

    exit 2
fi

SOURCE="$1"
TARGET_DIR="$2"

function upload_file
{
    filepath="$1"
    target_dirpath="$2"

    curl -u"$ARTIFACTORY_USERNAME:$ARTIFACTORY_TOKEN" -T "$filepath" "$ARTIFACTORY_BASE_URL/$target_dirpath/$(basename $filepath)"
}

function upload_directory
{
    dirpath="$1"
    target_dirpath="$2"

    #find "$dirpath" -type f | xargs -L1 -I{} echo upload_file '{}' "$target_dirpath/`dirname '{}'`"
    for filepath in $(find "$dirpath" -type f); do
        (upload_file "$filepath" "$target_dirpath/$(dirname $filepath)")
    done
}

if [ -f "$SOURCE" ]; then
    upload_file "$SOURCE" "$TARGET_DIR"
elif [ -d "$SOURCE" ]; then
    upload_directory "$SOURCE" "$TARGET_DIR"
else
    echo "$SOURCE is neither a valid file or directory!"
    exit 1
fi
