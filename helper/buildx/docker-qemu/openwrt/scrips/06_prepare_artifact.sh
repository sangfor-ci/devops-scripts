#!/bin/bash

mkdir -p ./artifact/firmware
mkdir -p ./artifact/package
mkdir -p ./artifact/buildinfo
rm -rf $(find ./bin/targets/ -type d -name "packages")
cp -rf $(find ./bin/targets/ -type f) ./artifact/firmware/
cp -rf $(find ./bin/packages/ -type f -name "*.ipk") ./artifact/package/
cp -rf $(find ./bin/targets/ -type f -name "*.buildinfo" -o -name "*.manifest") ./artifact/buildinfo/