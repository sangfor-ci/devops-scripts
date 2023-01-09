#!/bin/bash

if [ ! -d "build" ]; then
  mkdir build
else
  rm -rf build/*
fi

if [ ! -d "build" ]; then
  echo "making build dir failed!"
  exit 1
fi

cd build

wget https://developer.arm.com/-/media/Files/downloads/gnu-a/10.3-2021.07/binrel/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu.tar.xz
tar xvf gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu.tar.xz


export PATH=`pwd`/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin:${PATH}

wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.74.tar.xz
tar xf linux-5.15.74.tar.xz
cd linux-5.15.74
make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- defconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- -j8
cd -


yum -y install ncurses-devel

dd if=/dev/zero of=rootfs.img bs=1M count=32
mkfs.ext4 rootfs.img
mkdir fs
sudo mount -t ext4 rootfs.img fs

wget https://busybox.net/downloads/busybox-1.35.0.tar.bz2
tar xf busybox-1.35.0.tar.bz2
cd busybox-1.35.0
make CROSS_COMPILE=aarch64-none-linux-gnu- defconfig
make CROSS_COMPILE=aarch64-none-linux-gnu- CONFIG_STATIC=y -j8 install

cd ../fs
sudo chmod -R 777 .
cp -r ../busybox-1.35.0/_install/* .
mkdir proc dev etc home mnt

cd ..
sudo umount fs

qemu-system-aarch64 -machine virt       \
                    -cpu cortex-a53     \
                    -nographic          \
                    -smp 1              \
                    -m 2048             \
                    -kernel linux-5.15.74/arch/arm64/boot/Image \
                    -hda ./rootfs.img \
                    --append "root=/dev/vda"