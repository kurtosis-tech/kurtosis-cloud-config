#!/bin/bash

set -v

missing_var=false
if [ -z "$1" ]; then
  echo "Error: No UUID defined as first argument"
  missing_var=true
fi

if [ -z "$2" ]; then
  echo "Error: No name defined as second argument"
  missing_var=true
fi

if [ -z "$3" ]; then
  echo "Error: No IP defined as third argument"
  missing_var=true
fi

if [ "$missing_var" = true ]; then
  exit 1
fi

UUID="$1"
NAME="$2"
IP="$3"
CONFIG_FILE="config.json"

replace_values () {
  TARGET=$1
  REPLACEMENT=$2
  sed -i 's!'"$TARGET"'!'"$REPLACEMENT"'!g' "$CONFIG_FILE"
}

ca_pem_base64=$(base64 -w0 ca.pem)
client_cert_base64=$(base64 -w0 client-cert.pem)
client_key=$(base64 -w0 client-key.pem)

replace_values "{UUID}" "$UUID"
replace_values "{NAME}" "$NAME"
replace_values "{IP}" "$IP"
replace_values "{CA}" "$ca_pem_base64"
replace_values "{CLIENT_CERT}" "$client_cert_base64"
replace_values "{CLIENT_KEY}" "$client_key"
