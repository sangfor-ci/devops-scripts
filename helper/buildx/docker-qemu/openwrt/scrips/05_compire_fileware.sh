
make -j$(nproc) || make -j1 V=s
echo "======================="
echo "Space usage:"
echo "======================="
df -h
echo "======================="
du -h ./ --max-depth=1
du -h /mnt/openwrt/ --max-depth=1 || true