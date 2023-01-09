#!/bin/bash

# Install aliyun repo
echo ">>> Install aliyun repo"
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo >/dev/null 2>&1

# Install desired packages
echo ">>> Install desired packages"
yum install -y -q vim wget git net-tools epel-release >/dev/null 2>&1

# Update the system
# echo ">>> Update the system"
#yum update -y >/dev/null 2>&1

# Config ssh connection
echo ">>> Config ssh connection"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd
echo "root:string123." | sudo chpasswd

# Disable SELinux and firewalld
echo ">>> Disable SELinux and firewalld"
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
systemctl disable --now firewalld >/dev/null 2>&1

# Install Docker-ce
echo ">>> Install Docker-ce"
yum install -y yum-utils device-mapper-persistent-data lvm2 ;
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo ;
yum makecache fast ;
#yum -y install docker-ce-17.12.0.ce-1.el7.centos
yum -y install docker-ce ;
systemctl enable docker;
systemctl restart docker;

## TODO 2021/3/30
#yum -y install gcc gcc-c++ make automake autoconf libtool zlib-devel \
#  openssl openssl-devel libffi-devel
#yum install openssl-devel bzip2-devel expat-devel gdbm-devel readline-devel \
#  sqlite-devel gcc gcc-c++
#
#cd /opt/ && tar zxf Python-3.8.6.tgz && cd Python-3.8.6 && \
#  ./configure --prefix=/usr/local/python386 && make && make install
#
#/usr/local/python386/bin/python3.8 -m pip install --upgrade pip \
#  --index-url  http://mirrors.aliyun.com/pypi/simple/ \
#  --trusted-host mirrors.aliyun.com
#
#/usr/local/python386/bin/pip3 install -r docker-compose supervisor \
#  --index-url  http://mirrors.aliyun.com/pypi/simple/  \
#  --trusted-host mirrors.aliyun.com
#
#ln -sf /usr/local/python386/bin/python3 /usr/bin/python3
#ln -sf /usr/local/python386/bin/pip3 /usr/bin/pip3
#ln -sf /usr/local/python386/bin/supervisord /usr/bin/supervisord
#ln -sf /usr/local/python386/bin/docker-compose /usr/bin/docker-compose
