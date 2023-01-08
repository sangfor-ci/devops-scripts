#!/bin/bash

# ===================== Abbreviations =====================
Echo_INFOR(){
    echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;32m[INFOR]\033[0m - \033[1;32m$1\033[0m"
}

Echo_ALERT(){
    echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;33m[ALERT]\033[0m - \033[1;33m$1\033[0m"
}

Echo_ERROR(){
    echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;31m[ERROR]\033[0m - \033[1;31m$1\n\033[0m"
}

Echo_ERROR2(){
    Echo_ERROR "$name download failed, please check if the network is reachable, proxychains4 configuration is correct"
}

Echo_ERROR3(){
    Echo_ERROR "$name installation failed"
}

Echo_ERROR4(){
    Echo_ERROR "$1 git clone failed"
}
