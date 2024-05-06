#!/bin/bash
set -euv

# Upgrade Kurtosis
apt-get update
apt-get install --only-upgrade kurtosis-cli
