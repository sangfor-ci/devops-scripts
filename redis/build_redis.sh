#!/bin/bash
#!/bin/bash
# This script is to complie nmap
# Build by zt 20131102
# shellcheck disable=SC1073

if [ -z $1 ]; then
   # shellcheck disable=SC2046
   # shellcheck disable=SC2164
   curdir=$(cd $(dirname $0); pwd)
else
   # shellcheck disable=SC2034
   curdir=$1
fi

BIN_NAME=redis
#REDIS_VERSION=${REDIS_VERSION:-6.0.9}
REDIS_VERSION=${REDIS_VERSION:-'stable'}
REDIS_RELEASE_URL="http://download.redis.io/redis-stable.tar.gz"
REDIS_RELEASE_URL=${REDIS_RELEASE_URL:-http://10.2.136.110/redis-release/redis-${REDIS_VERSION}.tar.gz}


export BIN_NAME=nmap
export SRC_RELEASE_VERSION=${REDIS_VERSION:-7.93}
export SRC_RELEASE_URL=${REDIS_RELEASE_URL}
export CHECK_ARGS=${CHECK_ARGS:-"--version"}

bash "${curdir}"/../common/generic_build.sh

