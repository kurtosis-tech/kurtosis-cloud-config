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
  echo "Error: No aws access key id defined as sixth argument"
  missing_var=true
fi

if [ -z "$7" ]; then
  echo "Error: No aws secret access key defined as seventh argument"
  missing_var=true
fi

if [ -z "$8" ]; then
  echo "Error: No aws bucket region defined as eight argument"
  missing_var=true
fi

if [ -z "$9" ]; then
  echo "Error: No aws bucket name defined as ninth argument"
  missing_var=true
fi

if [ -z "${10}" ]; then
  echo "Error: No aws bucket user folder defined as tenth argument"
  missing_var=true
fi

if [ -z "${11}" ]; then
  echo "Error: No work dir defined as eleventh argument"
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
AWS_ACCESS_KEY_ID="$6"
AWS_SECRET_ACCESS_KEY="$7"
AWS_BUCKET_REGION="$8"
AWS_BUCKET_NAME="$9"
AWS_BUCKET_USER_FOLDER="${10}"
WORK_DIR="${11}"
# Set remote backend endpoint host to this host for now since the remote backend host and the bastion are the same host.
REMOTE_BACKEND_ENDPOINT="tcp://$IP:9722"

sh configure_logging.sh
sh generate_certificates.sh  "$HOST" "$IP" "$PASSWORD"
sh install.sh
sh configure_processes.sh "$WORK_DIR"
sh generate_cloud_connection.sh "$UUID" "$NAME" "$IP"
sh generate_remote_backend_config.sh "$REMOTE_BACKEND_ENDPOINT"
sh generate_contexts_config.sh "$UUID" "$NAME" "$IP" "$AWS_ACCESS_KEY_ID" "$AWS_SECRET_ACCESS_KEY" "$AWS_BUCKET_REGION" "$AWS_BUCKET_NAME" "$AWS_BUCKET_USER_FOLDER"
sh start_engine.sh
