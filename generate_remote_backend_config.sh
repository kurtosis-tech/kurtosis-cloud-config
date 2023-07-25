#!/bin/bash

missing_var=false
if [ -z "$1" ]; then
  echo "Error: No endpoint defined as first argument"
  missing_var=true
fi

if [ "$missing_var" = true ]; then
  exit 1
fi

ENDPOINT="$1"
CONFIG_FILE="remote_backend_config.json"

replace_values () {
  TARGET=$1
  REPLACEMENT=$2
  sed -i 's!'"$TARGET"'!'"$REPLACEMENT"'!g' "$CONFIG_FILE"
}

ca_pem_base64=$(base64 -w0 ca.pem)
client_cert_base64=$(base64 -w0 client-cert.pem)
client_key=$(base64 -w0 client-key.pem)

replace_values "{ENDPOINT}" "$ENDPOINT"
replace_values "{CA}" "$ca_pem_base64"
replace_values "{CLIENT_CERT}" "$client_cert_base64"
replace_values "{CLIENT_KEY}" "$client_key"

mkdir -p /root/engine_config
cp remote_backend_config.json /root/engine_config
