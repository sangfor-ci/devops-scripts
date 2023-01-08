#!/bin/bash

# 使用 lftp 进行上传文件到远程; 制品库


function ftp_upload_dir(){
  cd $1
  for x in $(ls .); do
    lftp -u ceshi,Talent123 ftp://10.7.217.164 << EOF
    cd XXXXXXXXXXX/17-常用三方包/dev-tools/
    put $x
    bye
EOF
  done
}

function ftp_get(){

  lftp -c 'pget -n 10 ftp://Talent123:ceshi@10.7.217.164/E%3A/DATAS/%E5%A4%A7%E6%95%B0%E6%8D%AE%E4%BA%A7%E5%93%81%E6%8A%80%E6%9C%AF%E4%B8%AD%E5%BF%83/17-%E5%B8%B8%E7%94%A8%E4%B8%89%E6%96%B9%E5%8C%85/dev-tools/Miniconda3-py38_4.12.0-Linux-x86_64.sh; bye'

}


