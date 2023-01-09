#!/bin/bash

SYSBENCH_RELESE_PATH=""

yum -y install autoconf automake autogen libtool make gcc gcc-c++ wget curl


wget -c -N $SYSBENCH_RELESE_PATH && \
