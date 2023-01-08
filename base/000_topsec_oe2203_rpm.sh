#!//bin/bash

BCI_HOST='10.7.202.199'
MIRROR_HOST='10.2.136.110'

sed -i 's/repo.openeuler.org/10.2.136.110\/openeuler/g' /etc/yum.repos.d/openEuler.repo
cat /etc/yum.repos.d/openEuler.repo

yum makecache 