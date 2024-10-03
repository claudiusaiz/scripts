#!/bin/bash

MOUNT_PATH=//build.ex.org/share/something
USER=

sudo mount.cifs $MOUNT_PATH /mnt/smb/ -v -o username=$USER,domain=AD,uid=1000,gid=1000
