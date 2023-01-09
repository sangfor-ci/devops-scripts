# qemu 启动 openwrt

wget -c -N https://downloads.openwrt.org/releases/22.03.2/targets/armvirt/64/openwrt-22.03.2-armvirt-64-rootfs-ext4.img.gz
wget -c -N https://downloads.openwrt.org/releases/22.03.2/targets/armvirt/64/openwrt-22.03.2-armvirt-64-Image

```bash

qemu-system-aarch64 -machine virt \
  -cpu cortex-a53 \
   -nographic \
   -smp 1 \
    -m 2048  \
   --net nic --net user,hostfwd=tcp::5022-:22 \
   --net nic --net user \
   -kernel ./openwrt-22.03.2-armvirt-64-Image \
    -hda ./openwrt-22.03.2-armvirt-64-rootfs-ext4.img  \
    -append "root=/dev/vda console=ttyAMA0 loglevel=8"
    
```

## 构建自己的 image
- https://github.com/sangfor-ci/lede
```bash

docker pull 


```

## 参考
- https://www.cnblogs.com/wipan/p/9269505.html
- https://github.com/IvanSolis1989/OpenWrt-DIY
- https://mlapp.cn/376.html
- https://github.com/SuLingGG/OpenWrt-Docker
