#!/bin/bash

MYSQL8_VERSION=${MYSQL8_VERSION:-8.0.31}
GLIBC_VERSION=${GLIBC_VERSION:-2.17}
#TEST=-test
TEST=
ARTIFACT_REPO_DIR=${ARTIFACT_REPO_DIR:-/workir/release/}

yum -y install wget xz bzip tar curl

wget -c -N https://cdn.mysql.com//Downloads/MySQL-8.0/mysql${TEST}-${MYSQL8_VERSION}-linux-glibc${GLIBC_VERSION}-x86_64-minimal.tar.xz \
  --no-check-certificate

#tar xf mysql${TEST}-${MYSQL8_VERSION}-linux-glibc${GLIBC_VERSION}-x86_64-minimal.tar.xz

if [ ! -d ${ARTIFACT_REPO_DIR} ]; then
  mkdir -p ${ARTIFACT_REPO_DIR};
done

mv mysql${TEST}-${MYSQL8_VERSION}-linux-glibc${GLIBC_VERSION}-x86_64-minimal.tar.xz ${ARTIFACT_REPO_DIR};

