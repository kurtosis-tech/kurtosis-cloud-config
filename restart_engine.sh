#!/bin/bash

set -euv

kurtosis engine restart
if [ $? -eq 0 ]; then
    echo "Engine restarted"
else
    echo "Failed to restart the engine"
    exit 1
fi
