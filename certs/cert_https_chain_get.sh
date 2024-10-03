#!/bin/bash

openssl s_client -showcerts -verify 5 -connect $1:443 < /dev/null > certs
