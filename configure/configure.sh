#!/bin/bash
#set -euo pipefail # Bash "strict mode"

cp "kurtosis-portal.service" "/lib/systemd/system/kurtosis-portal.service"
TARGET="ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock"
REPLACEMENT="ExecStart=/usr/bin/dockerd --tlsverify --tlscacert=/root/ca.pem --tlscert=/root/server-cert.pem --tlskey=/root/server-key.pem -H=0.0.0.0:9722 -H fd:// --containerd=/run/containerd/containerd.sock"
sed -i 's!'"$TARGET"'!'"$REPLACEMENT"'!g' test.txt

systemctl daemon-reload
systemctl restart docker
systemctl enable kurtosis-portal
systemctl start kurtosis-portal
