#!/bin/bash
# 20221212 初始化脚本，记录打包的任务。

curdir=$(
  cd $(dirname $0)
  pwd
)

BRANCH_NAME="v2.x"
MAJOR_VERSION="2.1"
MIRCO_VERSION=10
PROGRAM_NAME="pangu"
BUILD_COUNT=${BUILD_COUNT:-0711}
UNIQ_DIR_NAME=日志解析文件v4版
XX_GL_TOKEN="px-Tr9uD5jbEGZM2MLCU"

# ===================== Abbreviations =====================
Echo_INFOR(){
    echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;32m[INFOR]\033[0m - \033[1;32m$1\033[0m"
}

Echo_ALERT(){
    echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;33m[ALERT]\033[0m - \033[1;33m$1\033[0m"
}
# ===================== Abbreviations =====================


Echo_INFOR "开始克隆项目 ${BRANCH_NAME} https:192.168.66.211/KnowledgeBase/LogParser.git"
git config --global http.sslVerify false
git clone --depth 1 -b ${BRANCH_NAME}  https://oauth2:${XX_GL_TOKEN}@192.168.66.211/KnowledgeBase/LogParser.git ${PROGRAM_NAME}_logparser

Echo_INFOR "开始清理没有用的文件"
cp -r $curdir/${PROGRAM_NAME}_logparser $curdir/${PROGRAM_NAME}_logparser_bak
cd $curdir/${PROGRAM_NAME}_logparser_bak
#for x in `find . -type f`; do
#  if ! echo \'$x\' | grep -E '\.zip$'; then
#    # 主要是修复关于$x中有特殊字符会换行，所以务必转义
#    # Echo_ALERT "准备删除和程序使用无关的文件 --> \'$x\'"
#    /usr/bin/rm -rf \'$x\' || echo \'$x\'
#  fi
#done
python3 ../008_delete_files_tool.py -d $curdir/${PROGRAM_NAME}_logparser_bak

Echo_INFOR "开始进行工作"
cd $curdir/${PROGRAM_NAME}_logparser_bak/${UNIQ_DIR_NAME}

function get_cur_version(){
  SLUG=$1
  CUR_VERSION=v${MAJOR_VERSION}.${MIRCO_VERSION}-${SLUG}.$(date +%Y%m%d).${BUILD_COUNT}
  echo $CUR_VERSION
}

Echo_ALERT "打包标准解析"
tar cJf ${PROGRAM_NAME}-$(get_cur_version S).tar.xz ./标准解析文件/

Echo_ALERT "打包项目解析"
tar cJf ${PROGRAM_NAME}-$(get_cur_version P).tar.xz ./项目解析文件/

mkdir -p /tmp/release
cd /tmp/release && \
  mv $curdir/${PROGRAM_NAME}_logparser_bak/${UNIQ_DIR_NAME}/${PROGRAM_NAME}-$(get_cur_version S).tar.xz .
  mv $curdir/${PROGRAM_NAME}_logparser_bak/${UNIQ_DIR_NAME}/${PROGRAM_NAME}-$(get_cur_version P).tar.xz .
Echo_INFOR "完成打包--> \n $(ls -alh /tmp/release)"

Echo_INFOR "完成打包--> \n $(ls -alh $curdir/release)"
