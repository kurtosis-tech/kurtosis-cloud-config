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

if [ -z "$6" ]; then
  echo "Error: No aws env defined as sixth argument"
  missing_var=true
fi

if [ -z "$7" ]; then
  echo "Error: No work dir defined as seventh argument"
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
AWS_ENV="$6"
WORK_DIR="$7"
# Set remote backend endpoint host to this host for now since the remote backend host and the bastion are the same host.
REMOTE_BACKEND_ENDPOINT="tcp://$IP:9722"

sh generate_certificates.sh  "$HOST" "$IP" "$PASSWORD"
sh install.sh
sh configure_processes.sh "$WORK_DIR"
sh generate_cloud_connection.sh "$UUID" "$NAME" "$IP"
sh generate_remote_backend_config.sh "$REMOTE_BACKEND_ENDPOINT"
sh generate_contexts_config.sh "$UUID" "$NAME" "$IP" "$AWS_ENV"
sh start_engine.sh
