#!/bin/bash

if [ -z "$1" ]; then
  echo "Error: No path defined as first argument"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Error: No remote host defined as second argument"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Error: No instance type defined as third argument"
  exit 1
fi

WORK_DIR="$1"
REMOTE_HOST="$2"
INSTANCE_TYPE="$3"

if [ "$INSTANCE_TYPE" != "bastion" ] && [ "$INSTANCE_TYPE" != "backend" ]; then
  echo "The instance type should be set to bastion or backend"
  exit 1
fi

replace_values () {
  TARGET="$1"
  REPLACEMENT="$2"
  CONFIG_FILE="$3"
  sed -i 's!'"$TARGET"'!'"$REPLACEMENT"'!g' "$CONFIG_FILE"
}

if [ "$INSTANCE_TYPE" = "bastion" ]; then
  TARGET="{WORK_DIR}"
  REPLACEMENT="$WORK_DIR"
  replace_values "$TARGET" "$REPLACEMENT" "kurtosis-portal.service"
  TARGET="{REMOTE_HOST}"
  REPLACEMENT="$REMOTE_HOST"
  replace_values "$TARGET" "$REPLACEMENT" "kurtosis-portal.service"
  cp "kurtosis-portal.service" "/lib/systemd/system/kurtosis-portal.service"
fi

TARGET="ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock"
if [ "$INSTANCE_TYPE" = "bastion" ]; then
  REPLACEMENT="ExecStart=/usr/bin/dockerd --tlsverify --tlscacert=$WORK_DIR/ca.pem --tlscert=$WORK_DIR/server-cert.pem --tlskey=$WORK_DIR/server-key.pem -H=0.0.0.0:9722 -H fd:// --containerd=/run/containerd/containerd.sock"
elif [ "$INSTANCE_TYPE" = "backend" ]; then
  REPLACEMENT="ExecStart=/usr/bin/dockerd -H=0.0.0.0:9722 -H fd:// --containerd=/run/containerd/containerd.sock"
fi
replace_values "$TARGET" "$REPLACEMENT" "/lib/systemd/system/docker.service"

systemctl daemon-reload
systemctl restart docker
if [ "$INSTANCE_TYPE" = "bastion" ]; then
  systemctl enable kurtosis-portal
  systemctl start kurtosis-portal
fi
