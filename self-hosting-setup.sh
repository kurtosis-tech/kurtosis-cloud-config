#!/bin/bash
set -euv

domain=$1
username=$2
password=$3

function retry {
  local retries=$1
  shift

  local count=0
  until "$@"; do
    exit=$?
    wait=$((2 ** $count))
    count=$(($count + 1))
    if [ $count -lt $retries ]; then
      echo "Retry $count/$retries exited $exit, retrying in $wait seconds..."
      sleep $wait
    else
      echo "Retry $count/$retries exited $exit, no more retries left."
      return $exit
    fi
  done
  return 0
}

retries=7

# Install Kurtosis CLI
mkdir -m 0755 -p /etc/apt/keyrings
retry $retries curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
echo "deb [trusted=yes] https://apt.fury.io/kurtosis-tech/ /" | sudo tee /etc/apt/sources.list.d/kurtosis.list

# Install Docker and Nginx
retry $retries apt-get update
retry $retries apt-get install -y ca-certificates curl gnupg lsb-release jq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin kurtosis-cli nginx apache2-utils
systemctl restart unattended-upgrades.service

# Start Kurtosis engine with domain set
kurtosis analytics enable
kurtosis engine start --domain $domain
if [ $? -eq 0 ]; then
    echo "Engine started"
else
    echo "Failed to start the engine"
    exit 1
fi

# Configure Nginx
mkdir /etc/apache2
htpasswd -b -c /etc/apache2/.htpasswd $username $password
retry $retries curl -fsSL https://raw.githubusercontent.com/kurtosis-tech/kurtosis-cloud-config/main/self-hosting-nginx.conf -o /etc/nginx/nginx.conf
systemctl reload nginx
