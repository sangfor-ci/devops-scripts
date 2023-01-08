#!/bin/bash

# Install topsec repo
echo ">>> Install topsec repo"
#curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo >/dev/null 2>&1


# Install desired packages
echo ">>> Install desired packages"
yum install -y -q vim wget git net-tools epel-release >/dev/null 2>&1

# Update the system
# echo ">>> Update the system"
#yum update -y >/dev/null 2>&1

# Config ssh connection
#echo ">>> Config ssh connection"
#sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
#systemctl reload sshd
#echo "root:string123." | sudo chpasswd

# Disable SELinux and firewalld
echo ">>> Disable SELinux and firewalld"
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
systemctl disable --now firewalld >/dev/null 2>&1

## Install Docker-ce
#echo ">>> Install Docker-ce"
#yum install -y yum-utils device-mapper-persistent-data lvm2 ;
#yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo ;
#yum makecache fast ;
##yum -y install docker-ce-17.12.0.ce-1.el7.centos
#yum -y install docker-ce ;
#systemctl enable docker;
#systemctl restart docker;
