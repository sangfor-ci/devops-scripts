#!/bin/bash
yum -y install bzip2 xz zip tar


docker exec -it t3 bash <<- EOF

yum -y install network* pam-devel net-tools
yum -y clean all && \
    rm -rf /var/cache/yum /var/lib/yum/yumdb/* /usr/lib/udev/hwdb.d/* && \
    rm -rf /var/cache/dnf /etc/udev/hwdb.bin /root/.pki

EOF

# 生成空镜像文件
dd if=/dev/zero of=rootfs.img bs=1M count=1024
mkfs.ext4 rootfs.img
mkdir rootfs
mount -t ext4 rootfs.img rootfs

docker cp t3:/ rootfs/
umount rootfs.img
docker cp rootfs.img qemu:/home/


qemu-system-aarch64 -machine virt       \
                    -cpu cortex-a53     \
                    -nographic          \
                    -smp 1              \
                    -m 2048             \
                    -netdev user,id=net0,hostfwd=tcp::10022-:2222,hostfwd=tcp::5900-:5900 \
                    -device vmxnet3,netdev=net0,id=net0,mac=52:54:00:09:49:17 \
                    -kernel ./linux/arch/arm64/boot/Image       \
                    -hda ./rootfs.img \
                    -append "init=/linuxrc root=/dev/vda console=ttyAMA0 loglevel=8"
