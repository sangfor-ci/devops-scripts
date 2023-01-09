#!/bin/bash

SNV_LIST=(
  "https://192.168.1.221/svn/TSGZ/trunk/TSGZ_DOC/topsa/develop/component/parse"
  "https://192.168.1.221/svn/TSGZ/trunk/TSGZ2019/Share/data_content/日志资料/日志数据资料/态势项目解析/"
  "https://192.168.1.221/svn/TSGZ/trunk/TSGZ2019/Share/data_content/日志资料/日志数据资料/工控/标准解析/"
  "https://192.168.1.221/svn/TSGZ/trunk/TSGZ2019/Share/data_content/日志资料/日志数据资料/工控/项目解析/"
)
MIRCO_VERSION=10
BUILD_ID=${BUILD_ID:-0717}
BUILD_VERSION=v2.0.${MIRCO_VERSION}.$(date +%Y%m%d).${BUILD_ID}

# ===================== Abbreviations =====================
Echo_INFOR(){
    echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;32m[INFOR]\033[0m - \033[1;32m$1\033[0m"
}

Echo_ALERT(){
    echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;33m[ALERT]\033[0m - \033[1;33m$1\033[0m"
}
# ===================== Abbreviations =====================

Echo_INFOR "准备 checkout svn 仓库 ${SNV_LIST[0]} "
svn co ${SNV_LIST[0]} --username=han_chuanli --password=string123. topsa_logparser
ARTIFACT_NAME=topsa_logparser-${BUILD_VERSION}.tar.xz

tar cJf  ${ARTIFACT_NAME} ./topsa_logparser/conf/
Echo_INFOR "打包成功。 ${ARTIFACT_NAME}"
echo $(sha256sum ${ARTIFACT_NAME}) >> ${ARTIFACT_NAME}.sha256
ls -alh ${ARTIFACT_NAME}*


