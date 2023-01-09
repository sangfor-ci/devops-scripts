## qemu 模拟启动

```bash


qemu-system-aarch64 \
  --machine vexpress-a15 \
  --cpu cortex-a15 \
  --m 2048 \
  --net nic --net user,hostfwd=tcp::5022-:22 \
  -hda ./Armbian_23.02.0_amlogic_s905x_bullseye_5.15.84_server_2022.12.21.img \
  -vnc :2
  
qemu-system-aarch64 \
  --machine virt \
  --m 1024 \
  --drive "format=raw,file=./Armbian_23.02.0_amlogic_s905x_bullseye_5.15.84_server_2022.12.21.img" \
  --net nic --net user,hostfwd=tcp::5032-:22 \
  --dtb "./meson-gxl-s905x-p212.dtb" \
  --kernel "./vmlinuz-5.15.84-flippy-80+o" \
  --append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 rootwait panic=1" \
  --no-reboot \
  --display none \
  --serial mon:stdio
  #   --cpu arm1176 \
```