#!/bin/bash

MOUNT_PATH="//build.ex.org/share/"
USER=

smbclient -U $USER "$MOUNT_PATH"
