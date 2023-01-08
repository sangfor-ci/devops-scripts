#!/bin/bash
if [[ "$(uname -s)" != "Linux" ]];then
    echo "$(uname -s)"
    if [[ "$(uname -s)" == "Darwin" ]];then
      echo "this is Linux script, please use macOS script!"
    else
      echo "this is Linux script, please use Windows script!"
    fi
    exit -1
fi


# 获取命令行参数
PROJECT_TOKEN="$1"
IN_DOCKER="${2:-false}"  # TODO: 暂时没用，预留日后实现
POOL="${3:-default}"

# 获取变量参数
WS_SERVER="${CODING_SERVER:-wss://cci-websocket.coding.net/qci/ws}"
CI_HOME="${CI_HOME:-/root/codingci}"
# CI_HOME=$HOME/codingci
JENKINS_HOME="${CI_HOME}/tools"
DEBUG="${DEBUG:-0}"
PYPI_DOMAIN="$(echo "${PYPI_HOST}" | awk -F/ '{if($3) print$3; else print 0}')"

echo "PYPI_HOST: ${PYPI_HOST}"
echo "PYPI_EXTRA_INDEX_URL: ${PYPI_EXTRA_INDEX_URL}"
echo "PACKAGE_URL: ${PACKAGE_URL}"
echo "JENKINS_VERSION: ${JENKINS_VERSION}"
echo "JENKINS_HOME_VERSION: ${JENKINS_HOME_VERSION}"
echo "CODING_SERVER: ${WS_SERVER}"
echo "PYPI_DOMAIN: ${PYPI_DOMAIN}"
echo "LOG_REPORT: ${LOG_REPORT}"


# 临时工作空间
TMP_DIR=''

# PyPI 源配置
PYPI_INDEX=${PYPI_HOST}
PYPI_PACKAGE_INDEX="${PYPI_HOST}/qci-worker/"
EXTRA_INDEX_URL="${PYPI_EXTRA_INDEX_URL}"

# 下载链接
DOWNLOAD_URL_GET_PIP="${PACKAGE_URL}/public-files/coding-ci/get-pip.py"
DOWNLOAD_URL_JENKINS_WAR="${PACKAGE_URL}/public-files/coding-ci/jenkins.war?version=${JENKINS_VERSION}"
DOWNLOAD_URL_JENKINS_HOME="${PACKAGE_URL}/public-files/coding-ci/jenkinsHome.zip?version=${JENKINS_HOME_VERSION}"
DOWNLOAD_URL_GO="${PACKAGE_URL}/public-files/coding-ci/go1.17.8.linux-amd64.tar.gz?version=latest"

# 需安装的基础组件
BASE_PKG_APT='curl unzip python3-distutils-extra'
BASE_PKG_YUM='curl unzip which gcc python3-devel'
BASE_PKG_APK='curl unzip gcc python3-dev musl-dev linux-headers'

# Python3 的可能位置
PYTHON3_POSSIBLE_PATHS=(
  /usr/bin/python3
  /usr/local/bin/python3
  /usr/bin/python3.9
  /usr/local/bin/python3.9
  /usr/bin/python3.8
  /usr/local/bin/python3.8
  /usr/bin/python3.7
  /usr/local/bin/python3.7
  /usr/bin/python3.6
  /usr/local/bin/python3.6
)

# 要求的最低版本
REQUIRED_MIN_VERSION_PYTHON3='3.6'
REQUIRED_MIN_VERSION_GIT='2.8'
REQUIRED_MIN_VERSION_GO='1.4'


