#!/bin/bash

yum -y install gcc gcc-c++ make zlib-devel
yum -y install python3 python3-pip python3-devel
pip3 install wheel
pip3 install pyinstaller

# https://github.com/ffffffff0x/f8x/blob/main/f8x
# https://www.cnblogs.com/zengming/p/16128179.html
