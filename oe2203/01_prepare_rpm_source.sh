#!/bin/bash

BCI_HOST='10.7.202.199'
#MIRROR_HOST='10.2.136.110'
MIRROR_HOST='mirrors.aliyun.com'

sed -i 's/repo.openeuler.org/${MIRROR_HOST}\/openeuler/g' /etc/yum.repos.d/openEuler.repo
cat /etc/yum.repos.d/openEuler.repo