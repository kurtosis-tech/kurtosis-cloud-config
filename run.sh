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
  echo "Error: No work dir defined as sixth argument"
  missing_var=true
fi

if [ -z "$7" ]; then
  echo "Error: No remote IP defined as seventh argument"
  missing_var=true
fi

if [ -z "$7" ]; then
  echo "Error: No instance type defined as eight argument"
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
WORK_DIR="$6"
REMOTE_IP="$7"
INSTANCE_TYPE="$8"

if [ "$INSTANCE_TYPE" != "bastion" ] && [ "$INSTANCE_TYPE" != "backend" ]; then
  echo "The instance type should be set to bastion or backend"
  exit 1
fi

REMOTE_BACKEND_ENDPOINT="tcp://$REMOTE_IP:9722"

if [ "$INSTANCE_TYPE" == "bastion" ]; then
  sh generate_certificates.sh  "$HOST" "$IP" "$PASSWORD"
  sh install.sh "$INSTANCE_TYPE"
  sh configure_processes.sh "$WORK_DIR" "$REMOTE_IP" "$INSTANCE_TYPE"
  sh generate_cloud_connection.sh "$UUID" "$NAME" "$IP"
  sh generate_remote_backend_config.sh "$REMOTE_BACKEND_ENDPOINT"
elif [ "$INSTANCE_TYPE" == "backend" ]; then
  sh install.sh "$INSTANCE_TYPE"
  sh configure_processes.sh "$WORK_DIR" "$REMOTE_IP" "$INSTANCE_TYPE"
fi
