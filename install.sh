#!/bin/bash

if [ -z "$1" ]; then
  echo "Error: No instance type defined as first argument"
  exit 1
fi

apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release jq
mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/nullapt-get update
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

if [ "$INSTANCE_TYPE" == "BASTION" ]; then
    wget https://github.com/kurtosis-tech/kurtosis-portal/releases/download/0.0.3/kurtosis-portal_0.0.3_linux_amd64.tar.gz
    tar zxvf kurtosis-portal_0.0.3_linux_amd64.tar.gz
    rm kurtosis-portal_0.0.3_linux_amd64.tar.gz
fi
