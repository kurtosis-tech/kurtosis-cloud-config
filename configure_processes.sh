#!/bin/bash

if [ -z "$1" ]; then
  echo "Error: No path defined as first argument"
  exit 1
fi

WORK_DIR="$1"

replace_values () {
  TARGET="$1"
  REPLACEMENT="$2"
  CONFIG_FILE="$3"
  sed -i 's!'"$TARGET"'!'"$REPLACEMENT"'!g' "$CONFIG_FILE"
}

TARGET="{WORK_DIR}"
REPLACEMENT="$WORK_DIR"
replace_values "$TARGET" "$REPLACEMENT" "kurtosis-portal.service"
cp "kurtosis-portal.service" "/lib/systemd/system/kurtosis-portal.service"

TARGET="ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock"
REPLACEMENT="ExecStart=/usr/bin/dockerd --tlsverify --tlscacert=$WORK_DIR/ca.pem --tlscert=$WORK_DIR/server-cert.pem --tlskey=$WORK_DIR/server-key.pem -H=0.0.0.0:9722 -H fd:// --containerd=/run/containerd/containerd.sock"
replace_values "$TARGET" "$REPLACEMENT" "/lib/systemd/system/docker.service"

systemctl daemon-reload
systemctl restart docker
systemctl enable kurtosis-portal
systemctl restart kurtosis-portal
