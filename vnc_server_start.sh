#!/bin/bash

# basics:
# - make sure you have rules in your firewall for ports 5900/6000
# - set passwd by doing x11vnc -storepasswd, then always start x11vnc like below
sudo iptables -A INPUT -p tcp --dport 5900 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 6000 -j ACCEPT
x11vnc -display :0 -rfbauth /home/claudiu/.vnc/passwd -remap ISO_Level3_Shift-Alt_L -repeat &
