#!/bin/bash

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

if [ -z "$4" ]; then
  echo "Error: No UUID defined as fourth argument"
  missing_var=true
fi

if [ -z "$5" ]; then
  echo "Error: No name defined as fifth argument"
  missing_var=true
fi

if [ "$missing_var" = true ]; then
  exit 1
fi

HOST="$1"
IP="$2"
PASSWORD="$3"
UUID="$4"
NAME="$5"


sh certificates/generate_certificates.sh  "$HOST" "$IP" "$PASSWORD"
sh software-install/install.sh
sh configure/configure.sh
sh cloud-connection/generate_cloud_connection.sh "$UUID" "$NAME" "$IP"

