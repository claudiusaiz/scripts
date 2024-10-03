#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <PEM certificate path>"
    exit 1
fi

cert_path=$1

# extract public key in pem format from certificate
pubkey_path="$cert_path.pubkey"
openssl x509 -in $cert_path -pubkey -noout > $pubkey_path

# convert public key from pem to der
pubkeyder_path="$pubkey_path.der"
openssl asn1parse -noout -inform pem -in $pubkey_path -out $pubkeyder_path

# sha256 hash and base64 encode der to string for use
openssl dgst -sha256 -binary $pubkeyder_path | openssl base64

rm $pubkey_path
rm $pubkeyder_path
