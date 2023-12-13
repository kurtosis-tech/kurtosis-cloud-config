#!/bin/bash

# Bash "strict mode"
set -euo pipefail

CONFIG_FILE="kurtosis-config.yml"
KURTOSIS_BIN=$(which kurtosis)

# Add k3s to kurtosis clusters
mkdir -p $HOME/.config/kurtosis
cat << EOF > "$HOME/.config/kurtosis/$CONFIG_FILE"
config-version: 2
should-send-metrics: true
kurtosis-clusters:
  docker:
    type: "docker"
  k3s:
    type: "kubernetes"
    config:
      kubernetes-cluster-name: "kloud-on-k3s"
      storage-class: "standard"
      enclave-size-in-megabytes: 10
EOF

# Init kube config file
mkdir -p $HOME/.kube
KUBECONFIG="$HOME/.kube/config"
sudo cp /etc/rancher/k3s/k3s.yaml $KUBECONFIG
sudo chown $USER $KUBECONFIG && sudo chmod 600 $KUBECONFIG

# Setup kurtosis gateway as system service
sudo bash -c 'cat > /lib/systemd/system/kurtosis-gateway.service' << EOF
[Unit]
Description=Kurtosis Gateway Daemon
Documentation=https://kurtosis.com
After=k3s.service
[Service]
Type=simple
User=$USER
ExecStart=$KURTOSIS_BIN gateway
ExecReload=/bin/kill -s HUP \$MAINPID
TimeoutStartSec=0
RestartSec=2
Restart=always
SyslogIdentifier=kurtosis-gateway
[Install]
WantedBy=multi-user.target
EOF

# Start kurtosis gateway service
sudo systemctl daemon-reload
sudo systemctl enable kurtosis-gateway
sudo systemctl restart kurtosis-gateway

# Setup kurtosis to use k3s cluster
kurtosis cluster set k3s