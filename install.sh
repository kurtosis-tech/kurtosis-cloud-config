#!/bin/bash
set -euv

. retry.sh

# Docker and Kurtosis CLI
mkdir -m 0755 -p /etc/apt/keyrings
retry 10 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
echo "deb [trusted=yes] https://apt.fury.io/kurtosis-tech/ /" | sudo tee /etc/apt/sources.list.d/kurtosis.list
retry 10 apt-get update
retry 10 apt-get install -y ca-certificates curl gnupg lsb-release jq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin kurtosis-cli
systemctl restart unattended-upgrades.service

# Kurtosis Portal
retry 10 wget https://github.com/kurtosis-tech/kurtosis-portal/releases/download/0.0.6/kurtosis-portal_0.0.6_linux_amd64.tar.gz
tar zxvf kurtosis-portal_0.0.6_linux_amd64.tar.gz
rm kurtosis-portal_0.0.6_linux_amd64.tar.gz
