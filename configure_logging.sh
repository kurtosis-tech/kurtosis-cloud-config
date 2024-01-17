#!/bin/bash

set -v

echo "Configuring cloudwatch logs: Starting"
#cp aws-ec2-logging-config.json /opt/aws/amazon-cloudwatch-agent/bin/config.json
wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
dpkg -i -E ./amazon-cloudwatch-agent.deb
mkdir -p /usr/share/collectd/
touch /usr/share/collectd/types.db
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/root/kurtosis-cloud-config/aws-ec2-logging-config.json -s
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a status -m ec2
echo "Configuring cloudwatch logs: Completed"
