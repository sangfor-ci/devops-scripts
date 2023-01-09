#!/bin/bash
# This script is to complie nmap
# Build by zt 20131102

# shellcheck disable=SC1073
DUMP_PATH=${DUMP_PATH:-/home/dev-tools}
cd ${DUMP_PATH}

# https://adoptium.net/zh-CN/download/
#

# https://www.azul.com/downloads/?version=java-11-lts&os=linux&architecture=x86-64-bit&package=jdk

JDK_DOWNLOAD_LINK_PATH=/jdk_links

cat > $JDK_DOWNLOAD_LINK_PATH <<-EofData
https://cdn.azul.com/zulu/bin/zulu11.60.19-ca-jdk11.0.17-linux_x64.tar.gz
https://cdn.azul.com/zulu/bin/zulu8.66.0.15-ca-jdk8.0.352-linux_x64.tar.gz
https://cdn.azul.com/zulu/bin/zulu17.38.21-ca-jdk17.0.5-linux_x64.tar.gz

https://cdn.azul.com/zulu-embedded/bin/zulu11.60.19-ca-jdk11.0.17-linux_aarch64.tar.gz
https://cdn.azul.com/zulu-embedded/bin/zulu8.66.0.15-ca-jdk8.0.352-linux_aarch64.tar.gz
https://cdn.azul.com/zulu/bin/zulu17.38.21-ca-jdk17.0.5-linux_aarch64.tar.gz

EofData

for x in `cat $JDK_DOWNLOAD_LINK_PATH`; do
  wget -c -N $x --no-check-certificate;
  done