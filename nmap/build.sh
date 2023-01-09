#!/bin/bash
# shellcheck disable=SC2034
# shellcheck disable=SC2034
# shellcheck disable=SC2046
# shellcheck disable=SC2164

if [ -z $1 ]; then
   curdir=$(cd $(dirname $0); pwd)
else
   curdir=$1
fi

yum install wget lftp \
    gcc gcc-c++ \
    openssl openssl-devel \
    lua lua-devel \
    libffi libffi-devel \
    zlib zlib-devel \
    pcre pcre-devel xz bzip2 tar -y

NMAP_VERSION=${NMAP_VERSION:-7.93}
#NMAP_RELEASE_URL=https://nmap.org/dist/nmap-${NMAP_VERSION}.tgz
NMAP_RELEASE_URL=https://nmap.org/dist/nmap-${NMAP_VERSION}.tar.bz2


export BIN_NAME=nmap
export SRC_RELEASE_VERSION=${NMAP_VERSION:-7.93}
export SRC_RELEASE_URL=${NMAP_RELEASE_URL}
export CHECK_ARGS=${CHECK_ARGS:-"--version"}

bash "${curdir}"/../common/generic_build.sh
