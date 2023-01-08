#!/bin/bash

# ===================== Abbreviations =====================
Echo_INFOR(){
    echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;32m[INFOR]\033[0m - \033[1;32m$1\033[0m"
}

Echo_ALERT(){
    echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;33m[ALERT]\033[0m - \033[1;33m$1\033[0m"
}

DOWNLOAD_DIR="https://10.11.6.26/nexus/repository/filestore-v2/tech/dev-tools/"



NC='\033[0m'
RED='\033[0;31m'
echo -e "${RED}[!] ONLY for Centos7/openEuler/Redhat${NC}"

function usage() {
cat << EndOfHelp
    Usage: $0 <func_name> <args> | tee $0.log
    Commands - are case insensitive:

    Tips:

EndOfHelp
}

function init_host_node(){
  Echo_INFOR "Init Hose Node Infos"

}

function issues(){
cat << EndOfHelp
### 参考文档:
    * https://10.7.202.199/docs/
### 常见错误和解决方案
    * 错误:
        * ssl 连接异常


EndOfHelp
}


# Doesn't work ${$1,,}
COMMAND=$(echo "$1"|tr "[:upper:]" "[:lower:]")

case $COMMAND in
    '-h')
        usage
        exit 0;;
    'issues')
        issues
        exit 0;;
esac


#check if start with root
#if [ "$EUID" -ne 0 ]; then
#   echo 'This script must be run as root'
#   exit 1
#fi

OS="$(uname -s)"
MAINTAINER="$(whoami)"_"$(hostname)"
#ARCH="$(dpkg --print-architecture)"
ARCH="$(arch)"

function install_python3(){
  wget -c -N ${DOWNLOAD_DIR}Miniconda3-py38_4.12.0-Linux-x86_64.sh --no-check-certificate;
  bash Miniconda3-py38_4.12.0-Linux-x86_64.sh -b -p /usr/local/miniconda3
  /usr/local/miniconda3/bin/python -V && \
  Echo_INFOR "Successfully installed $1 (python3)" && return 0 || \
   { Echo_ERROR "$1 module installation failed"; return 1; }
}

function install_openjdk8(){
  wget -c -N ${DOWNLOAD_DIR}zulu8.66.0.15-ca-jdk8.0.352-linux_x64.tar.gz --no-check-certificate;
  tar xf zulu8.66.0.15-ca-jdk8.0.352-linux_x64.tar.gz
  mv zulu8.66.0.15-ca-jdk8.0.352-linux_x64 /usr/local/openjdk8.0.352
  Echo_ALERT "Installed JDK8 java path -> [/usr/local/openjdk8.0.352/bin/java]"

}

function install_openjdk11(){
  wget -c -N ${DOWNLOAD_DIR}zulu11.60.19-ca-jdk11.0.17-linux_x64.tar.gz --no-check-certificate;
  tar xf zulu11.60.19-ca-jdk11.0.17-linux_x64.tar.gz
  mv zulu11.60.19-ca-jdk11.0.17-linux_x64 /usr/local/openjdk11.0.17
  Echo_ALERT "Installed JDK8 java path -> [/usr/local/openjdk11.0.17/bin/java]"

}

function install_openjdk17(){
  JDK_FILENAME="zulu17.38.21-ca-jdk17.0.5-linux_x64"
  http://10.11.6.26/nexus/repository/filestore-v2/tech/dev-tools/
  wget -c -N ${DOWNLOAD_DIR}${JDK_FILENAME}.tar.gz --no-check-certificate;
  tar xf {JDK_FILENAME}.tar.gz
  mv {JDK_FILENAME} /usr/local/openjdk17
  Echo_ALERT "Installed JDK8 java path -> [/usr/local/openjdk17/bin/java]"

}

function install_java_pkt_tool(){
   # "gradle-7.5.1-bin.zip"
   TOOL_LIST="apache-maven-3.8.6 apache-ant-1.10.12"

  for x in $TOOL_LIST; do
    if [ -d /usr/local/$x ]; then
      /usr/bin/rm -ef /usr/local/$x
      Echo_INFOR "删除了旧的 $x"
    fi
    mkdir temp-0717 && cd temp-0717
    wget -c -N ${DOWNLOAD_DIR}$x-bin.tar.gz --no-check-certificate;
    tar xf $x-bin.tar.gz
    ls -alh
    #mv `find . -type d -maxdepth 1 | grep -v -E '.$'` /usr/local/
    /usr/bin/mv $x /usr/local/
    Echo_ALERT "Installed $x path -> [/usr/local/$x]"
    rm -rf temp-0717
  done
}

case "$COMMAND" in
'issues')
    issues;;
'all')
    install_openjdk8
    ;;
'tool')
  install_java_pkt_tool
  ;;
'openjdk8')
    install_openjdk8;;
'openjdk11')
    install_openjdk11;;
'openjdk17')
    install_openjdk17;;
'nodejs14')
    install_kvm_linux;;
'nodejs18')
    install_haxm_mac;;
'codeql')
    install_codeql;;
'mirror')
    inital_mirror;;
'python3')
    install_python3
    ;;
*)
    usage;;
esac

