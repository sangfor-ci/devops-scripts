# qemu-arm 
- https://www.cnblogs.com/mrlayfolk/p/15734284.html



## 根据需要进行选型-交叉编译的话 docker 足够
```bash
docker run -itd --name=arm  \
  ccr.ccs.tencentyun.com/topsec/centos7-base:arm64v8

```

## QEMU 强行模拟arm其他使用途径的设备（android/iphone）
> 这里推荐使用 `qemu`
- [docker image]
    - `ccr.ccs.tencentyun.com/topsec/ub2204-qemu`
    
```bash

qemu-system-arm -M vexpress-a9 \
    -m 1024M \
    -kernel arch/arm/boot/zImage \
    -append "rdinit=/linuxrc console=ttyAMA0 loglevel=8" \
    -dtb arch/arm/boot/dts/vexpress-v2p-ca9.dtb \
    -nographic


```

### step0 准备相关工具
```bash

yum -y install bzip2 xz zip tar

# 准备交叉编译工具包 
https://developer.arm.com/downloads/-/gnu-a
wget -c -N https://developer.arm.com/-/media/Files/downloads/gnu-a/10.3-2021.07/binrel/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu.tar.xz && 、
    tar xf gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu.tar.xz -C /opt/ 
 
export PATH=/opt/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin/:$PATH
export LD_LIBRARY_PATH=/opt/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/lib64:/opt/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/aarch64-none-linux-gnu/lib64/:$LD_LIBRARY_PATH

apt-get install git fakeroot build-essential \
  ncurses-dev xz-utils libssl-dev bc flex \
  libelf-dev bison git fakeroot build-essential \
  ncurses-dev xz-utils libssl-dev bc flex libelf-dev bison \
  -y 


```

### step1 编译一个arm的内核
```bash
# git clone -b v6.1 --depth 1 https://mirrors.tuna.tsinghua.edu.cn/git/linux.git
# https://mirror.tuna.tsinghua.edu.cn/help/linux.git/
# https://cdn.kernel.org/
wget -c -N https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.1.1.tar.xz
tar xf linux-6.1.1.tar.xz
cd linux
make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- defconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- Image -j8


```


### step2 创建文件系统
- 这里一般来说是使用`busybox`, 为了简省，我们使用 `docker image`
- https://busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/

```bash
yum install gcc gcc-c++ glibc glibc-devel  pcre pcre-devel  \
  openssl openssl-desystemd-devel zlib-devel \
   glibc-static ncurses-devel wget pam-*

# 生成空镜像文件
dd if=/dev/zero of=rootfs.img bs=1M count=1024
# 设定镜像文件系统格式
mkfs.ext4 rootfs.img
# 挂在镜像到一个空文件夹
mkdir rootfs
sudo mount -t ext4 rootfs.img rootfs
# 把该拷贝的文件拷贝到镜像文件夹fs
# _install 是busybox打包出来的，但是我们使用 docker 文件系统就是 / 
# docker cp t1:/ rootfs/
cp -r _install/* rootfs/.
# 建立其他必须的文件夹
mkdir proc dev etc home mnt
# 搞定了，卸载镜像
sudo umount rootfs

```

### step3 使用 qemu 直接启动了 
```bash

qemu-system-aarch64 -machine virt       \
                    -cpu cortex-a53     \
                    -nographic          \
                    -smp 1              \
                    -m 2048             \
                    --net nic --net user,hostfwd=tcp::5122-:22 \
                    -kernel ./vmlinuz-5.15.84-ophub      \
                    -initrd  ./openwrt-armvirt-64-default-rootfs.tar.gz \
                    --no-reboot \
                    --display none \
                    --serial mon:stdio \
                    --append "init=/init rw earlyprintk loglevel=8 console=ttyAMA0,115200  panic=1" 
       
qemu-system-aarch64 -machine virt   \
  -cpu cortex-a53                  \
   -nographic                  \
    -smp 1                         \
   -m 2048                             \
  --net nic --net user,hostfwd=tcp::5122-:22          \
-kernel ./vmlinuz-5.15.84-ophub                 \
      -hda ./rootfs.img              \
           --no-reboot                     --display none                 \
     --serial mon:stdio                    \
          --append "init=/init rw earlyprintk loglevel=8 console=ttyAMA0,115200 root=/dev/ram  panic=1"

       
```

## 参考
- https://blog.csdn.net/zjy900507/article/details/88660270
- http://t.zoukankan.com/shenhaocn-p-1743704.html
- https://github.com/sickcodes/Docker-OSX/blob/master/Dockerfile
- https://github.com/lukechilds/dockerpi/blob/master/entrypoint.sh
- https://blog.51cto.com/u_14322729/2412355

### openwrt arm 
- https://downloads.openwrt.org/releases/22.03.2/targets/armvirt/64/
