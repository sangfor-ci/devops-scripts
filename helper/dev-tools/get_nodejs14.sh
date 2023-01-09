#!/bin/bash
# This script is to complie nmap
# Build by zt 20131102

# shellcheck disable=SC1073
DUMP_PATH=${DUMP_PATH:-/home/dev-tools}
cd ${DUMP_PATH}

NODEJS_VERSION=${NODEJS_VERSION:-14.21.1}

wget -c -N https://mirror.tuna.tsinghua.edu.cn/nodejs-release/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-x64.tar.gz \
  --no-check-certificate

