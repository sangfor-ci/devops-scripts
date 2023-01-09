#!/bin/bash
# This script is to complie some common tools
# Build by zt 20211102
# shellcheck disable=SC1073
# shellcheck disable=SC2046
# shellcheck disable=SC2164

if [ -z $1 ]; then
   curdir=$(cd $(dirname $0); pwd)
else
   # shellcheck disable=SC2034
   curdir=$1
fi

# ===================== Abbreviations =====================
Echo_INFOR(){
    echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;32m[INFOR]\033[0m - \033[1;32m$1\033[0m"
}

Echo_ALERT(){
    echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;33m[ALERT]\033[0m - \033[1;33m$1\033[0m"
}

function issues(){
cat << EndOfHelp
### 注意事项:
  * 有多个环境变量
  　　* BIN_NAME　构建后的组件名称，例如
  　　* CUR_BIN_VERSION　构建后的组件名称，例如
  　　* REMOTE_TAR_URL　构建后的组件名称，例如
  　　* ARTIFACT_REPO_DIR　构建的存储路径
  * 例如：
     BIN_NAME=nmap CUR_BIN_VERSION=7.93 REMOTE_TAR_URL=
　　
EndOfHelp
}

# shellcheck disable=SC2164
cd ${curdir}

BIN_NAME=${BIN_NAME}
SRC_RELEASE_VERSION=${SRC_RELEASE_VERSION}
SRC_RELEASE_URL=${SRC_RELEASE_URL}
CHECK_ARGS=${CHECK_ARGS:-"--version"}
CONFIG_ARGS=""
GEN_CONFIG_BLOCKSHELL=${GEN_CONFIG_BLOCKSHELL:-"echo 'Not Need Gen config.'"}

#BIN_NAME=tcpreplay
#CUR_BIN_VERSION=4.4.3
#REMOTE_TAR_URL=https://github.com/appneta/tcpreplay/releases/download/v${CUR_BIN_VERSION}/tcpreplay-v${CUR_BIN_VERSION}.tar.gz


############################# TODO: Step1 Install rpm deps
yum -y install cpp binutils glibc glibc-kernheaders glibc-common glibc-devel gcc make wget
yum -y install libpcap libpcap-devel  automake autogen libtool \
  bsion flex gcc gcc-c++ wget git

############################# TODO: Step2 Download Src release tgz
wget -c -N  "${SRC_RELEASE_URL}" --no-check-certificate > /dev/null 2>&1
if [ $? == 0 ]; then
    # shellcheck disable=SC2016
    Echo_INFOR "[*] ${SRC_RELEASE_URL} Download OK"
else
    Echo_ALERT "[x] Download ${SRC_RELEASE_URL} Failed."
    exit 1;
fi


############################# TODO: Step3 Dump local and build
# shellcheck disable=SC2164
tar xf $(find . -maxdepth 1 -name \*tar\*\.\* -type f | grep "${BIN_NAME}" | head -n 1)
#cd $(find . -maxdepth 1 -name "${BIN_NAME}" -type d | grep "${SRC_RELEASE_VERSION}" | head -n 1)
cd $(find . -maxdepth 1 -type d | grep "${BIN_NAME}" | grep "${SRC_RELEASE_VERSION}" | head -n 1)
/bin/bash -c "${GEN_CONFIG_BLOCKSHELL}"
./configure --prefix=/usr/local/"${BIN_NAME}" "${CONFIG_ARGS}"
make -j$(nproc)
make install

############################# TODO: Step4 Check build OK
/usr/local/"${BIN_NAME}"/bin/"${BIN_NAME}" "${CHECK_ARGS}" > /dev/null 2>&1
# shellcheck disable=SC2181
if [ $? == 0 ]; then
    # shellcheck disable=SC2016
    Echo_INFOR '[*] ${BIN_NAME} Build OK'
else
    Echo_ALERT "[x] Build Faild."
    exit 1;
fi

############################# TODO: Step5 make bin release
cur_date=$(date +%Y%m%d)

# shellcheck disable=SC2164
cd /usr/local
tar czf "${BIN_NAME}"-"${SRC_RELEASE_VERSION}"."${cur_date}"-bin.$(/usr/bin/arch).tar.gz ${BIN_NAME}

ARTIFACT_REPO_DIR=${ARTIFACT_REPO_DIR:-/workdir/release/}
# shellcheck disable=SC2086
if [ ! -d ${ARTIFACT_REPO_DIR} ]; then
  mkdir -p "${ARTIFACT_REPO_DIR}";
fi

############################# TODO: Step6 push artifact path
mv "${BIN_NAME}"-"${SRC_RELEASE_VERSION}"."${cur_date}"-bin.$(/usr/bin/arch).tar.gz "${ARTIFACT_REPO_DIR}"
