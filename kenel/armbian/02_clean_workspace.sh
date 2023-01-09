#!/bin/bash

cd build/
    sudo rm -rf $(ls . | grep -v "^output$" | xargs) 2>/dev/null
  cd output/images/
    img_name="$(ls *.img | head -n 1)"
    img_version="$(echo ${img_name} | grep -oE '[2-9][2-9]\.[0-9]{1,2}\.[0-9]{1,2}' | head -n 1)"
    img_kernel="$(echo ${img_name} | grep -oE '[5-9]\.[0-9]{1,2}\.[0-9]{1,3}' | head -n 1)"
    sudo mv -f ${img_name} Armbian_${img_version}-trunk_${img_kernel}.img
    sudo pigz -9f *.img
    df -hT ${PWD}

