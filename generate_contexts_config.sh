#!/bin/bash

missing_var=false
if [ -z "$1" ]; then
  echo "Error: No UUID defined as first argument"
  missing_var=true
fi

if [ -z "$2" ]; then
  echo "Error: No IP defined as third argument"
  missing_var=true
fi

if [ "$missing_var" = true ]; then
  exit 1
fi

UUID="$1"
IP="$2"
CONFIG_FILE="contexts-config.json"

replace_values () {
  TARGET=$1
  REPLACEMENT=$2
  sed -i 's!'"$TARGET"'!'"$REPLACEMENT"'!g' "$CONFIG_FILE"
}

ca_pem_base64=$(base64 -w0 ca.pem)
client_cert_base64=$(base64 -w0 client-cert.pem)
client_key=$(base64 -w0 client-key.pem)

replace_values "{UUID}" "$UUID"
replace_values "{IP}" "$IP"
replace_values "{CA}" "$ca_pem_base64"
replace_values "{CLIENT_CERT}" "$client_cert_base64"
replace_values "{CLIENT_KEY}" "$client_key"

cp $CONFIG_FILE $HOME/.config/kurtosis/$CONFIG_FILE
