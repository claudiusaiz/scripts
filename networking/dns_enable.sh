#!/bin/bash

mv /etc/resolv.conf.bak /etc/resolv.conf
head -n -1 /etc/systemd/resolved.conf > /etc/systemd/resolved.conf.bak
mv /etc/systemd/resolved.conf.bak /etc/systemd/resolved.conf
systemctl start systemd-resolved
systemctl status systemd-resolved
