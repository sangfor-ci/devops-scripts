#!/bin/bash

Echo_INFOR(){
    echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;32m[INFOR]\033[0m - \033[1;32m$1\033[0m"
}

Echo_ALERT(){
    echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;33m[ALERT]\033[0m - \033[1;33m$1\033[0m"
}

svn --version > /dev/null 2>&1
if [ $? == 0 ]
then
    Echo_INFOR "svn have installed."
else
    Echo_ALERT "[x] svn haven't install!!!"
    exit 0
fi

mkdir -p $HOME/.subversion || echo 'svn配置文件已经存在'
cat > $HOME/.subversion/servers << EOF
[groups]

[global]
http-proxy-host = 10.11.6.52
http-proxy-port = 9980
#http-proxy-username = superman
#http-proxy-password = talent

store-plaintext-passwords=yes
EOF

