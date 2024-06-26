#!/bin/bash
set -euv

. retry.sh

missing_var=false
if [ -z "$1" ]; then
  echo "Error: No name defined as first argument"
  missing_var=true
fi

if [ "$missing_var" = true ]; then
  exit 1
fi

NAME="$1"
CONFIG_FILE="aws-cloudwatch-agent-config.json"


replace_values () {
  TARGET=$1
  REPLACEMENT=$2
  sed -i 's!'"$TARGET"'!'"$REPLACEMENT"'!g' "$CONFIG_FILE"
}

echo "Configuring cloudwatch agent: Starting"
replace_values "{KURTOSIS_NAME}" "$NAME"
retry 7 wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
retry 7 dpkg -i -E ./amazon-cloudwatch-agent.deb
mkdir -p /usr/share/collectd/
touch /usr/share/collectd/types.db
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/root/kurtosis-cloud-config/$CONFIG_FILE -s
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a status -m ec2
echo "Configuring cloudwatch agent: Completed"
