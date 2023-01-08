#!/bin/bash
# shellcheck disable=SC1073
if [ -z $1 ]; then
   curdir=$(cd $(dirname $0); pwd)
else
   curdir=$1
fi

#GCC_VERSION=8.5.0
#MPC_VERSION=1.3.1
#GMP_VERSION=6.2.0
#MPFR_VERSION=4.1.0

yum -y install bzip2 unzip tar

GMP_FILE=https://ftp.gnu.org/gnu/gmp/gmp-6.2.0.tar.xz
MPFR_FILE=https://ftp.gnu.org/gnu/mpfr/mpfr-4.1.0.tar.gz
GCC_FILE=https://ftp.gnu.org/gnu/gcc/gcc-8.5.0/gcc-8.5.0.tar.gz
MPC_FILE=https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz

wget -c -N $GMP_FILE --no-check-certificate
wget -c -N $MPC_FILE --no-check-certificate
wget -c -N $MPFR_FILE --no-check-certificate
wget -c -N $GCC_FILE --no-check-certificate

tar jxf gmp-6.2.0.tar.xz
tar xf gcc-8.5.0.tar.gz
tar xf mpc-1.3.1.tar.gz
tar xf mpfr-4.1.0.tar.gz

#tar -xvzf gmp-6.2.0.tar.xz
cd $curdir/gmp-6.2.0/
mkdir temp
cd temp/
../configure --prefix=/usr/local/gmp-6.2.0
make
make install


curdir=/root/gcc-deps
#tar -xvzf mpfr-4.1.0.tar.gz
cd $curdir/mpfr-4.1.0/
mkdir temp
cd temp/
../configure --prefix=/usr/local/mpfr-4.1.0 --with-gmp=/usr/local/gmp-6.2.0
make
make install


#tar -xvzf mpc-1.3.1.tar.gz
cd $curdir/mpc-1.3.1/
mkdir temp
cd temp/
../configure --prefix=/usr/local/mpc-1.3.1 --with-gmp=/usr/local/gmp-6.2.0 --with-mpfr=/usr/local/mpfr-4.1.0
make
make install

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/mpc-1.3.1/lib:/usr/local/gmp-6.2.0/lib:/usr/local/mpfr-4.1.0/lib


#tar -jxvf gcc-8.5.0.tar.gz
cd $curdir/gcc-8.5.0
mkdir output
cd output/
../configure \
  --prefix=/usr/local/gcc-8.5.0 \
  --disable-multilib \
  --enable-languages=c,c++ \
  --with-gmp=/usr/local/gmp-6.2.0 \
  --with-mpfr=/usr/local/mpfr-4.1.0 \
  --with-mpc=/usr/local/mpc-1.3.1

make -j4
sudo make install

