#!/bin/bash
# This script is to complie nmap
# Build by zt 20131102

# shellcheck disable=SC1073
if [ -z $1 ]; then
   curdir=$(cd $(dirname $0); pwd)
else
   curdir=$1
fi

cur_date=$(date +%Y%m%d)
ARTIFACT_REPO_DIR=${ARTIFACT_REPO_DIR:-/workdir/release/}
if [ ! -d ${ARTIFACT_REPO_DIR} ]; then
  mkdir -p ${ARTIFACT_REPO_DIR};
fi

yum -y install gcc gcc-c++ git wget make
yum -y install autoconf automake libtool autogen


RUN  yum install -y perl-CPAN && \
     PERL_MM_USE_DEFAULT=1 \
     perl -MCPAN -e 'CPAN::HandleConfig->edit("pushy_https", 0); CPAN::HandleConfig->edit("urllist", "unshift", "https://mirrors.aliyun.com/CPAN/"); mkmyconfig' || echo 'IGNORE CPAN CONFIG ERROR' && \
     cpan install IPC/Cmd.pm


cd $curdir
git clone --depth 1 https://github.com/Tongsuo-Project/Tongsuo
cd Tongsuo
./config --prefix=/opt/tongsuo enable-ntls && make -j && make install


cd $curdir
git clone --depth 1 https://github.com/Tongsuo-Project/curl.git
cd $curdir/curl
autoreconf -fi

# 如果configure失败，可能是curl依赖的库不存在，比如brotli，可以安装依赖库，或者关闭该选项，例如增加--without-brotli
LDFLAGS=-Wl,-rpath=/opt/tongsuo/lib64 ./configure \
  --prefix=/opt/curl \
  --enable-warnings \
  --enable-werror \
  --with-openssl=/opt/tongsuo  \
  --without-brotli

make -j
# 默认curl命令行会安装到/usr/local/bin，libcurl会安装到/usr/local/lib
make install


cd /opt && tar czf curl-latest-bin.gm.${cur_date}.tar.gz curl && \
mv /opt/curl-latest-bin.gm.${cur_date}.tar.gz ${ARTIFACT_REPO_DIR}
#LDFLAGS=-Wl,-rpath=/opt/openssl/lib64 ./configure \
#  --prefix=/opt/curl \
#  --enable-warnings \
#  --enable-werror \
#  --with-openssl=/opt/openssl  \
#  --without-brotli

# cd /opt && tar czf curl-bin.tar.gz curl