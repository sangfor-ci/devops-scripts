
rm -f ./.config*
touch ./.config
#
# 在 cat >> .config <<EOF 到 EOF 之间粘贴你的编译配置, 需注意缩进关系
# 例如:
cat >> .config <<EOF
CONFIG_TARGET_IMAGES_GZIP=y
CONFIG_KERNEL_BUILD_USER="OpenWrt-CI"
CONFIG_KERNEL_BUILD_DOMAIN="Azure"
EOF
#
# ===============================================================
#
sed -i 's/^[ \t]*//g' ./.config
make defconfig