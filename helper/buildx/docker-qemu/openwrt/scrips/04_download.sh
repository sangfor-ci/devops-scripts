

make download -j8 || make download -j1 V=s
rm -rf $(find ./dl/ -size -1024c)
df -h