# 打日志方法
# 使用方法：
# logger [debug|info|warning|error] {message}
# 默认打印 info 及以上级别的日志，除非 DEBUG=1
function logger() {
  local level
  local message

  if [[ "$#" -eq '2' ]]; then
    level="$1"
    message="$2"
  elif [[ "$#" -ge '1' ]]; then
    message="$1"
  else
    message=''
  fi

  if [[ "$level" = 'debug' || "$level" = 'DEBUG' ]]; then
    if [[ "$DEBUG" -eq '1' ]]; then echo "DEBUG  : ${message}"; fi
  elif [[ "$level" = 'info' || "$level" = 'INFO' ]]; then
    echo "INFO   : ${message}"
  elif [[ "$level" = 'warning' || $level = 'WARNING' ]]; then
    echo -e "\033[33mWARNING: ${message} \033[0m"
  elif [[ "$level" = 'error' || "$level" = 'ERROR' ]]; then
    echo -e "\033[31mERROR  : ${message} \033[0m"
  else
    echo "${message}"
  fi
}

# 版本比较方法
# 使用方法：
# version_compare {version1} {gt|ge|lt|le|eq} {version2}
# 返回 0 表示 True ， 1 表示 False
# 版本号用 a.b.c 的格式表示， a.b 表示 a.b.0 , a 表示 a.0.0
function version_compare() {
  local version1 operator version2
  local version1_major version1_minor version1_patch
  local version1_major version1_minor version1_patch
  local compare_ret

  # 读取入参
  version1="$1"
  operator="$2"
  version2="$3"

  # 切分版本号
  version1_major="$(echo "$version1" | awk -F '.' '{if($1) print $1; else print 0}')"
  version1_minor="$(echo "$version1" | awk -F '.' '{if($2) print $2; else print 0}')"
  version1_patch="$(echo "$version1" | awk -F '.' '{if($3) print $3; else print 0}')"
  version2_major="$(echo "$version2" | awk -F '.' '{if($1) print $1; else print 0}')"
  version2_minor="$(echo "$version2" | awk -F '.' '{if($2) print $2; else print 0}')"
  version2_patch="$(echo "$version2" | awk -F '.' '{if($3) print $3; else print 0}')"
  logger debug "version1: (${version1_major}, ${version1_minor}, ${version1_patch}) version2: (${version2_major}, ${version2_minor}, ${version2_patch})"

  # 比较大小
  compare_ret='eq'
  if [[ "$compare_ret" == 'eq' && "$version1_major" -gt "$version2_major" ]]; then compare_ret='gt'; fi
  if [[ "$compare_ret" == 'eq' && "$version1_major" -lt "$version2_major" ]]; then compare_ret='lt'; fi
  if [[ "$compare_ret" == 'eq' && "$version1_minor" -gt "$version2_minor" ]]; then compare_ret='gt'; fi
  if [[ "$compare_ret" == 'eq' && "$version1_minor" -lt "$version2_minor" ]]; then compare_ret='lt'; fi
  if [[ "$compare_ret" == 'eq' && "$version1_patch" -gt "$version2_patch" ]]; then compare_ret='gt'; fi
  if [[ "$compare_ret" == 'eq' && "$version1_patch" -lt "$version2_patch" ]]; then compare_ret='lt'; fi
  logger debug "compare result: ${version1} ${compare_ret} ${version2}"

  # 判断操作符是否包含实际比较结果
  if [[ "$compare_ret" == 'eq' && ("$operator" == 'eq' || "$operator" == 'ge' || "$operator" == 'le' ) ]]; then
    return 0
  elif [[ "$compare_ret" == 'lt' && ("$operator" == 'lt' || "$operator" == 'le' ) ]]; then
    return 0
  elif [[ "$compare_ret" == 'gt' && ("$operator" == 'gt' || "$operator" == 'ge' ) ]]; then
    return 0
  else
    return 1
  fi
}


