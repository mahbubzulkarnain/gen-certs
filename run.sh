#!/bin/sh

IP=$(echo $1 | egrep -o "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$")

if [ ! $IP ]
then
    echo "Need IP"
    exit 1
fi

DAYS=$(echo $2 | egrep -o "[0-9]")
if [ ! $DAYS ]
then
    DAYS=365
fi

echo "
[req]
default_bits  = 2048
distinguished_name = req_distinguished_name
req_extensions = req_ext
x509_extensions = v3_req
prompt = no

[req_distinguished_name]
countryName = ID
stateOrProvinceName = DKI Jakarta
localityName = Jakarta
organizationName = Self-signed certificate
commonName = $IP: Self-signed certificate

[req_ext]
subjectAltName = @alt_names

[v3_req]
subjectAltName = @alt_names

[alt_names]
IP.1 = $IP
" > openssl.cnf

openssl req -x509 -nodes -days $(echo DAYS) -newkey rsa:2048 -keyout key.pem -out cert.pem -config openssl.cnf
rm openssl.cnf
openssl x509 -noout -text -fingerprint -in cert.pem
