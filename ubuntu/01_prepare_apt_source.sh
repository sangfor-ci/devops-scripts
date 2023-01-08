#!/bin/bash


#MIRROR_HOST="mirrors.cn99.com"
MIRROR_HOST="10.2.136.110"

sed -i 's/security.ubuntu.com/${MIRROR_HOST}/g' /etc/apt/sources.list
sed -i 's/archive.ubuntu.com/${MIRROR_HOST}/g' /etc/apt/sources.list