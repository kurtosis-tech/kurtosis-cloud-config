#!/bin/bash

set -euv

kurtosis analytics enable
kurtosis engine start
if [ $? -eq 0 ]; then
    echo "Engine started"
else
    echo "Failed to start the engine"
    exit 1
fi
