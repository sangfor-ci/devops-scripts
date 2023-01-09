#!/bin/bash
if [ -z $1 ]; then
   curdir=$(cd $(dirname $0); pwd)
else
   curdir=$1
fi

MS_VERSION=${MS_VERSION:-1.3.2}
MASSCAN_RELEASE_URL=https://github.com/robertdavidgraham/masscan/archive/refs/tags/${MS_VERSION}.tar.gz
# #####################################################
yum install wget lftp \
    gcc gcc-c++ \
    openssl openssl-devel \
    lua lua-devel \
    libffi libffi-devel \
    zlib zlib-devel \
    pcre pcre-devel xz bzip2 tar -y
# #####################################################

export BIN_NAME=masscan
export SRC_RELEASE_VERSION=${MS_VERSION:-7.93}
export SRC_RELEASE_URL=${MASSCAN_RELEASE_URL}
export CHECK_ARGS=${CHECK_ARGS:-"--version"}

bash "${curdir}"/../common/generic_build.sh
