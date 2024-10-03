#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo Usage: $0 hostname days_until_expiration
    echo Example: $0 cdn.example.com 365
    exit 2
fi

hostname=$1
days_till_expire=$2
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days $days_till_expire -subj "/C=RO/ST=District/L=Bucharest/O=Test SRL/OU=Operational IT/CN=$hostname" -nodes -sha256

cert_basename=${hostname}_$(date -d "+$days_till_expire days" +%F)
cert_path=$cert_basename.cert.pem
key_path=$cert_basename.key.pem
mv cert.pem $cert_path
mv key.pem $key_path
echo "Created $cert_path"
echo "Created $key_path"
