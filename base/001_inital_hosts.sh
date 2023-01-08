#!/bin/bash

MIRROR_HOST_IP="10.2.136.110"


if [[ ! `cat /etc/hosts` =~ 'mirror.topsec.com.cn' ]]; then
   echo '${MIRROR_HOST_IP}  mirror.topsec.com.cn' >> /etc/hosts 
fi

if [[ ! `cat /etc/hosts` =~ 'mirrors.aliyun.com' ]]; then
   echo '${MIRROR_HOST_IP}  mirrors.aliyun.com' >> /etc/hosts 
fi

# https://repo.huaweicloud.com/
if [[ ! `cat /etc/hosts` =~ 'repo.huaweicloud.com' ]]; then
   echo '${MIRROR_HOST_IP}  repo.huaweicloud.com' >> /etc/hosts 
fi

