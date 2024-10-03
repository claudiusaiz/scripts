#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 /path/to/source/code"
    exit 1
fi

DIR=$1
if [[ "${DIR:0:1}" != '/' ]]; then
    DIR="$PWD/$DIR"
fi

python ~/.vim/bundle/YCM-Generator/config_gen.py -f -v -M="-i" $DIR

echo "Patching to include the dynamically generated header files..."

sed -E -i "s/-I\/tmp\/[a-zA-Z0-9]+\/(.+)/-I${DIR//\//\\\/}\/\.\.\/build-dir\/\1/g" $DIR/.ycm_extra_conf.py
