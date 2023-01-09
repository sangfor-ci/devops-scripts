#!/bin/bash
# This script is to complie nmap
# Build by zt 20131102

# shellcheck disable=SC1073
DUMP_PATH=${DUMP_PATH:-/home/dev-tools}
cd ${DUMP_PATH}

GOLANG_VERSION=1.19.4
GOLANG_DOWNLOAD_LINK_PATH=/go_release_links

cat > $GOLANG_DOWNLOAD_LINK_PATH <<-EofData
https://golang.google.cn/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz
https://golang.google.cn/dl/go${GOLANG_VERSION}.windows-amd64.msi
https://golang.google.cn/dl/go${GOLANG_VERSION}.linux-arm64.tar.gz
EofData

for x in `cat $GOLANG_DOWNLOAD_LINK_PATH`; do
  wget -c -N $x --no-check-certificate;
  done