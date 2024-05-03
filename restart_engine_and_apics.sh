#!/bin/bash
set -euv

. retry.sh

kurtosis engine restart --restart-api-containers
if [ $? -eq 0 ]; then
    echo "Kurtosis engine and APICs restarted"
else
    echo "Failed to restart the Kurtosis engine and APICs"
    exit 1
fi
