#!//bin/bash

BCI_HOST='10.7.202.199'
MIRROR_HOST='10.2.136.110'

rm -rf /etc/yum.repos.d/*

if [[ ! `cat /etc/hosts` =~ 'mirror.topsec.com.cn' ]]; then
   echo '10.2.136.110  mirror.topsec.com.cn' >> /etc/hosts
fi


sed -i 's/archive.ubuntu.com/mirror.topsec.com.cn/g' /etc/apt/sources.list
sed -i 's/security.ubuntu.com/mirror.topsec.com.cn/g' /etc/apt/sources.list

apt update -y
#apt full-upgrade -y
