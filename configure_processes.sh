#!/bin/bash

if [ -z "$1" ]; then
  echo "Error: No path defined as first argument"
  exit 1
fi

cp "kurtosis-portal.service" "/lib/systemd/system/kurtosis-portal.service"
TARGET="ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock"
REPLACEMENT="ExecStart=/usr/bin/dockerd --tlsverify --tlscacert=$PATH/ca.pem --tlscert=$PATH/server-cert.pem --tlskey=$PATH/server-key.pem -H=0.0.0.0:9722 -H fd:// --containerd=/run/containerd/containerd.sock"
sed -i 's!'"$TARGET"'!'"$REPLACEMENT"'!g' /lib/systemd/system/docker.service

systemctl daemon-reload
systemctl restart docker
systemctl enable kurtosis-portal
systemctl start kurtosis-portal
