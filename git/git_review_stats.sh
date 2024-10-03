#!/bin/bash

git diff --cached --stat | tail -n 1
git status -s | grep -E "^[^ ?]"
