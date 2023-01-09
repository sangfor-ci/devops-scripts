#!/bin/bash
# This script is to complie nmap
# Build by zt 20131102

# shellcheck disable=SC1073
DUMP_PATH=${DUMP_PATH:-/home/dev-tools}
cd ${DUMP_PATH}

for ver in py38_4.12.0 py38_4.9.2; do
  for os in Linux Windows; do
    for arch in x86_64 aarch64; do
      wget -c -N https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-${ver}-${os}-${arch}.sh \
      --no-check-certificate;
      done
    done
  done
