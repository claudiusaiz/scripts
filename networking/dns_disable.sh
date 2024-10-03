#!/bin/bash

echo "DNSStubListener=no" >> /etc/systemd/resolved.conf
systemctl stop systemd-resolved
mv /etc/resolv.conf /etc/resolv.conf.bak
systemctl status systemd-resolved