# 查找是否有可用的 Python3 版本
# 返回 0 表示能找到符合版本要求的 python3 ，并且已经安装 pip
# 返回 1 表示没有找到符合版本的 python3
# 返回 2 表示能找到符合版本要求的 python3 ，但是 pip 不可用
python3_executable=''
function find_python3() {
  local python3_possible_paths

  # 如果 which python3 可用，优先用该值
  local which_python3 which_python3_ret
  which_python3="$(which python3)"; which_python3_ret="$?"
  if [[ "$which_python3_ret" -eq 0 ]]; then
    python3_possible_paths=("$which_python3" "${PYTHON3_POSSIBLE_PATHS[*]}")
  else
    python3_possible_paths=("${PYTHON3_POSSIBLE_PATHS[*]}")
  fi

  # 逐个查看版本，直到找到一个合适的
  local ret python3_version_output python3_version_ret python3_possible_path python3_version
  ret='1'
  for python3_possible_path in ${python3_possible_paths[*]}; do
    python3_version_output="$(${python3_possible_path} --version 2> /dev/null)"; python3_version_ret="$?"
    if [[ "$python3_version_ret" -eq 0 ]]; then
      logger debug "${python3_possible_path}: ${python3_version_output}"
      python3_version="$(echo "${python3_version_output}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')"
      if version_compare "$python3_version" 'ge' "$REQUIRED_MIN_VERSION_PYTHON3"; then
        ret='0'
        break
      fi

    else
      logger debug "command '${python3_possible_path}' not found"
    fi
  done

  if [[ "$ret" -eq 1 ]]; then
    python3_executable=''
    logger debug 'no available python3'
    return 1
  fi

  python3_executable="$python3_possible_path"
  logger debug "available python3: ${python3_possible_path} (version: ${python3_version})"

  # 检查 pip 是否可用
  local pip_version_output pip_version_ret
  pip_version_output="$(${python3_executable} -m pip --version 2> /dev/null)"; pip_version_ret="$?"
  if [[ "$pip_version_ret" -eq '0' ]]; then
    logger debug "pip version: ${pip_version_output}"
    return 0
  else
    logger debug 'pip not available'
    return 2
  fi
}
# 检查 java

# 检查获取的是否是可执行的 java
function java_is_true() {
    local java_conduct_file is_conduct
    java_conduct_file="$1"
    is_conduct=$("$java_conduct_file" -version 2>&1 | grep 'version')
    if [[ "$is_conduct" ]]; then
        return 1
    fi

}

# 建立 java 软链接
function make_java_soft() {
    local _java_conduct_file soft_make ret
    _java_conduct_file="$1"
    soft_make=$(ln -snf "$_java_conduct_file" /usr/bin/java 2> /dev/null); ret="$?"
    if [[ "$ret" -eq 0 ]];then
        logger info "make 'ln -snf {$_java_conduct_file} /usr/bin/java' success"
    else
        logger error "make 'ln -snf {$_java_conduct_file} /usr/bin/java'  fail"
    fi
}

# 检查 java
function check_java() {
    local _java java_file_check _make_soft _java_conduct_file 
    echo "Checking Java JDK version"
    if type -p java;then
        # echo Found Java executable in PATH
        _java=java
    elif [[ -n $JAVA_HOME ]] && [[ -x "$JAVA_HOME/bin/java" ]];then
        # echo Found Java executable in JAVA_HOME
        _java="$JAVA_HOME/bin/java"
    fi

    if [[ ! "$_java" ]];then
        java_file_check=$(whereis java 2>&1 | awk -F ' ' '{print $1,$2,$3,$4,$5}');
        for _java_file in ${java_file_check[*]}
        do
            java_is_true "$_java_file";
            java_file_check_ret="$?"
            if [[ "$java_file_check_ret" ]];then
                _make_soft=1
                _java_conduct_file="$_java_file"
                _java="$_java_file"
                break
            fi
        done
        if [[ "$_make_soft" -ne 1 ]]; then
            logger error "no JAVA found, please install Java 8 or Java 11!"
            exit -1
        fi
    fi

    if [[ "$_java" ]];then
        version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
        vp8=$(echo "$version" | awk -F. '{print $2}')
        vp11=$(echo "$version" | awk -F. '{print $1}')
        if [[ ${vp8} -eq 8 || ${vp11} -eq 11 ]];then
            logger info "$version"
            if [[ "$_make_soft" -eq 1 ]];then
               make_java_soft $_java_conduct_file
               unset _make_soft
            fi
        else
            logger error "cannot support the Java version ${version}, please install Java 8 or Java 11!"
            exit -1
        fi
    fi
}


