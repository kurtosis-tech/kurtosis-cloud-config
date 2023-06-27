#!/bin/bash
#set -euo pipefail # Bash "strict mode"

missing_var=false
if [ -z "$1" ]; then
  echo "Error: No hostname defined as first argument"
  missing_var=true
fi

if [ -z "$2" ]; then
  echo "Error: No IP defined as second argument"
  missing_var=true
fi

if [ -z "$3" ]; then
  echo "Error: No password defined as third argument"
  missing_var=true
fi

if [ "$missing_var" = true ]; then
  exit 1
fi

HOST=$1
IP=$2
PASSWORD=$3

# pass in via files: https://security.stackexchange.com/questions/106525/generate-csr-and-private-key-with-password-with-openssl

# generate CA certificate key pair
#openssl genrsa -aes256 -out ca-key.pem 4096 # set a strong password here this is the private key
openssl genrsa -aes256 -out ca-key.pem 4096 -passout "pass:$PASSWORD" # set a strong password here this is the private key

# The better option is to write out to a file and read that in
#openssl genrsa -aes128 -passout file:passphrase.txt 3072
openssl req -new -x509 -subj "/C=US" -days 365 -key ca-key.pem -sha256 -out ca.pem -passin "pass:$PASSWORD"

# generate server certificate key pair
openssl genrsa -out server-key.pem 4096
openssl req -subj "/CN=$HOST" -sha256 -new -key server-key.pem -out server.csr
echo subjectAltName = "DNS:$HOST,IP:$IP,IP:127.0.0.1" >extfile.cnf
echo extendedKeyUsage = serverAuth >>extfile.cnf
openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf -passin "pass:$PASSWORD"

# generate client certificate key pair
openssl genrsa -out client-key.pem 4096
openssl req -subj '/CN=client' -new -key client-key.pem -out client.csr
echo extendedKeyUsage = clientAuth >extfile-client.cnf
openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out client-cert.pem -extfile extfile-client.cnf -passin "pass:$PASSWORD"

# cleanup
chmod -v 0400 ca-key.pem client-key.pem server-key.pem
chmod -v 0444 ca.pem client-cert.pem server-cert.pem
rm -v client.csr server.csr extfile.cnf extfile-client.cnf
