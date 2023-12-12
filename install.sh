#!/bin/bash

# Bash "strict mode"
set -euo pipefail

apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release jq

# Docker
mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/nullapt-get update
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# K3s
curl -sfL https://get.k3s.io | sh -

# Kurtosis Portal
PORTAL_VERSION="0.0.6"
PROTAL_PACKAGE_FILE="kurtosis-portal_"$PORTAL_VERSION"_linux_amd64.tar.gz" 
wget https://github.com/kurtosis-tech/kurtosis-portal/releases/download/$PORTAL_VERSION/$PROTAL_PACKAGE_FILE
tar zxvf $PROTAL_PACKAGE_FILE
rm $PROTAL_PACKAGE_FILE

# Kurtosis CLI
echo "deb [trusted=yes] https://apt.fury.io/kurtosis-tech/ /" | sudo tee /etc/apt/sources.list.d/kurtosis.list
apt-get install kurtosis-cli
