#!/bin/bash
# This script is to complie nmap
# Build by zt 20131102

# shellcheck disable=SC1073
DUMP_PATH=${DUMP_PATH:-/home/dev-tools}
cd ${DUMP_PATH}

#CODEQL_VERSION=${CODEQL_VERSION:-2.11.5}
#wget -c -N --no-check-certificate \
#  https://github.com/github/codeql-cli-binaries/releases/download/v${CODEQL_VERSION}/codeql-linux64.zip


CODEQL_BUNDLE_VERSION=20221202
wget -c -N --no-check-certificate \
  https://github.com/github/codeql-action/releases/download/codeql-bundle-${CODEQL_BUNDLE_VERSION}/codeql-bundle-linux64.tar.gz