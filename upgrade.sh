#!/bin/bash
set -euv

. retry.sh

# Upgrade Kurtosis
retry 7 apt-get update
retry 7 apt-get install --only-upgrade kurtosis-cli
