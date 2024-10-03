#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <URL without schema>"
    exit 1
fi

url=$1
cert_path="./$url.pem"

echo -n | openssl s_client -connect $url:443 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > $cert_path

echo "Saved certificate in: $cert_path"

sha1=`openssl x509 -noout -in $cert_path -fingerprint -sha1`
echo "SHA1 is: $sha1"

sha256=`openssl x509 -noout -in $cert_path -fingerprint -sha256`
echo "SHA256 is: $sha256"