logger info '----> Check environment'

# 检查包管理器
apt_version="$(apt-get --version 2> /dev/null)"; apt_check_ret="$?"  # Debian / Ubuntu
yum_version="$(yum --version 2> /dev/null)"; yum_check_ret="$?"      # CentOS
apk_version="$(apk --version 2> /dev/null)"; apk_check_ret="$?"      # Alpine
pkg_manager=''
if [[ "$apt_check_ret" -eq 0 ]]; then
  logger info "apt: $(echo "$apt_version" | head -n1)"
  pkg_manager='apt'
elif [[ "$yum_check_ret" -eq 0 ]]; then
  logger info "yum: $(echo "$yum_version" | head -n1)"
  pkg_manager='yum'
elif [[ "$apk_check_ret" -eq 0 ]]; then
  logger info "apk: $(echo "$apk_version" | head -n1)"
  pkg_manager='apk'
else
  logger error 'check pkg manager fail'
  pkg_manager=''
  exit 101
fi

# 检查 java
check_java

# 检查 Python3
find_python3; python3_check_ret="$?"
if [[ "$python3_check_ret" -eq '0' ]]; then
  logger info "python3: $(${python3_executable} --version 2> /dev/null)"
  logger info "pip3: $(${python3_executable} -m pip --version 2> /dev/null)"
elif [[ "$python3_check_ret" -eq '1' ]]; then
  logger info 'python3: none'
  logger info 'pip3: none'
elif [[ "$python3_check_ret" -eq '2' ]]; then
  logger info "python3: $(${python3_executable} --version 2> /dev/null)"
  logger info 'pip3: none'
else
  logger error "check python3 fail, err code: ${python3_check_ret}"
  exit 102
fi

# 检查 git
git_version="$(git --version 2> /dev/null | grep -i 'version')"; git_check_ret="$?"
if [[ "$git_check_ret" -ne 0 || "$git_version" == "" ]]; then
  logger info 'git: none'
else
  git_version="$(echo "$git_version" | grep -oE "[0-9]+\.[0-9]+\.[0-9]+")"
  logger info "git: ${git_version}"
  if version_compare "$git_version" 'lt' "$REQUIRED_MIN_VERSION_GIT"; then
    git_check_ret='1'  # 版本太低
  fi
fi

# 检查 go
go_version="$(go version 2> /dev/null | grep -i 'version')"; go_check_ret="$?"
if [[ "$go_check_ret" -ne 0 || "$go_version" == "" ]]; then
  logger warning 'go not installed'
else
  go_version="$(echo "$go_version" | grep -oE "[0-9]+\.[0-9]+")"
  logger info "go: ${go_version}"
  if version_compare "$go_version" 'lt' "$REQUIRED_MIN_VERSION_GO"; then
    logger warning "go version is too low!"  # 版本太低
    go_check_ret='1'
  fi
fi

# 检查 qci_worker
qci_worker_version="$(qci_worker version 2> /dev/null)"; qci_worker_check_ret="$?"
if [[ "$qci_worker_check_ret" -eq '0' ]]; then
  logger info "qci_worker: ${qci_worker_version}"
else
  logger info 'qci_worker: none'
fi


logger info '----> Initialize environment'

# 创建临时目录
TMP_DIR="$(mktemp -d)"; mktemp_ret="$?"
if [[ "$mktemp_ret" -ne 0 || ! -d "$TMP_DIR" ]]; then
  logger error "create temp dir fail, err code: ${mktemp_ret}"
  exit 111
fi

# 安装基础依赖并确定其他软件安装命令
logger info 'installing base components ...'
if [[ "${pkg_manager}" == 'apt' ]]; then
  apt-get update -y
  # shellcheck disable=SC2086
  # BASE_PKG_APT='curl unzip python3-distutils-extra'
  apt-get install -y ${BASE_PKG_APT}; install_base_ret="$?"
  install_cmd_python3='apt-get install -y python3'
  install_cmd_git='apt-get install -y git'
  # install_cmd_git='apt-get install -y git git-lfs'
