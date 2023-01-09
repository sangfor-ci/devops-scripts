# armbian和openwrt


```bash

qemu-system-aarch64 -machine vexpress-a9       \
                    -cpu cortex-a9     \
                    -nographic          \
                    -smp 1              \
                    -m 2048             \
                    -kernel "/home/superman/drivers/arch/arm64/boot/Image" \
                    -hda ./armbian-rootfs.img \
                    --append "root=/dev/vda"


qemu-system-aarch64 \
  --machine vexpress-a9 \
  --cpu cortex-a9 \
  --m 1024 \
  --drive "format=raw,file=armbian-rootfs.img" \
  --net nic --net user,hostfwd=tcp::5122-:22 \
  --kernel "/home/superman/drivers/arch/arm64/boot/Image" \
  --append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/vda rootwait panic=1" \
  --no-reboot \
  --display none \
  --serial mon:stdio
```


## 参考
- https://github.com/ophub/amlogic-s9xxx-armbian
