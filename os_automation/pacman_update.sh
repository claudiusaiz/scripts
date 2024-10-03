#!/bin/bash

echo >> ~/last_pacman.out
echo "=================================">> ~/last_pacman.out
date >> ~/last_pacman.out
echo "=================================">> ~/last_pacman.out
sudo pacman -Syu 2>&1 | tee -a ~/last_pacman.out
