#!/bin/bash
#!/bin/bash
# This script is to complie nmap
# Build by zt 20131102

# shellcheck disable=SC1073
if [ -z $1 ]; then
   curdir=$(cd $(dirname $0); pwd)
else
   curdir=$1
fi


PGSQL_VER=13.9
PGSQL_SOURCE=https://mirror.tuna.tsinghua.edu.cn/postgresql/source/v${PGSQL_VER}/postgresql-${PGSQL_VER}.tar.gz
# https://ftp.postgresql.org/pub/source/v${PGSQL_VER}/postgresql-${PGSQL_VER}.tar.gz

cd $curdir
yum -y install wget gcc gcc-c++
yum -y install openssl-devel libxml2-devel libxslt-devel python-devel cmake gcc-c++ zlib-devel bzip2 readline-devel
wget -c -N  ${PGSQL_SOURCE} --no-check-certificate
tar xf postgresql-${PGSQL_VER}.tar.gz
cd postgresql-${PGSQL_VER}
./configure --prefix=/usr/local/postgresql
make -j8 world
make install-world
make -C contrib install;

cd /usr/local
tar czf postgresql-v${PGSQL_VER}-bin.tar.gz /usr/local/postgresql

#useradd postgres
#chown -R postgres:postgres /usr/local/postgresql