elif [[ "${pkg_manager}" == 'yum' ]]; then
  # shellcheck disable=SC2086
  yum install -y ${BASE_PKG_YUM}; install_base_ret="$?"
  install_cmd_python3='yum install -y python3'
  install_cmd_git='yum install -y git'
  # install_cmd_git='yum install -y git git-lfs'
elif [[ "${pkg_manager}" == 'apk' ]]; then
  apk update
  # shellcheck disable=SC2086
  apk add ${BASE_PKG_APK}; install_base_ret="$?"
  install_cmd_python3='apk add python3'
  install_cmd_git='apk add git'
  # install_cmd_git='apk add git git-lfs'
fi

if [[ "$install_base_ret" -ne '0' ]]; then
  logger error "install base components fail, err code: ${install_base_ret}"
  exit 112
fi

# 安装 python3
if [[ "${python3_check_ret}" -eq '1' ]]; then
  logger info 'installing python3 ...'
  ${install_cmd_python3}; install_python3_ret="$?"
  find_python3; python3_check_ret="$?"
  if [[ "$install_python3_ret" -ne '0' ]]; then
    logger error "install python3 fail, err code: ${install_python3_ret}"
    exit 113
  elif [[ "$python3_check_ret" -eq '1' || "$python3_check_ret" -gt '2' ]]; then
    logger error "python3 is not installed (requires python >= ${REQUIRED_MIN_VERSION_PYTHON3}), err code: ${python3_check_ret}"
    exit 114
  fi
fi

export PYTHONIOENCODING=utf-8

# 安装 pip3
if [[ "${python3_check_ret}" -eq '2' ]]; then
  logger info 'installing pip3 ...'
  logger debug "downloading get-pip.py from ${DOWNLOAD_URL_GET_PIP} to ${TMP_DIR}/get-pip.py"
  curl -fL "$DOWNLOAD_URL_GET_PIP" -o "${TMP_DIR}/get-pip.py"; download_get_pip_ret="$?"
  if [[ "$download_get_pip_ret" -ne 0 || ! -f "${TMP_DIR}/get-pip.py" ]]; then
    logger error "download get-pip.py fail, err code: ${download_get_pip_ret}"
    exit 115
  fi
  ${python3_executable} "${TMP_DIR}/get-pip.py"; install_pip_ret="$?"
  find_python3; python3_check_ret="$?"
  if [[ "$install_pip_ret" -ne '0' ]]; then
    logger error "install pip3 fail, err code: ${install_pip_ret}"
    exit 116
  elif [[ "$python3_check_ret" -ne '0' ]]; then
    logger error "pip3 is not installed, err code: ${python3_check_ret}"
    exit 117
  fi
fi

# 安装 qci_worker
# 这里不判断是否已经安装，总尝试更新到最新版
logger info 'installing qci_worker ...'
${python3_executable} -m pip install -U qci_worker -i "$PYPI_INDEX" --trusted-host "$PYPI_DOMAIN"; install_qci_worker_ret="$?"
if [[ "$install_qci_worker_ret" -ne '0' ]]; then
  logger error "install qci_worker fail: err code: ${install_qci_worker_ret}"
  exit 118
fi
qci_worker version

# 安装 git
if [[ "$git_check_ret" -ne 0 ]]; then
  ${install_cmd_git}; install_git_ret="$?"
  if [[ "$install_git_ret" -ne '0' ]]; then
    logger error "install git fail: err code: ${install_git_ret}"
    exit 120
  fi
fi

# 再次验证 git 版本
git_version="$(git --version 2> /dev/null | grep -i 'version')"; git_check_ret="$?"
if [[ "$git_check_ret" -ne 0 || "$git_version" == "" ]]; then
  logger error 'git is not installed'
  exit 121
