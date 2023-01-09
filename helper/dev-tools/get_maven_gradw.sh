#!/bin/bash
# This script is to complie nmap
# Build by zt 20131102

# shellcheck disable=SC1073
DUMP_PATH=${DUMP_PATH:-/home/dev-tools}
cd ${DUMP_PATH}

MAVEN3_VERSION=3.8.6
GRADLE_VERSION=7.5.1
ANT_VERSION=1.10.12
#GRADLE_VERSION=7.6

wget -c -N https://dlcdn.apache.org/maven/maven-3/${MAVEN3_VERSION}/binaries/apache-maven-${MAVEN3_VERSION}-bin.tar.gz \
  --no-check-certificate

# https://gradle.org/install/

wget -c -N https://downloads.gradle-dn.com/distributions/gradle-${GRADLE_VERSION}-bin.zip \
  --no-check-certificate

# https://blog.csdn.net/baidu_39512534/article/details/128031457
wget -c -N https://dlcdn.apache.org//ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
  --no-check-certificate