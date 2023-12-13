#!/bin/bash

# Bash "strict mode"
set -euo pipefail

CONFIG_FILE="kurtosis-config.yml"

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

mkdir -p $HOME/.kube
KUBECONFIG="$HOME/.kube/config"
sudo cp /etc/rancher/k3s/k3s.yaml $KUBECONFIG
sudo chown $USER $KUBECONFIG && sudo chmod 600 $KUBECONFIG

kurtosis gateway &
kurtosis cluster set k3s