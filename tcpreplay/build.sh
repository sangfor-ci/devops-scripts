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


export BIN_NAME=tcpreplay
export SRC_RELEASE_VERSION=${TCPREPLAY_VERSION:-4.4.3}
export SRC_RELEASE_URL=https://github.com/appneta/tcpreplay/releases/download/v${CUR_BIN_VERSION}/tcpreplay-v${CUR_BIN_VERSION}.tar.gz
export CHECK_ARGS=${CHECK_ARGS:-"--version"}

bash "${curdir}"/../common/generic_build.sh

