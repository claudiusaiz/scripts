#!/bin/bash

set -euxo pipefail

doxygen -g
sed -i "s/^RECURSIVE \+= \+NO/RECURSIVE = YES/g" Doxyfile
sed -i "s/^EXTRACT_ALL \+= \+NO/EXTRACT_ALL = YES/g" Doxyfile
doxygen
firefox html/index.html