else
  git_version="$(echo "$git_version" | grep -oE "[0-9]+\.[0-9]+\.[0-9]+")"
  if version_compare "$git_version" 'lt' "$REQUIRED_MIN_VERSION_GIT"; then
      logger error "git version too low (requires git >= ${REQUIRED_MIN_VERSION_GIT})"
      exit 122
  fi
fi

# 安装 go
if [[ "$go_check_ret" -ne 0 ]]; then
    logger info 'installing go ...'
    logger debug "downloading go installer from ${DOWNLOAD_URL_GO} to /usr/local/Worker"
    # 检查有残余的 go 文件, 则进行删除
    if [[ -d /usr/local/Worker ]]; then
        rm -rf /usr/local/Worker/go
    else
        mkdir /usr/local/Worker
    fi
    curl -fL "$DOWNLOAD_URL_GO" -o "${TMP_DIR}/go1.17.8.linux-amd64.tar.gz";
    tar -C /usr/local/Worker -xzf "${TMP_DIR}/go1.17.8.linux-amd64.tar.gz" >> /dev/null 2>&1;
    if [[ -x /usr/local/Worker/go/bin/go ]]; then
      ln -snf /usr/local/Worker/go/bin/go /usr/local/bin/go; ret_go_make="$?"
      if [[ "$ret_go_make" -eq 0 ]]; then
        logger info "install go1.17 success"
      else
        logger error "make go soft link fail, you can conduct 'ln -snf /usr/local/Worker/go/bin/go /usr/local/bin/go' to make go soft link."
      fi
    else
      logger error "install go1.17  fail"
    fi
fi

# 先尝试移除之前的节点信息
qci_worker remove

# 安装 Jenkins
logger info 'installing jenkins ...'
rm -rf "$JENKINS_HOME"  # TODO: 可能需要先问一下用户是否能够删除
mkdir -p "$JENKINS_HOME"
logger debug "downloading jenkins.war from ${DOWNLOAD_URL_JENKINS_WAR} to ${JENKINS_HOME}/jenkins.war"
curl -fL "$DOWNLOAD_URL_JENKINS_WAR" -o "${JENKINS_HOME}/jenkins.war"
chmod +x "${JENKINS_HOME}/jenkins.war"
logger debug "downloading jenkinsHome.zip from ${DOWNLOAD_URL_JENKINS_HOME} to ${JENKINS_HOME}/jenkinsHome.zip"
curl -fL "$DOWNLOAD_URL_JENKINS_HOME" -o "${JENKINS_HOME}/jenkinsHome.zip"
unzip -o "${JENKINS_HOME}/jenkinsHome.zip" -d "$JENKINS_HOME" >> /dev/null 2>&1
if [[ ! -f "${JENKINS_HOME}/jenkins.war" || ! -d "${JENKINS_HOME}/jenkins_home" ]]; then
  logger error 'install jenkins fail'
  exit 123
fi

# 设置检查更新的路径
qci_worker config PYPI_PACKAGE_URL=$PYPI_PACKAGE_INDEX
# 设置更新命令
qci_worker config PYPI_INDEX_URL=$PYPI_INDEX
qci_worker config NODE_LOG_REPORT_HOST=$LOG_REPORT

logger info '----> Register'
if [[ "$IN_DOCKER" == 'true' ]]; then
  qci_worker cci_reg --token "$PROJECT_TOKEN" --server "$WS_SERVER" --home "$CI_HOME" --in-docker --no-check-dependency; cci_reg_ret="$?"
else
  qci_worker cci_reg --token "$PROJECT_TOKEN" --server "$WS_SERVER" --home "$CI_HOME" --no-check-dependency; cci_reg_ret="$?"
fi
if [[ "$cci_reg_ret" -eq '0' ]]; then
  logger info 'Register success!'
elif [[ "$cci_reg_ret" -eq '2' ]]; then
  exit
else:
  logger error "register to cci fail: err code: ${cci_reg_ret}"
  exit 141
fi


logger info '----> Start agent'
qci_worker up -d

logger info 'finished.'
