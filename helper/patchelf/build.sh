#!/bin/bash

yum -y install git
yum -y install autoconf automake make autogen gcc gcc-c++ libtool
yum -y install centos-release-scl
yum -y install devtoolset-10

export CC=/opt/rh/devtoolset-10/root/bin/gcc

git clone --depth 1 https://github.com/NixOS/patchelf
cd patchelf
bash ./bootstrap.sh
./configure --prefix=/opt/patchelf
make
make install


tar czf patchelf-bin.tar.gz /opt/patchelf

mv patchelf-bin.tar.gz /workdir/release

