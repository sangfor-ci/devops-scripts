#!/bin/bash
#
# 编译内核的脚本
#
#

if [ -f './menuconfig' ]; then
  mv ./menuconfig .config;
fi