#!/bin/bash

ARMBIAN_RELEASE="jammy"

git clone --depth 1 https://github.com/armbian/build.git && cd build && \
    ./compile.sh RELEASE=${ARMBIAN_RELEASE} \
    BOARD=odroidn2 \
    BRANCH=current \
    BUILD_DESKTOP=no \
    HOST=armbian \
    EXPERT=yes \
    BUILD_MINIMAL=no \
    KERNEL_ONLY=no \
    KERNEL_CONFIGURE=no \
    CLEAN_LEVEL=make,debs \
    COMPRESS_OUTPUTIMAGE="sha"


