#!/usr/bin/env bash
#set -x

# ======================== !! NOTE !! ========================
#  ________ ________ ________ ________ ________ ________ ________ ________ ________     ___    ___
# |\  _____\\  _____\\  _____\\  _____\\  _____\\  _____\\  _____\\  _____\\   __  \   |\  \  /  /|
# \ \  \__/\ \  \__/\ \  \__/\ \  \__/\ \  \__/\ \  \__/\ \  \__/\ \  \__/\ \  \|\  \  \ \  \/  / /
#  \ \   __\\ \   __\\ \   __\\ \   __\\ \   __\\ \   __\\ \   __\\ \   __\\ \  \\\  \  \ \    / /
#   \ \  \_| \ \  \_| \ \  \_| \ \  \_| \ \  \_| \ \  \_| \ \  \_| \ \  \_| \ \  \\\  \  /     \/
#    \ \__\   \ \__\   \ \__\   \ \__\   \ \__\   \ \__\   \ \__\   \ \__\   \ \_______\/  /\   \
#     \|__|    \|__|    \|__|    \|__|    \|__|    \|__|    \|__|    \|__|    \|_______/__/ /\ __\
#                                                                                      |__|/ \|__|
# 注: 该脚本适用于 debian、kali、Ubuntu、Centos、RedHat、Fedora 等系列系统下
# 注: 完全适配 debian 系列系统
# 注: 基本适配 RedHat 系列系统
# 注: 完全适配 x86 和 arm 架构
# 注: 适配 Centos8 和 Fedora 系统时有些小bug,但不影响使用,可以忽略
# 注: 走代理时,请确认配置好 Proxychains-ng 代理
# Note: This script is available for debian, kali, Ubuntu, Centos, RedHat, Fedora, etc.
# Note: Fully compatible with debian series systems
# Note: Partially adapted to RedHat series systems
# Note: Fully compatible with x86 and arm architectures
# Note: There are some small bugs when adapting to Centos8 and Fedora systems, but it does not affect the use, can be ignored
# Note: When using a proxy, please make sure the Proxychains-ng proxy is configured.

# ===================== Basic variable settings =====================
P_Dir=/pentest
T_Dir=/ffffffff0x
Default_DNS=223.5.5.5
Proxy_URL="https://cdn.ffffffff0x.com/?durl=https://codeload.github.com/rofl0r/proxychains-ng/zip/master"
Proxy_OK=
Docker_OK=
error=0
Linux_architecture_Name=
F8x_Version="1.6.3 Dev(Beta9)"
wget_option="-q --show-progress"

# ===================== Software version variable setting (dev) =====================
# https://www.ruby-lang.org/en/downloads/
Ruby_Ver="3.0"
Ruby_Dir="ruby-3.0.0"
Ruby_bin="ruby-3.0.0.tar.gz"
# https://go.dev/dl/
Go_Version="go1.18.6"
Go_Bin_amd64="go1.18.6.linux-amd64.tar.gz"
Go_Bin_arm64="go1.18.6.linux-arm64.tar.gz"
# https://nodejs.org/dist/
node_Ver="v17.4.0"
node_bin_amd64="node-v17.4.0-linux-x64.tar.xz"
node_bin_arm64="node-v17.4.0-linux-arm64.tar.xz"
node_Dir_amd64="node-v17.4.0-linux-x64"
node_Dir_arm64="node-v17.4.0-linux-arm64"
# http://nginx.org/en/download.html
nginx_Ver="1.18.0"
nginx_bin="nginx-1.18.0.tar.gz"
# https://www.lua.org/download.html
lua_bin="lua-5.4.3.tar.gz"
lua_dir="lua-5.4.3"
# https://github.com/stedolan/jq/releases
jq_bin="jq-1.6.zip"
jq_dir="jq-1.6"
jq_ver="jq-1.6"
# https://github.com/tsl0922/ttyd/releases
ttyd_Ver="1.7.2"
ttyd_bin_amd64="ttyd.x86_64"
ttyd_bin_arm64="ttyd.arm"
# https://github.com/coder/code-server
code_server_Ver="v4.9.1"
code_server_bin1_amd64="code-server-4.9.1-amd64.rpm"
code_server_bin2_amd64="code-server_4.9.1_amd64.deb"
code_server_bin1_arm64="code-server-4.9.1-arm64.rpm"
code_server_bin2_arm64="code-server_4.9.1_arm64.deb"
# https://www.python.org/downloads/
py37_ver="3.7.12"
py37_bin="Python-3.7.12.tar.xz"
py37_dir="Python-3.7.12"
py38_ver="3.8.12"
py38_bin="Python-3.8.12.tar.xz"
py38_dir="Python-3.8.12"
py39_ver="3.9.8"
py39_bin="Python-3.9.8.tar.xz"
py39_dir="Python-3.9.8"
py310_ver="3.10.4"
py310_bin="Python-3.10.4.tar.xz"
py310_dir="Python-3.10.4"
# https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2FLAST_CHANGE?alt=media
# https://commondatastorage.googleapis.com/chromium-browser-snapshots/index.html?prefix=Linux_x64/958422/
chromium_Ver="958422"
# https://phantomjs.org/download.html
phantomjs_bin="phantomjs-2.1.1-linux-x86_64.tar.bz2"
phantomjs_dir="phantomjs-2.1.1-linux-x86_64"

# ===================== Software version variable setting (pentest) =====================
# https://github.com/fatedier/frp/releases
frp_Ver="v0.46.0"
frp_File_amd64="frp_0.46.0_linux_amd64.tar.gz"
frp_File_arm64="frp_0.46.0_linux_arm64.tar.gz"
frp_Dir_amd64="frp_0.46.0_linux_amd64"
frp_Dir_arm64="frp_0.46.0_linux_arm64"
# https://github.com/ehang-io/nps/releases
nps_Ver="v0.26.10"
nps_File_amd64="linux_amd64_server.tar.gz"
nps_File_arm64="linux_arm64_server.tar.gz"
# https://github.com/wikiZ/RedGuard/releases
RedGuard_Ver="22.08.03"
RedGuard_File_amd64="RedGuard_64"
# https://github.com/RustScan/RustScan/releases
RustScan_Version="2.0.1"
RustScan_Install="rustscan_2.0.1_amd64.deb"
# https://github.com/boy-hack/ksubdomain/releases
ksubdomain_Ver="v1.9.5"
ksubdomain_Install="KSubdomain-v1.9.5-linux.tar"
# https://github.com/chaitin/xray/releases
xray_Ver="1.9.3"
xray_File_amd64="xray_linux_amd64.zip"
xray_bin_amd64="xray_linux_amd64"
xray_File_arm64="xray_linux_arm64.zip"
xray_bin_arm64="xray_linux_arm64"
# https://github.com/gobysec/Goby/releases
goby_Ver="Beta1.9.325"
goby_File="goby-linux-x64-1.9.325.zip"
# https://github.com/shadow1ng/fscan/releases
fscan_Ver="1.8.2"
fscan_Install_amd64="fscan_amd64"
fscan_Install_arm64="fscan_arm64"
# https://github.com/ffuf/ffuf/releases
ffuf_Ver="v1.5.0"
ffuf_Install_amd64="ffuf_1.5.0_linux_amd64.tar.gz"
ffuf_Install_arm64="ffuf_1.5.0_linux_arm64.tar.gz"
# https://github.com/projectdiscovery/nuclei/releases
Nuclei_Ver="v2.8.3"
Nuclei_Install_amd64="nuclei_2.8.3_linux_amd64.zip"
Nuclei_Install_arm64="nuclei_2.8.3_linux_arm64.zip"
# https://github.com/Ne0nd0g/merlin/releases
merlin_Ver="v1.5.0"
merlin_Install_amd64="merlinServer-Linux-x64.7z"
merlin_agent_windows="merlinAgent-Windows-x64.7z"
merlin_agent_linux="merlinAgent-Linux-x64.7z"
merlin_agent_darwin="merlinAgent-Darwin-x64.7z"
# https://github.com/chaitin/rad/releases
rad_Ver="0.4"
rad_File_amd64="rad_linux_amd64.zip"
rad_File_arm64="rad_linux_arm64.zip"
rad_bin_amd64="rad_linux_amd64"
rad_bin_arm64="rad_linux_arm64"
# https://github.com/Qianlitp/crawlergo/releases
crawlergo_Ver="v0.4.4"
crawlergo_File_amd64="crawlergo_linux_amd64"
crawlergo_File_arm64="crawlergo_linux_arm64"
# https://github.com/gloxec/CrossC2/releases
CrossC2_Ver="v3.1.0"
# https://github.com/nodauf/Girsh/releases
Girsh_Ver="v0.40"
Girsh_bin_amd64="Girsh_0.40_linux_amd64.tar.gz"
Girsh_bin_arm64="Girsh_0.40_linux_arm64.tar.gz"
# https://github.com/bettercap/bettercap/releases
bettercap_Ver="v2.31.1"
bettercap_bin_amd64="bettercap_linux_amd64_v2.31.1.zip"
bettercap_bin_arm64="bettercap_linux_aarch64_v2.31.1.zip"
# https://github.com/mitmproxy/mitmproxy/releases
mitmproxy_Ver="9.0.1"
mitmproxy_bin="mitmproxy-9.0.1-linux.tar.gz"
# https://github.com/projectdiscovery/naabu/releases
naabu_Ver="v2.1.1"
naabu_bin="naabu_2.1.1_linux_amd64.zip"
# https://github.com/projectdiscovery/proxify/releases
proxify_Ver="v0.0.8"
proxify_bin_amd64="proxify_0.0.8_linux_amd64.zip"
proxify_bin_arm64="proxify_0.0.8_linux_arm64.zip"
# https://github.com/hashcat/hashcat/releases
hashcat_Version="hashcat-6.2.6"
# https://github.com/projectdiscovery/subfinder/releases
subfinder_Ver="v2.5.5"
subfinder_bin_amd64="subfinder_2.5.5_linux_amd64.zip"
subfinder_bin_arm64="subfinder_2.5.5_linux_arm64.zip"
# https://github.com/projectdiscovery/httpx/releases
httpx_Ver="v1.2.5"
httpx_bin_amd64="httpx_1.2.5_linux_amd64.zip"
httpx_bin_arm64="httpx_1.2.5_linux_arm64.zip"
# https://github.com/projectdiscovery/mapcidr/releases
mapcidr_Ver="v1.0.3"
mapcidr_bin_amd64="mapcidr_1.0.3_linux_amd64.tar.gz"
mapcidr_bin_arm64="mapcidr_1.0.3_linux_arm64.tar.gz"
# https://github.com/ffffffff0x/iprange/releases
iprange_Ver="v1.0.1"
iprange_bin_amd64="iprange_1.0.1_linux_amd64.tar.gz"
iprange_bin_arm64="iprange_1.0.1_linux_arm64.tar.gz"
# https://github.com/projectdiscovery/dnsx/releases
dnsx_Ver="v1.1.1"
dnsx_bin_amd64="dnsx_1.1.1_linux_amd64.zip"
dnsx_bin_arm64="dnsx_1.1.1_linux_arm64.zip"
# https://github.com/iBotPeaches/Apktool/releases
apktool_Ver="v2.7.0"
apktool_bin="apktool_2.7.0.jar"
# https://github.com/lc/gau/releases
gau_Ver="v2.1.2"
gau_bin="gau_2.1.2_linux_amd64.tar.gz"
# https://github.com/skylot/jadx/releases
jadx_Ver="v1.4.5"
jadx_bin="jadx-1.4.5.zip"
# https://github.com/qtc-de/remote-method-guesser/releases
rmg_Ver="v4.3.1"
rmg_bin="rmg-4.3.1-jar-with-dependencies.jar"
# https://github.com/No-Github/anew/releases
anew_Ver="v1.0.3"
anew_bin_amd64="anew_1.0.3_linux_amd64.tar.gz"
anew_bin_arm64="anew_1.0.3_linux_arm64.tar.gz"
# https://github.com/zu1k/nali/releases
nali_Ver="v0.7.0"
nali_bin_amd64="nali-linux-amd64-v0.7.0.gz"
nali_bin_arm64="nali-linux-armv8-v0.7.0.gz"
# https://github.com/hahwul/dalfox/releases
dalfox_Ver="v2.8.2"
dalfox_bin_amd64="dalfox_2.8.2_linux_amd64.tar.gz"
dalfox_bin_arm64="dalfox_2.8.2_linux_arm64.tar.gz"
# https://github.com/ffffffff0x/DomainSplit/releases
DomainSplit_Ver="1.0"
# https://github.com/WangYihang/Platypus/releases
Platypus_Ver="v1.5.1"
Platypus_bin_amd64="Platypus_linux_amd64"
Platypus_bin_arm64="Platypus_linux_arm64"
# https://github.com/OWASP/Amass/releases
Amass_Ver="v3.21.2"
Amass_bin_amd64="amass_linux_amd64.zip"
Amass_bin_arm64="amass_linux_arm64.zip"
# https://github.com/OJ/gobuster/releases
gobuster_Ver="v3.4.0"
gobuster_bin_amd64="gobuster_3.4.0_Linux_x86_64.tar.gz"
gobuster_bin_arm64="gobuster_3.4.0_Linux_arm64.tar.gz"
# https://github.com/jaeles-project/gospider/releases
gospider_Ver="v1.1.6"
gospider_bin_amd64="gospider_v1.1.6_linux_x86_64.zip"
gospider_dir_amd64="gospider_v1.1.6_linux_x86_64"
gospider_bin_arm64="gospider_v1.1.6_linux_arm64.zip"
gospider_dir_arm64="gospider_v1.1.6_linux_arm64"
# https://github.com/tomnomnom/unfurl/releases
unfurl_Ver="v0.4.3"
unfurl_Bin="unfurl-linux-amd64-0.4.3.tgz"
# https://github.com/tomnomnom/qsreplace/releases
qsreplace_Ver="v0.0.3"
qsreplace_bin="qsreplace-linux-amd64-0.0.3.tgz"
# https://github.com/jaeles-project/jaeles/releases
jaeles_Ver="beta-v0.17"
jaeles_bin="jaeles-v0.17-linux.zip"
jaeles_sbin="jaeles-v0.17-linux"
# https://github.com/lc/subjs/releases
subjs_Ver="v1.0.1"
subjs_bin="subjs_1.0.1_linux_amd64.tar.gz"
# https://github.com/tomnomnom/assetfinder/releases
assetfinder_Ver="v0.1.1"
assetfinder_bin="assetfinder-linux-amd64-0.1.1.tgz"
# https://github.com/zhzyker/dismap/releases
dismap_Ver="v0.4"
dismap_bin_amd64="dismap-0.4-linux-amd64"
dismap_bin_arm64="dismap-0.4-linux-arm64"
# https://github.com/robhax/gojwtcrack/releases
gojwtcrack_Ver="0.1"
gojwtcrack_bin="gojwtcrack-linux-amd64.gz"
# https://github.com/fofapro/fapro/releases
fapro_Ver="v0.64"
fapro_bin_amd64="fapro_linux_x86_64.tar.gz"
fapro_bin_arm64="fapro_linux_arm64.tar.gz"
# https://github.com/wh1t3p1g/ysomap/releases
ysomap_Ver="v0.1.3"
ysomap_bin="ysomap.jar"
JNDIExploit_Ver="1.1"
JNDIExploit_bin="JNDIExploit.zip"
# https://github.com/shmilylty/netspy/releases
netspy_Ver="v0.0.5"
netspy_bin_amd64="netspy_linux_amd64.zip"
netspy_bin_arm64="netspy_linux_arm64.zip"
# https://github.com/cdk-team/CDK/releases
cdk_Ver="v1.5.0"
cdk_bin_amd64="cdk_linux_amd64"
cdk_bin_arm64="cdk_linux_arm64"
# https://github.com/projectdiscovery/interactsh/releases
interactsh_Ver="v1.0.7"
interactsh_client_bin_amd64="interactsh-client_1.0.7_Linux_x86_64.zip"
interactsh_server_bin_amd64="interactsh-server_1.0.7_Linux_x86_64.zip"
interactsh_client_bin_arm64="interactsh-client_1.0.7_Linux_arm.zip"
interactsh_server_bin_arm64="interactsh-server_1.0.7_Linux_arm.zip"
# https://github.com/BishopFox/sliver/releases
sliver_Ver="v1.5.31"
sliver_bin_Server="sliver-server_linux"
sliver_bin_Client="sliver-client_linux"
# https://github.com/mstxq17/MoreFind/releases
MoreFind_Ver="v1.2.7"
MoreFind_bin_amd64="MoreFind_1.2.7_Linux_x86_64.tar.gz"
MoreFind_bin_arm64="MoreFind_1.2.7_Linux_arm64.tar.gz"
# https://github.com/praetorian-inc/fingerprintx
fingerprintx_Ver="v1.0.2"
fingerprintx_Install_amd64="fingerprintx_1.0.2_linux_amd64.tar.gz"
fingerprintx_Install_arm64="fingerprintx_1.0.2_linux_arm64.tar.gz"
# https://github.com/teamssix/cf
cf_Ver="v0.4.4"
cf_Install_amd64="cf_v0.4.4_linux_amd64.tar.gz"
cf_Install_arm64="cf_v0.4.4_linux_arm64.tar.gz"
ysuserial_Ver="v1.1"
ysuserial_bin="ysuserial-1.1-su18-all.jar"
katana_Ver="v0.0.2"
katana_bin_amd64="katana_0.0.2_linux_amd64.zip"
katana_bin_arm64="katana_0.0.2_linux_arm64.zip"
uncover_Ver="v0.0.9"
uncover_bin_amd64="uncover_0.0.9_linux_amd64.zip"
uncover_bin_arm64="uncover_0.0.9_linux_arm64.zip"
HostCollision_Ver="HostCollision-2.2.7"
HostCollision_Bin="HostCollision-2.2.7.zip"
HostCollision_dir="HostCollision-2.2.7"
asnmap_bin_amd64="asnmap_0.0.1_linux_amd64.tar.gz"
asnmap_bin_arm64="asnmap_0.0.1_linux_arm64.tar.gz"
asnmap_Ver="v0.0.1"
tlsx_Ver="v1.0.0"
tlsx_bin_amd64="tlsx_1.0.0_linux_amd64.zip"
tlsx_bin_arm64="tlsx_1.0.0_linux_arm64.zip"

# ===================== Software version variable setting (other) =====================
# https://github.com/AdguardTeam/AdGuardHome/releases
AdGuardHome_Version="v0.107.21"
AdGuardHome_File_amd64="AdGuardHome_linux_amd64.tar.gz"
AdGuardHome_File_arm64="AdGuardHome_linux_arm64.tar.gz"
# https://github.com/junegunn/fzf/releases
fzf_Ver="0.35.1"
fzf_bin_amd64="fzf-0.35.1-linux_amd64.tar.gz"
fzf_bin_arm64="fzf-0.35.1-linux_arm64.tar.gz"
# https://github.com/iawia002/lux/releases
lux_Ver="v0.16.0"
lux_bin_amd64="lux_0.16.0_Linux_64-bit.tar.gz"
lux_bin_arm64="lux_0.16.0_Linux_ARM64.tar.gz"
# https://github.com/tomnomnom/gron/releases
gron_Ver="v0.7.1"
gron_bin_amd64="gron-linux-amd64-0.7.1.tgz"
gron_bin_arm64="gron-linux-arm64-0.7.1.tgz"
# https://github.com/abhimanyu003/sttr/releases
sttr_Ver="v0.2.13"
sttr_bin_amd64="sttr_0.2.13_linux_amd64.tar.gz"
sttr_bin_arm64="sttr_0.2.13_linux_arm64.tar.gz"
# https://github.com/sharkdp/bat/releases
bat_Ver="v0.22.1"
bat_bin_amd64="bat-musl_0.22.1_amd64.deb"
bat_bin_arm64="bat-musl_0.22.1_i686.deb"
# https://github.com/muesli/duf/releases
duf_Ver="v0.8.1"
duf_bin1_amd64="duf_0.8.1_linux_amd64.rpm"
duf_bin2_amd64="duf_0.8.1_linux_amd64.deb"
duf_bin1_arm64="duf_0.8.1_linux_arm64.rpm"
duf_bin2_arm64="duf_0.8.1_linux_arm64.deb"
# https://github.com/dalance/procs/releases
procs_Ver="v0.13.3"
procs_bin="procs-v0.13.3-x86_64-linux.zip"
# https://github.com/sharkdp/fd/releases
fd_Ver="v8.6.0"
fd_bin_amd64="fd_8.6.0_amd64.deb"
fd_bin_arm64="fd_8.6.0_arm64.deb"
# https://github.com/hashicorp/terraform/releases
Terraform_Ver="1.3.6"
Terraform_bin_amd64="terraform_1.3.6_linux_amd64.zip"
Terraform_bin_arm64="terraform_1.3.6_linux_arm64.zip"
# https://github.com/aliyun/aliyun-cli/releases
aliyun_cli_Ver="v3.0.141"
aliyun_cli_bin_amd64="aliyun-cli-linux-3.0.141-amd64.tgz"
aliyun_cli_bin_arm64="aliyun-cli-linux-3.0.141-arm64.tgz"
# https://github.com/bcicen/ctop/releases/
ctop_Ver="v0.7.7"
ctop_bin_amd64="ctop-0.7.7-linux-amd64"
ctop_bin_arm64="ctop-0.7.7-linux-arm64"
# https://github.com/mikefarah/yq
yq_Ver="v4.30.6"
yq_bin_amd64="yq_linux_amd64"
yq_bin_arm64="yq_linux_arm64"
yq_File_amd64="yq_linux_amd64.tar.gz"
yq_File_arm64="yq_linux_arm64.tar.gz"

# ===================== 不可以修改的版本(从我的仓库下载,如果修改版本号,需要同时修改下载链接) =====================
# https://www.oracle.com/java/technologies/downloads/
jdk8_Version="jdk1.8.0_321"
orclejdk_tmp_ver="1.0.5"
orclejdk8_bin_amd64="jdk-8u321-linux-x64.tar.gz"
orclejdk8_bin_arm64="jdk-8u321-linux-aarch64.tar.gz"
jdk11_Version="jdk-11.0.15"
orclejdk11_bin_amd64="jdk-11.0.15_linux-x64_bin.tar.gz"
orclejdk11_bin_arm64="jdk-11.0.15_linux-aarch64_bin.tar.gz"
CS_File="CobaltStrike4.3.zip"
CS_Version="CobaltStrike4.3"
CS45_File="CobaltStrike4.5.zip"
CS45_Version="CobaltStrike4.5"

# 加载自定义版本配置
if test -e f8x_version.sh
then
    . ./f8x_version.sh
fi

# ===================== Base Folder =====================
Base_Dir(){

    mkdir -p /tmp > /dev/null 2>&1

    if test -d $T_Dir
    then
        Echo_INFOR "$T_Dir folder already exists"
    else
        mkdir -p $T_Dir && Echo_INFOR "$T_Dir folder created"
    fi

    date +"%Y-%m-%d" > /tmp/f8x_error.log

}

# ===================== Unlock Module =====================
Rm_Lock(){

    case $Linux_Version in
        *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
            rm -f /var/run/yum.pid 1> /dev/null 2>> /tmp/f8x_error.log
            rm -f /var/cache/dnf/metadata_lock.pid 1> /dev/null 2>> /tmp/f8x_error.log
            ;;
        *"Kali"*|*"Ubuntu"*|*"Debian"*)
            rm -rf /var/cache/apt/archives/lock > /dev/null 2>&1
            rm -rf /var/lib/dpkg/lock-frontend > /dev/null 2>&1
            rm -rf /var/lib/dpkg/lock > /dev/null 2>&1
            rm -rf /var/lib/apt/lists/lock > /dev/null 2>&1
            apt-get --fix-broken install > /dev/null 2>&1
            rm -rf /var/cache/apt/archives/lock > /dev/null 2>&1
            rm -rf /var/lib/dpkg/lock-frontend > /dev/null 2>&1
            rm -rf /var/lib/dpkg/lock > /dev/null 2>&1
            rm -rf /var/lib/apt/lists/lock > /dev/null 2>&1
            ;;
        *) ;;
    esac

}

Docker_run_Check(){

    if test -e /.dockerenv
    then
        case $(ls -alh /.dockerenv 2>> /tmp/f8x_error.log) in
        *"docker"*)
            Echo_ALERT "Currently running in a Docker environment, there may be unanticipated problems"
            Docker_OK=1
            ;;
        esac
    else
        case $(cat /proc/1/cgroup 2>> /tmp/f8x_error.log) in
        *"docker"*)
            Echo_ALERT "Currently running in a Docker environment, there may be unanticipated problems"
            Docker_OK=1
            ;;
        esac
    fi

}

# ===================== Dependency Check Module =====================
Base_Check(){

    Echo_ALERT "Dependencies being checked"
    which unzip > /dev/null 2>&1 || error=1
    which wget > /dev/null 2>&1 || error=1
    which curl > /dev/null 2>&1 || error=1
    which vim > /dev/null 2>&1 || error=1
    which git > /dev/null 2>&1 || error=1
    which 7za > /dev/null 2>&1 || error=1

    if [ $error == 1 ]
    then
        Echo_ALERT "Dependencies are not passed, basic dependencies will be installed automatically"
        Base_Install
        error=0
    else
        Echo_INFOR "Base dependencies passed"
    fi

}

Py_Check(){

    Echo_ALERT "Checking Python environment availability"
    which python2 > /dev/null 2>&1 || error=1
    which python3 > /dev/null 2>&1 || error=1
    which pip3 > /dev/null 2>&1 || error=1

    if [ $error == 1 ]
    then
        Echo_ALERT "Python environment check does not pass and starts installing Python environment automatically"
        Python3_def_Install
        Python2_Install
        error=0
    else
        Echo_INFOR "Python environment passed"
    fi

}

pip2_Check(){

    which pip2 > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_INFOR "pip2 dependencies are normal"
    else
        Echo_ALERT "Dependencies not passed, start automatic installation of pip2"
        Python2_Install
    fi
}

pip3_Check(){

    which pip3 > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_INFOR "pip3 dependencies are normal"
    else
        Echo_ALERT "Dependencies not passed, start automatic installation of pip3"
        Python3_def_Install
    fi
}

nn_Check(){

    echo -e "\033[1;33m\n>> Checking npm & nodejs environment availability\n\033[0m"
    npm version > /dev/null 2>&1 && Echo_INFOR "npm available" || error=1
    node --version > /dev/null 2>&1 && Echo_INFOR "node $(node --version) available" || error=1

    if [ $error == 1 ]
    then
        Echo_ALERT "Dependencies not passed, start automatic installation of npm & nodejs"
        nn_Install
        error=0
    else
        Echo_INFOR "npm & nodejs passed"
    fi

}

Rust_Check(){

    echo -e "\033[1;33m\n>> Checking Rust environment availability\n\033[0m"
    cargo -V > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_INFOR "Rust passed~"
    else
        Echo_ALERT "Dependencies not passed, start automatic installation of Rust"
        Rust_Install
    fi

}

JDK_Check(){

    Echo_INFOR "Checking JDK environment availability"
    which java > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_INFOR "jdk passed~"
    else
        Echo_ALERT "Dependencies not passed, start automatic installation of oracle-jdk"
        Oraclejdk_Install
    fi

}

GO_Check(){

    Echo_INFOR "Checking GO environment availability"
    which go > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_INFOR "go passed~"
    else
        Echo_ALERT "Dependencies not passed, start automatic installation of go"
        echo -e "\033[1;33m\n>> Installing Go\n\033[0m"
        Go_Install
    fi

}

Ruby_Check(){

    Echo_INFOR "Checking Ruby environment availability"
    which gem > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_INFOR "Ruby passed~"
    else
        Echo_ALERT "Dependencies not passed, start automatic installation of Ruby"
        Ruby_Install
    fi

}

Docker_Check(){

    Echo_INFOR "Checking Docker environment availability"
    which docker > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_INFOR "Docker passed~"
        service docker start > /dev/null 2>&1
        systemctl start docker > /dev/null 2>&1
    else
        Echo_ALERT "Dependencies not passed, start automatic installation of Docker"
        Docker_Install
    fi

}

mac_Check(){

    case $Running_Mode in
        *"Darwin"*)
            Echo_ALERT "Not supported on mac platform"
            exit 1
            ;;
    esac

}

linux_arm64_Check(){

    case $Linux_architecture_Name in
        *"linux-arm64"*)
            Echo_ALERT "Not supported on current architecture"
            exit 1
            ;;
    esac

}

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

Install_Switch(){

    case $Linux_Version in
        *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
            yum install -y $1 1> /dev/null 2>> /tmp/f8x_error.log && Echo_INFOR "Successfully installed $1 " && return 0 || { Echo_ERROR "$1 installation failed"; return 1; }
            ;;
        *"Kali"*|*"Ubuntu"*|*"Debian"*)
            apt-get install -y $1 1> /dev/null 2>> /tmp/f8x_error.log && Echo_INFOR "Successfully installed $1 " && return 0 || { Echo_ERROR "$1 installation failed"; return 1; }
            ;;
        *) ;;
    esac

}

Install_Switch2(){

    apt-get install -yq --no-install-recommends $1 1> /dev/null 2>> /tmp/f8x_error.log && Echo_INFOR "Successfully installed $1 " || Echo_ERROR "$1 installation failed"

}

Install_Switch3(){

    python2 -m pip install $1 > /dev/null 2>&1 && Echo_INFOR "Successfully installed $1 (python2)" && return 0 || { Echo_ERROR "$1 module installation failed, please try changing the pip proxy or check if python2 is installed!"; return 1; }

}

Install_Switch4(){

    pip3 install $1 1> /dev/null 2>> /tmp/f8x_error.log && Echo_INFOR "Successfully installed $1 (python3)" && return 0 || { Echo_ERROR "$1 module installation failed"; return 1; }

}

Install_Switch5(){

    python3 -m pip install $1 1> /dev/null 2>> /tmp/f8x_error.log && Echo_INFOR "Successfully installed $1 (python3)" && return 0 || { Echo_ERROR "$1 module installation failed"; return 1; }

}

# ===================== Proxy Switch =====================
Proxy_Switch(){

    if test -e /tmp/IS_CI
    then
        Echo_INFOR "IS_CI"
    else
        Echo_ALERT "Some regions can be configured to use proxies to increase speed"
        echo -e "\033[1;33m\n>> Does the runtime need to use a proxy? [y/N,Default N] \033[0m" && read -r input
        case $input in
            [yY][eE][sS]|[Yy])
                export GOPROXY=https://proxy.golang.com.cn,direct
                if test -e /etc/proxychains.conf
                then
                    Echo_INFOR "Proxychains-ng is being called"
                    Proxy_OK=proxychains4
                else
                    Echo_ALERT "Proxychains-ng is not detected, start automatic installation"
                    Proxychains_Install
                    Proxy_OK=proxychains4
                fi
                ;;
            *)
                Echo_INFOR "Pass~"
                ;;
        esac
    fi

}

Banner(){

    echo -e "\033[1;34m  _______   ___   ___   ___ \033[0m"
    echo -e "\033[1;32m |   ____| / _ \  \  \ /  / \033[0m"
    echo -e "\033[1;36m |  |__   | (_) |  \  V  / \033[0m"
    echo -e "\033[1;31m |   __|   > _ <    >   < \033[0m"
    echo -e "\033[1;35m |  |     | (_) |  /  .  \ \033[0m"
    echo -e "\033[1;33m |__|      \___/  /__/ \__\ \n\033[0m"

}

# ===================== Default =====================
Sys_Version(){

    case "$(uname -m)" in
        *"arm64"*|*"aarch64"*)
            Linux_architecture_Name="linux-arm64"
            ;;
        *"x86_64"*)
            Linux_architecture_Name="linux-x86_64"
            ;;
        *)
            echo "Not supported on current architecture"
            exit 1
            ;;
    esac

    case $(cat /etc/*-release | head -n 3) in
        *"Kali"*|*"kali"*)
            Linux_Version="Kali"
            case $(cat /etc/*-release | head -n 4) in
                *"2022"*)
                    Linux_Version_Num="kali-rolling"
                    Linux_Version_Name="buster"
                    ;;
                *"2021"*)
                    Linux_Version_Num="kali-rolling"
                    Linux_Version_Name="buster"
                    ;;
                *"2020"*)
                    Linux_Version_Num="kali-rolling"
                    Linux_Version_Name="buster"
                    ;;
                *)
                    Linux_Version_Num="kali-rolling"
                    Linux_Version_Name="stretch"
                    ;;
            esac
            ;;
        *"Ubuntu"*|*"ubuntu"*)
            Linux_Version="Ubuntu"
            case $(cat /etc/*-release | head -n 4) in
                *"jammy"*)
                    Linux_Version_Num="22.04"
                    Linux_Version_Name="jammy"
                    ;;
                *"impish"*)
                    Linux_Version_Num="21.10"
                    Linux_Version_Name="impish"
                    ;;
                *"hirsute"*)
                    Linux_Version_Num="21.04"
                    Linux_Version_Name="hirsute"
                    ;;
                *"groovy"*)
                    Linux_Version_Num="20.10"
                    Linux_Version_Name="groovy"
                    ;;
                *"focal"*)
                    Linux_Version_Num="20.04"
                    Linux_Version_Name="focal"
                    ;;
                *"eoan"*)
                    Linux_Version_Num="19.10"
                    Linux_Version_Name="eoan"
                    ;;
                *"disco"*)
                    Linux_Version_Num="19.04"
                    Linux_Version_Name="disco"
                    ;;
                *"cosmic"*)
                    Linux_Version_Num="18.10"
                    Linux_Version_Name="cosmic"
                    ;;
                *"bionic"*)
                    Linux_Version_Num="18.04"
                    Linux_Version_Name="bionic"
                    ;;
                *"xenial"*)
                    Linux_Version_Num="16.04"
                    Linux_Version_Name="xenial"
                    ;;
                *"vivid"*)
                    Linux_Version_Num="15.04"
                    Linux_Version_Name="vivid"
                    ;;
                *"trusty"*)
                    Linux_Version_Num="14.04"
                    Linux_Version_Name="trusty"
                    ;;
                *"precise"*)
                    Linux_Version_Num="12.04"
                    Linux_Version_Name="precise"
                    ;;
                *)
                    Echo_ERROR "Unknown Ubuntu Codename"
                    exit 1
                    ;;
            esac
            ;;
        *"Debian"*|*"debian"*)
            Linux_Version="Debian"
            case $(cat /etc/*-release | head -n 4) in
                *"bullseye"*)
                    Linux_Version_Num="11"
                    Linux_Version_Name="bullseye"
                    ;;
                *"buster"*)
                    Linux_Version_Num="10"
                    Linux_Version_Name="buster"
                    ;;
                *"stretch"*)
                    Linux_Version_Num="9"
                    Linux_Version_Name="stretch"
                    ;;
                *"jessie"*)
                    Linux_Version_Num="8"
                    Linux_Version_Name="jessie"
                    ;;
                *"wheezy"*)
                    Linux_Version_Num="7"
                    Linux_Version_Name="wheezy"
                    ;;
                *)
                    Echo_ERROR "Unknown Debian Codename"
                    exit 1
                    ;;
            esac
            ;;
        *"CentOS"*|*"centos"*)
            wget_option=""
            echo -e "\033[1;31mPlease replace your Centos, as Centos will not be maintained.\033[0m"
            Linux_Version="CentOS"
            case $(cat /etc/*-release | head -n 1) in
                *"Stream release 9"*)
                    Linux_Version_Num="9 Stream"
                    Linux_Version_Name=""
                    ;;
                *"Stream release 8"*)
                    Linux_Version_Num="8 Stream"
                    Linux_Version_Name=""
                    ;;
                *"release 8"*)
                    Linux_Version_Num="8"
                    Linux_Version_Name=""
                    ;;
                *"release 7"*)
                    Linux_Version_Num="7"
                    Linux_Version_Name=""
                    ;;
                *"release 6"*)
                    Linux_Version_Num="6"
                    Linux_Version_Name=""
                    ;;
                *)
                    Echo_ERROR "Unknown CentOS Codename"
                    exit 1
                    ;;
            esac
            ;;
        *"RedHat"*|*"redhat"*)
            Linux_Version="RedHat"
            ;;
        *"Fedora"*|*"fedora"*)
            Linux_Version="Fedora"
            case $(cat /etc/*-release | head -n 1) in
                *"release 37"*)
                    Linux_Version_Num="37"
                    Linux_Version_Name=""
                    ;;
                *"release 36"*)
                    Linux_Version_Num="36"
                    Linux_Version_Name=""
                    ;;
                *"release 35"*)
                    Linux_Version_Num="35"
                    Linux_Version_Name=""
                    ;;
                *"release 34"*)
                    Linux_Version_Num="34"
                    Linux_Version_Name=""
                    ;;
                *"release 33"*)
                    Linux_Version_Num="33"
                    Linux_Version_Name=""
                    ;;
                *"release 32"*)
                    Linux_Version_Num="32"
                    Linux_Version_Name=""
                    ;;
                *)
                    Echo_ERROR "Unknown Fedora Codename"
                    exit 1
                    ;;
            esac
            ;;
        *"AlmaLinux"*)
            Linux_Version="AlmaLinux"
            ;;
        *"Virtuozzo"*)
            Linux_Version="VzLinux"
            ;;
        *"Rocky"*)
            Linux_Version="Rocky"
            ;;
        *)
            Echo_ERROR "Unknown version"
            echo -e "\033[1;33m\nPlease enter distribution Kali[k] Ubuntu[u] Debian[d] Centos[c] RedHat[r] Fedora[f] AlmaLinux[a] VzLinux[v] Rocky[r]\033[0m" && read -r input
            case $input in
                [kK])
                    Linux_Version="Kali"
                    ;;
                [uU])
                    Linux_Version="Ubuntu"
                    echo -e "\033[1;33m\nPlease enter the system version number [22.04] [21.10] [21.04] [20.10] [20.04] [19.10] [19.04] [18.10] [18.04] [16.04] [15.04] [14.04] [12.04]\033[0m" && read -r input
                    Linux_Version_Name=$input
                    ;;
                [dD])
                    Linux_Version="Debian"
                    echo -e "\033[1;33m\nPlease enter the system version number [11] [10] [9] [8] [7]\033[0m" && read -r input
                    Linux_Version_Name=$input
                    ;;
                [cC])
                    Linux_Version="CentOS"
                    echo -e "\033[1;33m\nPlease enter the system version number [9 Stream] [8 Stream] [8] [7] [6]\033[0m" && read -r input
                    Linux_Version_Name=$input
                    ;;
                [rR])
                    Linux_Version="RedHat"
                    ;;
                [aA])
                    Linux_Version="AlmaLinux"
                    ;;
                [fF])
                    Linux_Version="Fedora"
                    echo -e "\033[1;33m\nPlease enter the system version number [36] [35] [34] [33] [32]\033[0m" && read -r input
                    Linux_Version_Name=$input
                    ;;
                [vV])
                    Linux_Version="VzLinux"
                    ;;
                [rR])
                    Linux_Version="Rocky"
                    ;;
                *)
                    Echo_ERROR "Unknown version"
                    exit 1
                    ;;
            esac
            ;;
    esac

}

Sys_Version_Mac(){

    Linux_Version="$(sw_vers -ProductName)"

    case "$(uname -m)" in
        *"arm64"*)
            Linux_architecture_Name="mac-arm64"
            Linux_Version_Num="$(sw_vers -productVersion)"
            Linux_Version_Name="$(sw_vers -BuildVersion)"

            P_Dir="~/pentest"
            T_Dir="~/ffffffff0x"
            ;;
        *)
            echo "Not supported on current architecture"
            exit 1
            ;;
    esac

}

Sys_Info(){

    echo -e "\033[1;32mUID           :\033[0m \033[1;35m$UID \033[0m"
    echo -e "\033[1;32mUser          :\033[0m \033[1;35m$(whoami) \033[0m"
    echo -e "\033[1;32mDate          :\033[0m \033[1;35m$(date +"%Y-%m-%d") \033[0m"
    echo -e "\033[1;32mTime          :\033[0m \033[1;35m$(date +"%H:%M:%S") \033[0m"
    echo -e "\033[1;32mRuntime       :\033[0m \033[1;35m$(uptime 2>/dev/null | awk '{print $3 $4}' | sed 's/\,.*$//g') \033[0m"
    echo -e "\033[1;32mHostname      :\033[0m \033[1;35m$(hostname) \033[0m"
    echo -e "\033[1;32mDistribution  :\033[0m \033[1;35m$Linux_Version $Linux_Version_Num $Linux_Version_Name $Linux_architecture_Name\033[0m"
    echo -e "\033[1;32mf8x Version   :\033[0m \033[1;35m$F8x_Version \033[0m"

    case $Linux_Version in
        *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
            if test -e /var/log/secure
            then
                echo -e "\033[1;32mLast login IP :\033[0m"
                echo -e "\033[1;35m$(grep 'Accepted' /var/log/secure | awk '{print $11}' | sort | uniq -c | sort -nr) \033[0m"
            fi
            ;;
        *"Kali"*)
                echo "" > /dev/null
            ;;
        *)
            if test -e /var/log/auth.log
            then
                echo -e "\033[1;32mLast login IP :\033[0m"
                echo -e "\033[1;35m$(grep --text "Accepted " /var/log/auth.log | awk '{print $11}' | sort | uniq -c | sort -nr) \033[0m"
            fi
            ;;

    esac

}

# ===================== Update apt source =====================
Update_APT_Mirror(){

    Echo_INFOR "Updating $Linux_Version apt source"

    case $Linux_Version in
        *"Kali"*)
            Echo_INFOR "kali"
            Echo_INFOR "Backed up apt source"
            Update_kali_Mirror "$1" > /dev/null
            ;;
        *"Ubuntu"*)
            case $Linux_Version_Num in
                "22.04")
                    Echo_INFOR "Ubuntu22.04"
                    Echo_INFOR "Backed up apt source"
                    Update_Ubuntu2204_Mirror "$1" > /dev/null
                    ;;
                "21.10")
                    Echo_INFOR "Ubuntu21.10"
                    Echo_INFOR "Backed up apt source"
                    Update_Ubuntu2110_Mirror "$1" > /dev/null
                    ;;
                "21.04")
                    Echo_INFOR "Ubuntu21.04"
                    Echo_INFOR "Backed up apt source"
                    Update_Ubuntu2104_Mirror "$1" > /dev/null
                    ;;
                "20.10")
                    Echo_INFOR "Ubuntu20.10"
                    Echo_INFOR "Backed up apt source"
                    Update_Ubuntu2010_Mirror "$1" > /dev/null
                    ;;
                "20.04")
                    Echo_INFOR "Ubuntu20.04"
                    Echo_INFOR "Backed up apt source"
                    Update_Ubuntu2004_Mirror "$1" > /dev/null
                    ;;
                "19.10")
                    Echo_INFOR "Ubuntu19.10"
                    Echo_INFOR "Backed up apt source"
                    Update_Ubuntu1910_Mirror "$1" > /dev/null
                    ;;
                "19.04")
                    Echo_INFOR "Ubuntu19.04"
                    Echo_INFOR "Backed up apt source"
                    Update_Ubuntu1804_Mirror "$1" > /dev/null
                    ;;
                "18.10")
                    Echo_INFOR "Ubuntu18.10"
                    Echo_INFOR "Backed up apt source"
                    Update_Ubuntu1804_Mirror "$1" > /dev/null
                    ;;
                "18.04")
                    Echo_INFOR "Ubuntu18.04"
                    Echo_INFOR "Backed up apt source"
                    Update_Ubuntu1804_Mirror "$1" > /dev/null
                    ;;
                "16.04")
                    Echo_INFOR "Ubuntu16.04"
                    Echo_INFOR "Backed up apt source"
                    Update_Ubuntu1604_Mirror "$1" > /dev/null
                    ;;
                "15.04")
                    Echo_INFOR "Ubuntu15.04"
                    Echo_INFOR "Backed up apt source"
                    Update_Ubuntu1504_Mirror "$1" > /dev/null
                    ;;
                "14.04")
                    Echo_INFOR "Ubuntu14.04"
                    Echo_INFOR "Backed up apt source"
                    Update_Ubuntu1404_Mirror "$1" > /dev/null
                    ;;
                "12.04")
                    Echo_INFOR "Ubuntu12.04"
                    Echo_INFOR "Backed up apt source"
                    Update_Ubuntu1204_Mirror "$1" > /dev/null
                    ;;
                *)
                    Echo_ERROR "Version error"
                    ;;
            esac
            ;;
        *"Debian"*)
            case $Linux_Version_Num in
                "11")
                    Echo_INFOR "Debian11"
                    Echo_INFOR "Backed up apt source"
                    Update_Debian11_Mirror "$1" > /dev/null
                    ;;
                "10")
                    Echo_INFOR "Debian10"
                    Echo_INFOR "Backed up apt source"
                    Update_Debian10_Mirror "$1" > /dev/null
                    ;;
                "9")
                    Echo_INFOR "Debian9"
                    Echo_INFOR "Backed up apt source"
                    Update_Debian9_Mirror "$1" > /dev/null
                    ;;
                "8")
                    Echo_INFOR "Debian8"
                    Echo_INFOR "Backed up apt source"
                    Update_Debian8_Mirror "$1" > /dev/null
                    ;;
                "7")
                    Echo_INFOR "Debian7"
                    Echo_INFOR "Backed up apt source"
                    Update_Debian7_Mirror > /dev/null
                    ;;
                *)
                    Echo_ERROR "Version error"
                    ;;
            esac
            ;;
    esac

    Echo_INFOR "Updating apt package list"
    Rm_Lock
    apt-get update 1> /dev/null 2>> /tmp/f8x_error.log || Echo_ERROR "Update apt package list failed"

}

# ===================== Modify kali apt source =====================
Update_kali_Mirror(){
rm -f /etc/apt/sources.list.bak > /dev/null 2>&1 && cp /etc/apt/sources.list /etc/apt/sources.list.bak > /dev/null 2>&1

if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
then

tee /etc/apt/sources.list <<-'EOF'
deb https://mirrors.aliyun.com/kali kali-rolling main non-free contrib
# deb-src https://mirrors.aliyun.com/kali kali-rolling main non-free contrib
EOF

else

tee /etc/apt/sources.list <<-'EOF'
deb http://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free
EOF

fi

}

# ===================== Modify Ubuntu apt sources =====================
Update_Ubuntu2204_Mirror(){
rm -f /etc/apt/sources.list.bak > /dev/null 2>&1 && cp /etc/apt/sources.list /etc/apt/sources.list.bak > /dev/null 2>&1

if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
then

tee /etc/apt/sources.list <<-'EOF'
deb http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse
EOF

else

tee /etc/apt/sources.list <<-'EOF'
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
EOF

fi

}

Update_Ubuntu2110_Mirror(){
rm -f /etc/apt/sources.list.bak > /dev/null 2>&1 && cp /etc/apt/sources.list /etc/apt/sources.list.bak > /dev/null 2>&1

if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
then

tee /etc/apt/sources.list <<-'EOF'
deb http://mirrors.aliyun.com/ubuntu/ impish main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ impish-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ impish-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ impish-security main restricted universe multiverse
EOF

else

tee /etc/apt/sources.list <<-'EOF'
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish-security main restricted universe multiverse
EOF

fi

}

Update_Ubuntu2104_Mirror(){
rm -f /etc/apt/sources.list.bak > /dev/null 2>&1 && cp /etc/apt/sources.list /etc/apt/sources.list.bak > /dev/null 2>&1

if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
then

tee /etc/apt/sources.list <<-'EOF'
deb http://mirrors.aliyun.com/ubuntu/ hirsute main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ hirsute-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ hirsute-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ hirsute-security main restricted universe multiverse
EOF

else

tee /etc/apt/sources.list <<-'EOF'
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ hirsute main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ hirsute-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ hirsute-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ hirsute-security main restricted universe multiverse
EOF

fi

}

Update_Ubuntu2010_Mirror(){
rm -f /etc/apt/sources.list.bak > /dev/null 2>&1 && cp /etc/apt/sources.list /etc/apt/sources.list.bak > /dev/null 2>&1

if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
then

tee /etc/apt/sources.list <<-'EOF'
deb http://mirrors.aliyun.com/ubuntu/ groovy main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ groovy-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ groovy-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ groovy-security main restricted universe multiverse
EOF

else

tee /etc/apt/sources.list <<-'EOF'
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ groovy main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ groovy-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ groovy-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ groovy-security main restricted universe multiverse
EOF

fi

}

Update_Ubuntu2004_Mirror(){
rm -f /etc/apt/sources.list.bak > /dev/null 2>&1 && cp /etc/apt/sources.list /etc/apt/sources.list.bak > /dev/null 2>&1

if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
then

tee /etc/apt/sources.list <<-'EOF'
deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
EOF

else

tee /etc/apt/sources.list <<-'EOF'
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse
EOF

fi

}

Update_Ubuntu1910_Mirror(){
rm -f /etc/apt/sources.list.bak > /dev/null 2>&1 && cp /etc/apt/sources.list /etc/apt/sources.list.bak > /dev/null 2>&1

if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
then

tee /etc/apt/sources.list <<-'EOF'
deb http://mirrors.aliyun.com/ubuntu/ eoan main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ eoan-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ eoan-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ eoan-security main restricted universe multiverse
EOF

else

tee /etc/apt/sources.list <<-'EOF'
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ eoan main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ eoan-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ eoan-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ eoan-security main restricted universe multiverse
EOF

fi

}

Update_Ubuntu1804_Mirror(){
rm -f /etc/apt/sources.list.bak > /dev/null 2>&1 && cp /etc/apt/sources.list /etc/apt/sources.list.bak > /dev/null 2>&1

if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
then

tee /etc/apt/sources.list <<-'EOF'
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
EOF

else

tee /etc/apt/sources.list <<-'EOF'
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
EOF

fi

}

Update_Ubuntu1604_Mirror(){
rm -f /etc/apt/sources.list.bak > /dev/null 2>&1 && cp /etc/apt/sources.list /etc/apt/sources.list.bak > /dev/null 2>&1

if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
then

tee /etc/apt/sources.list <<-'EOF'
deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse
EOF

else

tee /etc/apt/sources.list <<-'EOF'
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security main restricted universe multiverse
EOF

fi

}

Update_Ubuntu1504_Mirror(){
rm -f /etc/apt/sources.list.bak > /dev/null 2>&1 && cp /etc/apt/sources.list /etc/apt/sources.list.bak > /dev/null 2>&1

if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
then

tee /etc/apt/sources.list <<-'EOF'
deb http://mirrors.aliyun.com/ubuntu/ vivid main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ vivid-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ vivid-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ vivid-security main restricted universe multiverse
EOF

else

tee /etc/apt/sources.list <<-'EOF'
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ vivid main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ vivid-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ vivid-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ vivid-security main restricted universe multiverse
EOF

fi

}

Update_Ubuntu1404_Mirror(){
rm -f /etc/apt/sources.list.bak > /dev/null 2>&1 && cp /etc/apt/sources.list /etc/apt/sources.list.bak > /dev/null 2>&1

if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
then

tee /etc/apt/sources.list <<-'EOF'
deb http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse
EOF

else

tee /etc/apt/sources.list <<-'EOF'
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-security main restricted universe multiverse
EOF

fi

}

Update_Ubuntu1204_Mirror(){
rm -f /etc/apt/sources.list.bak > /dev/null 2>&1 && cp /etc/apt/sources.list /etc/apt/sources.list.bak > /dev/null 2>&1

if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
then

tee /etc/apt/sources.list <<-'EOF'
deb http://mirrors.aliyun.com/ubuntu/ precise main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ precise-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ precise-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ precise-security main restricted universe multiverse
EOF

else

tee /etc/apt/sources.list <<-'EOF'
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ precise main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ precise-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ precise-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ precise-security main restricted universe multiverse
EOF

fi

}

# ===================== 修改 Debian apt 源 (Modifying Debian apt sources) =====================
Update_Debian11_Mirror(){
rm -f /etc/apt/sources.list.bak > /dev/null 2>&1 && cp /etc/apt/sources.list /etc/apt/sources.list.bak > /dev/null 2>&1

if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
then

tee /etc/apt/sources.list <<-'EOF'
deb http://mirrors.aliyun.com/debian/ bullseye main non-free contrib
deb http://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib
deb http://mirrors.aliyun.com/debian/ bullseye-backports main non-free contrib
deb http://mirrors.aliyun.com/debian-security bullseye/updates main
EOF

else

tee /etc/apt/sources.list <<-'EOF'
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
EOF

fi

}

Update_Debian10_Mirror(){
rm -f /etc/apt/sources.list.bak > /dev/null 2>&1 && cp /etc/apt/sources.list /etc/apt/sources.list.bak > /dev/null 2>&1

if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
then

tee /etc/apt/sources.list <<-'EOF'
deb http://mirrors.aliyun.com/debian/ buster main non-free contrib
deb http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib
deb http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib
deb http://mirrors.aliyun.com/debian-security buster/updates main
EOF

else

tee /etc/apt/sources.list <<-'EOF'
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free
EOF

fi

}

Update_Debian9_Mirror(){
rm -f /etc/apt/sources.list.bak > /dev/null 2>&1 && cp /etc/apt/sources.list /etc/apt/sources.list.bak > /dev/null 2>&1

if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
then

tee /etc/apt/sources.list <<-'EOF'
deb http://mirrors.aliyun.com/debian/ stretch main non-free contrib
deb http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib
deb http://mirrors.aliyun.com/debian/ stretch-backports main non-free contrib
deb http://mirrors.aliyun.com/debian-security stretch/updates main
EOF

else

tee /etc/apt/sources.list <<-'EOF'
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ stretch main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ stretch-updates main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ stretch-backports main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security stretch/updates main contrib non-free
EOF

fi

}

Update_Debian8_Mirror(){
rm -f /etc/apt/sources.list.bak > /dev/null 2>&1 && cp /etc/apt/sources.list /etc/apt/sources.list.bak > /dev/null 2>&1

if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
then

tee /etc/apt/sources.list <<-'EOF'
deb http://mirrors.aliyun.com/debian/ jessie main non-free contrib
deb http://mirrors.aliyun.com/debian/ jessie-proposed-updates main non-free contrib
EOF

else

tee /etc/apt/sources.list <<-'EOF'
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ jessie main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ jessie-updates main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security jessie/updates main contrib non-free
EOF

fi

}

Update_Debian7_Mirror(){
rm -f /etc/apt/sources.list.bak > /dev/null 2>&1 && cp /etc/apt/sources.list /etc/apt/sources.list.bak > /dev/null 2>&1
tee /etc/apt/sources.list <<-'EOF'
deb http://mirrors.aliyun.com/debian/ wheezy main non-free contrib
deb http://mirrors.aliyun.com/debian/ wheezy-proposed-updates main non-free contrib
EOF

}

# ===================== Modifying YUM sources =====================
Update_YUM_Mirror(){

    Echo_ALERT "Updating $Linux_Version yum sources"

    case $Linux_Version in
        *"CentOS"*)
            Update_CentOS_Mirror "$1"
            Update_EPEL_Mirror "$1"
            ;;
        *"RedHat"*)
            Echo_INFOR "RedHat Pass~"
            ;;
        *"AlmaLinux"*)
            Echo_INFOR "AlmaLinux Pass~"
            ;;
        *"VzLinux"*)
            Echo_INFOR "VzLinux Pass~"
            ;;
        *"Rocky"*)
            Echo_INFOR "Rocky Pass~"
            ;;
        *"Fedora"*)
            Echo_INFOR "Fedora"
            rm -f /etc/yum.repos.d/fedora.repo.repo.bak > /dev/null 2>&1 && cp /etc/yum.repos.d/fedora.repo /etc/yum.repos.d/fedora.repo.bak > /dev/null 2>&1 && Echo_INFOR "Backed up Yum sources"

            if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
            then
                curl -o /etc/yum.repos.d/fedora.repo http://mirrors.aliyun.com/repo/fedora.repo > /dev/null 2>&1 && Echo_INFOR "Downloaded aliyun Yum sources" || Echo_ERROR "aliyun Yum sources download failed"
                curl -o /etc/yum.repos.d/fedora-updates.repo http://mirrors.aliyun.com/repo/fedora-updates.repo > /dev/null 2>&1 && Echo_INFOR "Downloaded aliyun Yum update sources" || Echo_ERROR "aliyun Yum update sources download failed"
            elif [ $1 == huawei ] 2>> /tmp/f8x_error.log
            then
                curl -o /etc/yum.repos.d/fedora.repo https://f8x.io/repo/fedora.repo > /dev/null 2>&1 && Echo_INFOR "Downloaded huaweicloud Yum sources" || Echo_ERROR "huaweicloud Yum sources download failed"
                curl -o /etc/yum.repos.d/fedora-updates.repo https://f8x.io/repo/fedora-updates.repo > /dev/null 2>&1 && Echo_INFOR "Downloaded huaweicloud Yum update sources" || Echo_ERROR "huaweicloud Yum update sources download failed"
            elif [ $1 == tuna ] 2>> /tmp/f8x_error.log
            then
                curl -o /etc/yum.repos.d/fedora.repo https://f8x.io/tuna/fedora.repo > /dev/null 2>&1 && Echo_INFOR "Downloaded tuna Yum sources" || Echo_ERROR "tuna Yum sources download failed"
                curl -o /etc/yum.repos.d/fedora-updates.repo https://f8x.io/tuna/fedora-updates.repo > /dev/null 2>&1 && Echo_INFOR "Downloaded tuna Yum update sources" || Echo_ERROR "tuna Yum update sources download failed"
            fi
            ;;
    esac

    Echo_ALERT "Updating yum cache"
    yum clean all > /dev/null 2>&1
    Rm_Lock

    case $Linux_Version in
        *"Fedora"*)
            Echo_ALERT "Fedora ＞﹏＜"
            ;;
        *)
            yum makecache 1> /dev/null 2>> /tmp/f8x_error.log /dev/null || Echo_ERROR "Yum makecache failed"
            ;;
    esac

}

# ===================== Modify CentOS EPEL sources =====================
Update_EPEL_Mirror(){

    if test -e /etc/yum.repos.d/epel.repo
    then
        Echo_INFOR "EPEL source is installed"
    else
        Echo_ALERT "epel source not detected, being installed automatically"
        Rm_Lock
        case $Linux_Version_Num in
            "9 Stream")
                Install_Switch "epel-release"
                ;;
            "8 Stream")
                Install_Switch "epel-release"
                ;;
            8)
                if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
                then
                    yum install -y https://mirrors.aliyun.com/epel/epel-release-latest-8.noarch.rpm > /dev/null 2>&1 && Echo_INFOR "Downloaded aliyun EPEL sources" || Echo_ERROR "aliyun EPEL sources download failed"
                    sed -i 's|^#baseurl=https://download.fedoraproject.org/pub|baseurl=https://mirrors.aliyun.com|' /etc/yum.repos.d/epel*
                    sed -i 's|^metalink|#metalink|' /etc/yum.repos.d/epel*
                elif [ $1 == huawei ] 2>> /tmp/f8x_error.log
                then
                    yum install -y https://mirrors.huaweicloud.com/epel/epel-release-latest-8.noarch.rpm > /dev/null 2>&1 && Echo_INFOR "Downloaded huaweicloud EPEL sources" || Echo_ERROR "huaweicloud EPEL sources download failed"
                elif [ $1 == tuna ] 2>> /tmp/f8x_error.log
                then
                    curl -o /etc/yum.repos.d/epel.repo https://f8x.io/tuna/epel-8.repo > /dev/null 2>&1 && Echo_INFOR "Downloaded tuna EPEL sources" || Echo_ERROR "tuna EPEL sources download failed"
                fi
                ;;
            7)
                if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
                then
                    curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo > /dev/null 2>&1 && Echo_INFOR "Downloaded aliyun EPEL sources" || Echo_ERROR "aliyun EPEL sources download failed"
                elif [ $1 == huawei ] 2>> /tmp/f8x_error.log
                then
                    curl -o /etc/yum.repos.d/epel.repo https://f8x.io/repo/epel-7.repo > /dev/null 2>&1 && Echo_INFOR "Downloaded huaweicloud EPEL sources" || Echo_ERROR "huaweicloud EPEL sources download failed"
                elif [ $1 == tuna ] 2>> /tmp/f8x_error.log
                then
                    curl -o /etc/yum.repos.d/epel.repo https://f8x.io/tuna/epel-7.repo > /dev/null 2>&1 && Echo_INFOR "Downloaded tuna EPEL sources" || Echo_ERROR "tuna EPEL sources download failed"
                fi
                ;;
            6)
                if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
                then
                    curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo > /dev/null 2>&1 && Echo_INFOR "Downloaded aliyun EPEL sources" || Echo_ERROR "aliyun EPEL sources download failed"
                else
                    curl -o /etc/yum.repos.d/epel.repo https://f8x.io/tuna/epel-6.repo > /dev/null 2>&1 && Echo_INFOR "Downloaded tuna EPEL sources" || Echo_ERROR "tuna EPEL sources download failed"
                fi
                ;;
            *)
                Echo_ERROR "Version error"
                ;;
        esac
    fi

}

# ===================== Modify CentOS YUM sources =====================
Update_CentOS_Mirror(){
# CentOS 8和CentOS 6 及以下版本已被华为云官网下线

    case $Linux_Version_Num in
        "9 Stream")
            Echo_INFOR "pass"
            ;;
        "8 Stream")
            Echo_INFOR "pass"
            ;;
        8)
            rm -f /etc/yum.repos.d/CentOS-Base.repo.bak > /dev/null 2>&1 && cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak > /dev/null 2>&1 && Echo_INFOR "Backed up Yum sources"
            if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
            then
                curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-8.repo > /dev/null 2>&1 && Echo_INFOR "Downloaded aliyun Yum sources" || Echo_ERROR "aliyun Yum sources download failed"
            else
                curl -o /etc/yum.repos.d/CentOS-Base.repo https://f8x.io/tuna/Centos-8.repo > /dev/null 2>&1 && Echo_INFOR "Downloaded tuna Yum sources" || Echo_ERROR "tuna Yum sources download failed"
            fi
            ;;
        7)
            rm -f /etc/yum.repos.d/CentOS-Base.repo.bak > /dev/null 2>&1 && cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak > /dev/null 2>&1 && Echo_INFOR "Backed up Yum sources"

            if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
            then
                curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo > /dev/null 2>&1 && Echo_INFOR "Downloaded aliyun Yum sources" || Echo_ERROR "aliyun Yum sources download failed"
            elif [ $1 == huawei ] 2>> /tmp/f8x_error.log
            then
                curl -o /etc/yum.repos.d/CentOS-Base.repo https://f8x.io/repo/Centos-7.repo > /dev/null 2>&1 && Echo_INFOR "Downloaded huaweicloud Yum sources" || Echo_ERROR "huaweicloud Yum sources download failed"
            elif [ $1 == tuna ] 2>> /tmp/f8x_error.log
            then
                curl -o /etc/yum.repos.d/CentOS-Base.repo https://f8x.io/tuna/Centos-7.repo > /dev/null 2>&1 && Echo_INFOR "Downloaded tuna Yum sources" || Echo_ERROR "tuna Yum sources download failed"
            fi
            ;;
        6)
            rm -f /etc/yum.repos.d/CentOS-Base.repo.bak > /dev/null 2>&1 && cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak > /dev/null 2>&1 && Echo_INFOR "Backed up Yum sources"

            if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
            then
                curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-6.repo > /dev/null 2>&1 && Echo_INFOR "Downloaded aliyun Yum sources" || Echo_ERROR "aliyun Yum sources download failed"
            else
                curl -o /etc/yum.repos.d/CentOS-Base.repo https://f8x.io/tuna/Centos-6.repo > /dev/null 2>&1 && Echo_INFOR "Downloaded tuna Yum sources" || Echo_ERROR "tuna Yum sources download failed"
            fi
            ;;
        *)
            Echo_ERROR "Version error"
            ;;
    esac

}

# ===================== Modify system package manager source =====================
Mirror(){

    case $Linux_Version in
        *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
            echo -e "\033[1;33m\n>> Update yum source? [Y/n,Default Y]\033[0m" && read -r input
            case $input in
                [nN][oO]|[nN])
                    Echo_INFOR "Pass~"
                    ;;
                *)
                    Update_YUM_Mirror "$1"
                    Echo_INFOR "yum source updated"
                    ;;
            esac
            ;;
        *"Kali"*|*"Ubuntu"*|*"Debian"*)
            echo -e "\033[1;33m\n>> Update apt source? [Y/n,Default Y]\033[0m" && read -r input
            case $input in
                [nN][oO]|[nN])
                    Echo_INFOR "Pass~"
                    ;;
                *)
                    Update_APT_Mirror "$1"
                    Echo_INFOR "apt source updated"
                    ;;

            esac
            ;;
        *)
            Echo_ERROR "Unknown version, update package source failed"
            ;;
    esac

    echo -e "\033[1;33m\n>> Configuring the pip proxy\n\033[0m"
    pip_Proxy "$1" > /dev/null

    Echo_INFOR "Updated pip Proxy"

    echo -e "\033[1;33m\n>> Configuring the docker proxy\n\033[0m"
    Docker_Proxy > /dev/null
    systemctl restart docker > /dev/null 2>&1
    systemctl daemon-reload > /dev/null 2>&1

    Echo_INFOR "Updated docker Proxy"

}

# ===================== Check DNS IP format =====================
Change_DNS_IP(){

    read -r input

    case $input in
        [nN][oO]|[nN])
            Echo_INFOR "Pass~"
            ;;
        *)
            echo -e "\033[5;33mPlease enter the DNS server address [Default is $Default_DNS]\033[0m" && read -r input

            VALID_CHECK=$(echo "$input"|awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255{print "yes"}')
            if echo "$input"|grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$">/dev/null; then
                if [ "${VALID_CHECK:-no}" == "yes" ]; then
                    Default_DNS=$input
                    Change_DNS
                else
                    Echo_ERROR "$input invalid"
                    Change_DNS
                fi
            else
                Echo_ERROR "$input invalid"
                Change_DNS
            fi
            ;;
    esac

}

# ===================== Update DNS =====================
Change_DNS(){

    echo "nameserver $Default_DNS" > /etc/resolv.conf
    Echo_INFOR "The default DNS is configured as: $Default_DNS"

}

# ===================== Install DNS tools =====================
DNS_T00ls(){

    case $Linux_Version in
        *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
            Echo_INFOR "RedHat system does not have resolvconf, this item Pass"
            ;;
        *"Kali"*|*"Ubuntu"*|*"Debian"*)
            Rm_Lock
            Install_Switch "resolvconf"
            echo "nameserver $Default_DNS" > /etc/resolvconf/resolv.conf.d/head
            resolvconf -u ;;
        *) ;;
    esac

}

# ===================== Install Proxychains-ng =====================
Proxychains_Install(){

    Rm_Lock
    Install_Switch "gcc"
    Install_Switch "git"
    Install_Switch "vim"
    Install_Switch "make"
    Install_Switch "wget"
    Install_Switch "zip"
    Install_Switch "unzip"
    case $Linux_Version in
        *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
            Install_Switch "gcc-c++"
            ;;
        *"Kali"*|*"Ubuntu"*|*"Debian"*)
            Install_Switch "g++"
            Install_Switch "ca-certificates"
            ;;
        *) ;;
    esac

    case $Linux_Version in
        *"Kali"*)
            rm -f /etc/proxychains.conf > /dev/null 2>&1
            ;;
        *) ;;
    esac

    if test -e /etc/proxychains.conf
    then
        Echo_ALERT "Proxychains-ng installed"
    else
        echo -e "\033[1;33m\n>> Do you need to install proxychains-ng from ffffffff0x.com [Y/n,Default Y]\033[0m" && read -r input

        case $input in
            [nN][oO]|[nN])
                cd $T_Dir && rm -rf proxychains-ng* > /dev/null 2>&1 && git clone --depth 1 ${GitProxy}https://github.com/rofl0r/proxychains-ng.git $T_Dir/proxychains-ng > /dev/null 2>&1 && Echo_INFOR "Downloaded from github.com" || Echo_ERROR "Download failed"
                ;;
            *)
                cd $T_Dir && rm -rf proxychains-ng* > /dev/null 2>&1 && wget -O proxychains-ng.zip "$Proxy_URL" > /dev/null 2>&1 && Echo_INFOR "Downloaded from ffffffff0x.com" || Echo_ERROR "Download failed"
                unzip proxychains-ng.zip > /dev/null 2>&1 && rm -f proxychains-ng.zip > /dev/null 2>&1
                mv --force proxychains-ng-master proxychains-ng
                ;;
        esac

        chmod -R 777 $T_Dir/proxychains-ng > /dev/null 2>&1
        cd $T_Dir/proxychains-ng && chmod +x configure > /dev/null 2>&1
        ./configure > /dev/null 2>&1
        chmod +x ./tools/install.sh > /dev/null 2>&1
        make > /dev/null 2>&1 && make install > /dev/null 2>&1
        cp $T_Dir/proxychains-ng/src/proxychains.conf /etc/proxychains.conf
        cd .. && rm -rf proxychains-ng > /dev/null 2>&1
        vim /etc/proxychains.conf
        Echo_INFOR "Successfully installed Proxychains-ng, the configuration file is /etc/proxychains.conf"
    fi

}

# ===================== pip proxy =====================
pip_Proxy(){

mkdir -p ~/.pip/

if [ $1 == aliyun ] 2>> /tmp/f8x_error.log
then

tee ~/.pip/pip.conf <<-'EOF'
[global]
index-url = https://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com
EOF

else

tee ~/.pip/pip.conf <<-'EOF'
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple/

[install]
trusted-host=https://pypi.tuna.tsinghua.edu.cn
EOF

fi

}

# ===================== docker proxy =====================
Docker_Proxy(){

mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]
}
EOF

}

# ===================== Install basic tools =====================
Base_Tools(){

    case $Linux_Version in
        *"CentOS"*)
            Update_EPEL_Mirror
            ;;
        *"AlmaLinux"*)
            Rm_Lock
            Install_Switch "epel-release"
            ;;
        *"VzLinux"*)
            Rm_Lock
            Install_Switch "epel-release"
            ;;
        *"Rocky"*)
            Rm_Lock
            Install_Switch "epel-release"
            ;;
        *) ;;
    esac

    Rm_Lock

    case $Linux_Version in
        *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
            Install_Switch "yum-utils"
            Install_Switch "dnf"
            Install_Switch "gcc-c++"
            Install_Switch "glibc-headers"
            Install_Switch "openssl-devel"
            Install_Switch "kernel-devel"
            yum upgrade -y wget > /dev/null 2>&1
            ;;
        *"Kali"*|*"Ubuntu"*|*"Debian"*)
            apt-get update > /dev/null 2>&1
            Install_Switch "zip"
            Install_Switch "apt-transport-https"
            Install_Switch "ca-certificates"
            Install_Switch "p7zip-full"
            Install_Switch "libssl-dev"
            Install_Switch "libssh2-1-dev"
            Install_Switch "aptitude"
            Install_Switch "libcurl4-openssl-dev"
            Install_Switch "apt-file"
            Install_Switch "g++"
            ;;
        *) ;;
    esac

    Install_Switch "vim"
    Install_Switch "make"
    Install_Switch "cmake"
    Install_Switch "gcc"
    Install_Switch "git"
    Install_Switch "curl"
    Install_Switch "wget"
    Install_Switch "lrzsz"
    Install_Switch "unzip"
    Install_Switch "p7zip"
    Install_Switch "jq"
    Install_Switch "openssl"
    Install_Switch "unhide"
    Install_Switch "net-tools"
    Install_Switch "dos2unix"
    Install_Switch "tmux"

}

# ===================== Install development environment dependencies =====================
Dev_Base_Install(){

    if test -e /tmp/f8x_Dev_Base.txt
    then
        Echo_ALERT "Dependent installation records are detected, skip this step"
    else
        echo -e "\033[1;33m\n>> Installing development environment dependencies\n\033[0m"

        Rm_Lock
        Install_Switch "tree"
        Install_Switch "tcpdump"
        case $Linux_Version in
            *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                yum groupinstall -y "Development Tools" > /dev/null 2>&1 && Echo_INFOR "Successfully installed Development Tools" || Echo_ERROR "Failed to install Development Tools"
                ;;
            *"Kali"*|*"Ubuntu"*|*"Debian"*)
                Install_Switch "software-properties-common"
                Install_Switch "build-essential"
                Install_Switch "xfonts-intl-chinese"
                Install_Switch "ttf-wqy-microhei"
                Install_Switch "ttf-wqy-zenhei"
                Install_Switch "xfonts-wqy"
                Install_Switch "nethogs"
                ;;
            *)
                ;;
        esac

        touch /tmp/f8x_Dev_Base.txt > /dev/null 2>&1
    fi

}

# ===================== Install Python and pip =====================
Python3_Install(){

    name="Python3"

    case "$1" in
        py37)
            pyenv_Install
            Python37_Install_with_pyenv
            # Python37_Install
            ;;
        py38)
            pyenv_Install
            Python38_Install_with_pyenv
            # Python38_Install
            ;;
        py39)
            pyenv_Install
            Python39_Install_with_pyenv
            # Python39_Install
            ;;
        py310)
            pyenv_Install
            Python310_Install_with_pyenv
            # Python310_Install
            ;;
        *)
            Python3_def_Install
            ;;
    esac

}

pyenv_Install(){

    name="pyenv"
    dir="$T_Dir/.pyenv"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    which pyenv > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_INFOR "$name installed"
    else
        if test -d $dir
        then
            Echo_ALERT "$name is already installed in $dir"
        else
            Base_Tools

            Dev_Base_Install

            case $Linux_Version in
                *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                    Install_Switch "bzip2"
                    Install_Switch "bzip2-devel"
                    Install_Switch "readline-devel"
                    Install_Switch "sqlite"
                    Install_Switch "sqlite-devel"
                    Install_Switch "openssl-devel"
                    Install_Switch "tk-devel"
                    Install_Switch "libffi-devel"
                    Install_Switch "xz-devel"
                    Install_Switch "zlib-devel"
                    ;;
                *"Kali"*|*"Ubuntu"*|*"Debian"*)
                    Install_Switch "zlib1g-dev"
                    Install_Switch "libbz2-dev"
                    Install_Switch "libedit-dev"
                    Install_Switch "libncurses5-dev"
                    Install_Switch "libreadline-dev"
                    Install_Switch "libsqlite3-dev"
                    Install_Switch "llvm"
                    Install_Switch "libncursesw5-dev"
                    Install_Switch "xz-utils"
                    Install_Switch "tk-dev"
                    Install_Switch "libffi-dev"
                    Install_Switch "liblzma-dev"
                    ;;
                *) ;;
            esac

            $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/pyenv/pyenv.git $dir > /dev/null 2>&1 && Echo_INFOR "Successfully installed pyenv, environment variables may need to be re-entered in bash to take effect\nexport PYENV_ROOT=\"$T_Dir/.pyenv\"\ncommand -v pyenv >/dev/null || export PATH=\"\$PYENV_ROOT/bin:\$PATH\"\neval \"\$(pyenv init -)\"" || Echo_ERROR2

            case $Linux_Version in
                *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                    echo "export PYENV_ROOT=\"$T_Dir/.pyenv\"" >> /etc/bashrc
                    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> /etc/bashrc
                    echo 'eval "$(pyenv init -)"' >> /etc/bashrc
                    ;;
                *"Kali"*|*"Ubuntu"*|*"Debian"*)
                    echo "export PYENV_ROOT=\"$T_Dir/.pyenv\"" >> /etc/bash.bashrc
                    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> /etc/bash.bashrc
                    echo 'eval "$(pyenv init -)"' >> /etc/bash.bashrc
                    ;;
                *) ;;
            esac
        fi
    fi

}

Python3_def_Install(){

    Rm_Lock
    Install_Switch "python3"
    case $Linux_Version in
        *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
            Install_Switch "python3-devel"
            Install_Switch "python3-pip"
            python3 -m pip install --upgrade pip > /dev/null 2>&1 && Echo_INFOR "Updated python3-pip" || Echo_ERROR "Update python3-pip failed"

            Install_Switch4 "setuptools"
            Install_Switch4 "virtualenv"
            ;;
        *"Kali"*|*"Debian"*)
            apt-get update > /dev/null 2>&1
            Install_Switch "python3-dev"
            Install_Switch "python3-pip"
            Install_Switch "python3-venv"
            Install_Switch "python3-distutils"
            python3 -m pip install --upgrade pip > /dev/null 2>&1 && Echo_INFOR "Updated python3-pip" || Echo_ERROR "Update python3-pip failed"
            ;;
        *"Ubuntu"*)
            apt-get update > /dev/null 2>&1
            Install_Switch "python3-dev"
            Install_Switch "python3-pip"
            Install_Switch "python3-venv"
            Install_Switch "python3-distutils"
            case $Linux_Version_Num in
                "16.04")
                    cd /tmp && rm -rf get-pip.py && $Proxy_OK wget https://bootstrap.pypa.io/pip/3.5/get-pip.py > /dev/null 2>&1
                    $Proxy_OK python3 get-pip.py > /dev/null 2>&1 && rm -rf get-pip.py
                    ;;
            esac
            python3 -m pip install --upgrade pip > /dev/null 2>&1 && Echo_INFOR "Updated python3-pip" || Echo_ERROR "Update python3-pip failed"
            ;;
        *)
            ;;
    esac

}

Python37_Install_with_pyenv(){

    name="Python3.7"

    export PYENV_ROOT="$T_Dir/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH" > /dev/null 2>&1
    eval "$(pyenv init -)" > /dev/null 2>&1

    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    if [ "$(pyenv versions | grep $py37_ver)" ]
    then
        Echo_INFOR "$name installed, Please run the following command:\npyenv global $py37_ver && pyenv local $py37_ver"
        pyenv global $py37_ver && pyenv local $py37_ver
    else
        mkdir -p ~/.pyenv/cache/ && cd $_ && rm -f $py37_bin && $Proxy_OK wget https://www.python.org/ftp/python/$py37_ver/$py37_bin ${wget_option} && Echo_INFOR "Downloaded from python.org" || Echo_ERROR "download failed, please check if the network is reachable, proxychains4 configuration is correct"
        pyenv install $py37_ver && pyenv global $py37_ver && pyenv local $py37_ver && Echo_INFOR "Successfully installed Python, Please run the following command:\npyenv global $py37_ver && pyenv local $py37_ver"
        rm -rf $py37_bin
    fi

}

Python37_Install(){

    name="Python3.7"
    mkdir -p /tmp/py37 && cd $_ && rm -f $py37_bin && $Proxy_OK wget https://www.python.org/ftp/python/$py37_ver/$py37_bin ${wget_option} && Echo_INFOR "Downloaded from python.org" || Echo_ERROR "download failed, please check if the network is reachable, proxychains4 configuration is correct"
    tar -xvJf $py37_bin > /dev/null 2>&1 && cd $py37_dir
    Echo_INFOR "configure"
    ./configure --prefix=/usr/local/python3 > /dev/null 2>&1
    Echo_INFOR "make"
    make > /dev/null 2>&1
    Echo_INFOR "make install"
    make install > /dev/null 2>&1

    rm -f /usr/bin/python3
    ln -s /usr/local/python3/bin/python3 /usr/bin/python3
    python3 -V > /dev/null 2>&1 && Echo_INFOR "Installation Location : /usr/local/python3" || Echo_ERROR3
    Echo_INFOR "py3 output: $(python3 -V)"

    case $Linux_Version in
        *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
            echo "PATH=\$PATH:/usr/local/python3/bin" >> /etc/bashrc
            ;;
        *"Kali"*|*"Ubuntu"*|*"Debian"*)
            echo "PATH=\$PATH:/usr/local/python3/bin" >> /etc/bash.bashrc
            ;;
        *) ;;
    esac

    rm -f /usr/bin/lsb_release > /dev/null 2>&1
    python3 -m ensurepip > /dev/null 2>&1
    python3 -m pip install --upgrade pip > /dev/null 2>&1

    Echo_INFOR "pip3 output: $(pip3 -V)"
    rm -rf /tmp/py37

}

Python38_Install_with_pyenv(){

    name="Python3.8"

    export PYENV_ROOT="$T_Dir/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH" > /dev/null 2>&1
    eval "$(pyenv init -)" > /dev/null 2>&1

    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    if [ "$(pyenv versions | grep $py38_ver)" ]
    then
        Echo_INFOR "$name installed, Please run the following command:\npyenv global $py38_ver && pyenv local $py38_ver"
        pyenv global $py38_ver && pyenv local $py38_ver
    else
        mkdir -p ~/.pyenv/cache/ && cd $_ && rm -f $py38_bin && $Proxy_OK wget https://www.python.org/ftp/python/$py38_ver/$py38_bin ${wget_option} && Echo_INFOR "Downloaded from python.org" || Echo_ERROR "download failed, please check if the network is reachable, proxychains4 configuration is correct"
        pyenv install $py38_ver && pyenv global $py38_ver && pyenv local $py38_ver && Echo_INFOR "Successfully installed Python, Please run the following command:\npyenv global $py38_ver && pyenv local $py38_ver"
        rm -rf $py38_bin
    fi

}

Python38_Install(){

    name="Python3.8"
    mkdir -p /tmp/py38 && cd $_ && rm -f $py38_bin && $Proxy_OK wget https://www.python.org/ftp/python/$py38_ver/$py38_bin ${wget_option} && Echo_INFOR "Downloaded from python.org" || Echo_ERROR "download failed, please check if the network is reachable, proxychains4 configuration is correct"
    tar -xvJf $py38_bin > /dev/null 2>&1 && cd $py38_dir
    Echo_INFOR "configure"
    ./configure --prefix=/usr/local/python3 > /dev/null 2>&1
    Echo_INFOR "make"
    make > /dev/null 2>&1
    Echo_INFOR "make install"
    make install > /dev/null 2>&1

    rm -f /usr/bin/python3
    ln -s /usr/local/python3/bin/python3 /usr/bin/python3
    python3 -V > /dev/null 2>&1 && Echo_INFOR "Installation Location : /usr/local/python3" || Echo_ERROR3
    Echo_INFOR "py3 output: $(python3 -V)"

    case $Linux_Version in
        *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
            echo "PATH=\$PATH:/usr/local/python3/bin" >> /etc/bashrc
            ;;
        *"Kali"*|*"Ubuntu"*|*"Debian"*)
            echo "PATH=\$PATH:/usr/local/python3/bin" >> /etc/bash.bashrc
            ;;
        *) ;;
    esac

    rm -f /usr/bin/lsb_release > /dev/null 2>&1
    python3 -m ensurepip > /dev/null 2>&1
    python3 -m pip install --upgrade pip > /dev/null 2>&1

    Echo_INFOR "pip3 output: $(pip3 -V)"
    rm -rf /tmp/py38

}

Python39_Install_with_pyenv(){

    name="Python3.9"

    export PYENV_ROOT="$T_Dir/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH" > /dev/null 2>&1
    eval "$(pyenv init -)" > /dev/null 2>&1

    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    if [ "$(pyenv versions | grep $py39_ver)" ]
    then
        Echo_INFOR "$name installed, Please run the following command:\npyenv global $py39_ver && pyenv local $py39_ver"
        pyenv global $py39_ver && pyenv local $py39_ver
    else
        mkdir -p ~/.pyenv/cache/ && cd $_ && rm -f $py39_bin && $Proxy_OK wget https://www.python.org/ftp/python/$py39_ver/$py39_bin ${wget_option} && Echo_INFOR "Downloaded from python.org" || Echo_ERROR "download failed, please check if the network is reachable, proxychains4 configuration is correct"
        pyenv install $py39_ver && pyenv global $py39_ver && pyenv local $py39_ver && Echo_INFOR "Successfully installed Python, Please run the following command:\npyenv global $py39_ver && pyenv local $py39_ver"
        rm -rf $py39_bin
    fi

}

Python39_Install(){

    name="Python3.9"
    mkdir -p /tmp/py39 && cd $_ && rm -f $py39_bin && $Proxy_OK wget https://www.python.org/ftp/python/$py39_ver/$py39_bin ${wget_option} && Echo_INFOR "Downloaded from python.org" || Echo_ERROR "download failed, please check if the network is reachable, proxychains4 configuration is correct"
    tar -xvJf $py39_bin > /dev/null 2>&1 && cd $py39_dir
    Echo_INFOR "configure"
    ./configure --prefix=/usr/local/python3 > /dev/null 2>&1
    Echo_INFOR "make"
    make > /dev/null 2>&1
    Echo_INFOR "make install"
    make install > /dev/null 2>&1

    rm -f /usr/bin/python3
    ln -s /usr/local/python3/bin/python3 /usr/bin/python3
    python3 -V > /dev/null 2>&1 && Echo_INFOR "Installation Location : /usr/local/python3" || Echo_ERROR3
    Echo_INFOR "py3 output: $(python3 -V)"

    case $Linux_Version in
        *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
            echo "PATH=\$PATH:/usr/local/python3/bin" >> /etc/bashrc
            ;;
        *"Kali"*|*"Ubuntu"*|*"Debian"*)
            echo "PATH=\$PATH:/usr/local/python3/bin" >> /etc/bash.bashrc
            ;;
        *) ;;
    esac

    rm -f /usr/bin/lsb_release > /dev/null 2>&1
    python3 -m ensurepip > /dev/null 2>&1
    python3 -m pip install --upgrade pip > /dev/null 2>&1

    Echo_INFOR "pip3 output: $(pip3 -V)"
    rm -rf /tmp/py39

}

Python310_Install_with_pyenv(){

    name="Python3.10"

    export PYENV_ROOT="$T_Dir/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH" > /dev/null 2>&1
    eval "$(pyenv init -)" > /dev/null 2>&1

    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    if [ "$(pyenv versions | grep $py310_ver)" ]
    then
        Echo_INFOR "$name installed, Please run the following command:\npyenv global $py310_ver && pyenv local $py310_ver"
        pyenv global $py310_ver && pyenv local $py310_ver
    else
        mkdir -p ~/.pyenv/cache/ && cd $_ && rm -f $py310_bin && $Proxy_OK wget https://www.python.org/ftp/python/$py310_ver/$py310_bin ${wget_option} && Echo_INFOR "Downloaded from python.org" || Echo_ERROR "download failed, please check if the network is reachable, proxychains4 configuration is correct"
        pyenv install $py310_ver && pyenv global $py310_ver && pyenv local $py310_ver && Echo_INFOR "Successfully installed Python, Please run the following command:\npyenv global $py310_ver && pyenv local $py310_ver"
        rm -rf $py310_bin
    fi

}

Python310_Install(){

    name="Python3.10"
    mkdir -p /tmp/py310 && cd $_ && rm -f $py310_bin && $Proxy_OK wget https://www.python.org/ftp/python/$py310_dir/$py310_bin ${wget_option} && Echo_INFOR "Downloaded from python.org" || Echo_ERROR "download failed, please check if the network is reachable, proxychains4 configuration is correct"
    tar -xvJf $py310_bin > /dev/null 2>&1 && cd $py310_dir
    Echo_INFOR "configure"
    ./configure --prefix=/usr/local/python3 > /dev/null 2>&1
    Echo_INFOR "make"
    make > /dev/null 2>&1
    Echo_INFOR "make install"
    make install > /dev/null 2>&1

    rm -f /usr/bin/python3
    ln -s /usr/local/python3/bin/python3 /usr/bin/python3
    python3 -V > /dev/null 2>&1 && Echo_INFOR "Installation Location : /usr/local/python3" || Echo_ERROR3
    Echo_INFOR "py3 output: $(python3 -V)"

    case $Linux_Version in
        *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
            echo "PATH=\$PATH:/usr/local/python3/bin" >> /etc/bashrc
            ;;
        *"Kali"*|*"Ubuntu"*|*"Debian"*)
            echo "PATH=\$PATH:/usr/local/python3/bin" >> /etc/bash.bashrc
            ;;
        *) ;;
    esac

    rm -f /usr/bin/lsb_release > /dev/null 2>&1
    python3 -m ensurepip > /dev/null 2>&1
    python3 -m pip install --upgrade pip > /dev/null 2>&1

    Echo_INFOR "pip3 output: $(pip3 -V)"
    rm -rf /tmp/py310

}

# -go
Go_Option(){

    name="go"
    which go > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Go_Version=$(curl -L -s https://golang.org/VERSION?m=text)
        if test -e /tmp/IS_CI
        then
            input="y"
        else
            Echo_ALERT "已安装 $(go version),是否升级至 $Go_Version? [y/N,默认No]" && read -r input
        fi

        case $input in
            [yY][eE][sS]|[Yy])
                case $Linux_architecture_Name in
                    *"linux-x86_64"*)
                        Go_Bin="${Go_Version}.linux-amd64.tar.gz"
                        ;;
                    *"linux-arm64"*)
                        Go_Bin="${Go_Version}.linux-arm64.tar.gz"
                        ;;
                esac

                rm -rf /usr/bin/go > /dev/null 2>&1
                rm -rf /usr/local/go > /dev/null 2>&1
                Echo_ALERT "Downloading Go (~120M)" && $Proxy_OK wget -O $T_Dir/$Go_Bin ${GitProxy2}https://golang.org/dl/$Go_Bin ${wget_option} && tar -C /usr/local -xzf $T_Dir/$Go_Bin && Echo_INFOR "Downloaded from golang.org" || { Echo_ERROR "download failed, please check if the network is reachable, proxychains4 configuration is correct" ; rm -f ${T_Dir:?}/${Go_Bin} > /dev/null 2>&1; }
                ln -s /usr/local/go/bin/go /usr/bin/go > /dev/null 2>&1
                Echo_INFOR "$(go version)" || Echo_ERROR3
                rm -f ${T_Dir:?}/${Go_Bin} > /dev/null 2>&1
                ;;
            *)
                Echo_INFOR "Pass~"
                ;;
        esac
    else
        Go_Install
    fi

}

# ===================== Install Go =====================
Go_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            Go_Bin=$Go_Bin_amd64
            ;;
        *"linux-arm64"*)
            Go_Bin=$Go_Bin_arm64
            ;;
    esac

    name="go"
    which go > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        Echo_ALERT "Downloading Go (~120M)" && $Proxy_OK wget -O $T_Dir/$Go_Bin ${GitProxy2}https://golang.org/dl/$Go_Bin ${wget_option} && tar -C /usr/local -xzf $T_Dir/$Go_Bin && Echo_INFOR "Downloaded from golang.org" || Echo_ERROR "download failed, please check if the network is reachable, proxychains4 configuration is correct"

        case $Linux_Version in
            *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                #export PATH=\$PATH:/usr/local/go/bin
                #export GOROOT=/usr/local/go
                export GOPATH=$HOME/go

                echo "GOROOT=/usr/local/go" >> /etc/bashrc && Echo_INFOR "GOROOT : /usr/local/go"
                echo "GOBIN=\$GOROOT/bin" >> /etc/bashrc && Echo_INFOR "GOBIN : \$GOROOT/bin"
                echo "GOPATH=\$HOME/go" >> /etc/bashrc && Echo_INFOR "GOPATH : \$HOME/go"
                echo "PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin:\$GOBIN" >> /etc/bashrc
                source /etc/bashrc
                ;;
            *"Kali"*|*"Ubuntu"*|*"Debian"*)
                #export PATH=\$PATH:/usr/local/go/bin
                #export GOROOT=/usr/local/go
                export GOPATH=$HOME/go

                echo "GOROOT=/usr/local/go" >> /etc/bash.bashrc && Echo_INFOR "GOROOT : /usr/local/go"
                echo "GOBIN=\$GOROOT/bin" >> /etc/bash.bashrc && Echo_INFOR "GOBIN : \$GOROOT/bin"
                echo "GOPATH=\$HOME/go" >> /etc/bash.bashrc && Echo_INFOR "GOPATH : \$HOME/go"
                echo "PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin:\$GOBIN" >> /etc/bash.bashrc
                source /etc/bash.bashrc
                ;;
            *) ;;
        esac
        cd /tmp
        ln -s /usr/local/go/bin/go /usr/bin/go > /dev/null 2>&1
        Echo_INFOR "$(go version)" || Echo_ERROR3
        rm -f ${T_Dir:?}/${Go_Bin} > /dev/null 2>&1
    fi

}

# ===================== Install Docker =====================
Docker_Install(){

    name="Docker"
    which docker > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
        service docker start > /dev/null 2>&1
        systemctl start docker > /dev/null 2>&1
    else
        Rm_Lock
        case $Linux_Version in
            *"Fedora"*)
                Install_Switch "device-mapper-persistent-data"
                Install_Switch "lvm2"

                Echo_ALERT "Installing docker" && $Proxy_OK yum install -y docker > /dev/null 2>&1 && Echo_INFOR "Successfully installed docker" || Echo_ERROR "docker installation failed, please check if the network is reachable, proxychains4 configuration is correct"
                ;;
            *"CentOS"*|*"RedHat"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                Install_Switch "device-mapper-persistent-data"
                Install_Switch "lvm2"

                if [ $1 == tuna ] 2>> /tmp/f8x_error.log
                then
                    $Proxy_OK curl -o /etc/yum.repos.d/docker-ce.repo https://f8x.io/docker-ce.repo > /dev/null 2>&1 && Echo_INFOR "Finished downloading the docker yum source from aliyun.com" || Echo_ERROR "Failed to download docker yum source"
                else
                    $Proxy_OK curl -o /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/centos/docker-ce.repo > /dev/null 2>&1 && Echo_INFOR "Finished downloading the docker yum source from docker.com" || Echo_ERROR "Failed to download docker yum source"
                fi

                $Proxy_OK yum makecache > /dev/null 2>&1 || Echo_ERROR "yum Docker source update failed, please check if the network is reachable, proxychains4 configuration is correct"
                Rm_Lock
                Echo_ALERT "Installing docker" && $Proxy_OK yum install -y docker > /dev/null 2>&1 && Echo_INFOR "Successfully installed docker" || Echo_ERROR "docker installation failed, please check if the network is reachable, proxychains4 configuration is correct"
                ;;
            *"Kali"*|*"Ubuntu"*|*"Debian"*)
                Echo_INFOR "Uninstalling the Docker environment"
                apt-get remove -y docker > /dev/null 2>&1
                apt-get remove -y docker-engine > /dev/null 2>&1
                apt-get remove -y docker.io > /dev/null 2>&1
                Rm_Lock
                apt-get update > /dev/null 2>&1 || Echo_ERROR "Update apt package list failed"
                Install_Switch "apt-transport-https"
                Install_Switch "ca-certificates"
                Install_Switch "curl"
                Install_Switch "software-properties-common"
                Install_Switch "gnupg"

                if [ $1 == tuna ] 2>> /tmp/f8x_error.log
                then
                    $Proxy_OK curl -fsSL https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian/gpg | apt-key add -

                    case $Linux_Version in
                        *"Kali"*|*"Debian"*)
                            echo -e 'deb https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian' "$Linux_Version_Name" 'stable'> /etc/apt/sources.list.d/docker.list
                            ;;
                        *"Ubuntu"*)
                            echo -e 'deb https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu/' "$Linux_Version_Name" 'stable'> /etc/apt/sources.list.d/docker.list
                            ;;
                    esac
                else
                    $Proxy_OK curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

                    case $Linux_Version in
                        *"Kali"*|*"Debian"*)
                            echo -e 'deb https://download.docker.com/linux/debian' "$Linux_Version_Name" 'stable'> /etc/apt/sources.list.d/docker.list
                            ;;
                        *"Ubuntu"*)
                            echo -e 'deb https://download.docker.com/linux/ubuntu/' "$Linux_Version_Name" 'stable'> /etc/apt/sources.list.d/docker.list
                            ;;
                    esac
                fi

                Echo_INFOR "Updating apt package list" && apt-get update > /dev/null 2>&1 || Echo_ERROR "Update apt package list failed"

                Echo_ALERT "Installing docker" && $Proxy_OK apt-get install -y docker-ce > /dev/null 2>&1 && Echo_INFOR "Successfully installed docker-ce" || Echo_ERROR "docker-ce installation failed, please check if the network is reachable, proxychains4 configuration is correct"
                rm -f /etc/apt/sources.list.d/docker.list > /dev/null 2>&1
                ;;
            *)
                ;;
        esac

        service docker start > /dev/null 2>&1
        systemctl start docker > /dev/null 2>&1 && Echo_INFOR "docker service is started" || Echo_ERROR "docker service startup failed"
        systemctl enable docker > /dev/null 2>&1 && Echo_INFOR "Configure the docker service to start on boot" || Echo_ERROR "Failed to configure boot items"
    fi

    docker-compose -version > /dev/null 2>&1
    if [ $? == 0 ]
    then
        Echo_ALERT "docker-compose installed"
    else
        pip3_Check && pip3 install --upgrade pip > /dev/null 2>&1
        Install_Switch4 "docker-compose"
    fi

}

# ===================== Install SDKMAN =====================
SDKMAN_Install(){

    name="SDKMAN"
    sdk version > /dev/null 2>&1
    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && $Proxy_OK curl -o sdkman.sh "https://get.sdkman.io" > /dev/null 2>&1 && $Proxy_OK bash sdkman.sh > /dev/null 2>&1
        source "/root/.sdkman/bin/sdkman-init.sh"
        sdk version && Echo_INFOR "Successfully installed $name" || Echo_ERROR3

        rm -f /tmp/sdkman.sh > /dev/null 2>&1
    fi

}

# ===================== Install Terraform =====================
Terraform_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            Terraform_bin=$Terraform_bin_amd64
            ;;
        *"linux-arm64"*)
            Terraform_bin=$Terraform_bin_arm64
            ;;
    esac

    name="terraform"
    which terraform > /dev/null 2>&1
    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        Echo_ALERT "Downloading $name"
        cd /tmp && $Proxy_OK wget https://releases.hashicorp.com/terraform/$Terraform_Ver/$Terraform_bin > /dev/null 2>&1 && Echo_INFOR "Downloaded from hashicorp.com" || Echo_ERROR2
        unzip $Terraform_bin > /dev/null 2>&1
        mv --force terraform /usr/local/bin/terraform > /dev/null 2>&1 && chmod +x /usr/local/bin/terraform && Echo_INFOR "Successfully installed $name $Terraform_Ver" || Echo_ERROR3
        rm -rf $Terraform_bin
    fi

}

# ===================== Install aliyun-cli =====================
aliyun-cli_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            aliyun_cli_bin=$aliyun_cli_bin_amd64
            ;;
        *"linux-arm64"*)
            aliyun_cli_bin=$aliyun_cli_bin_arm64
            ;;
    esac

    name="aliyun"
    which aliyun > /dev/null 2>&1
    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/aliyun-cli && cd /tmp/aliyun-cli && $Proxy_OK wget https://github.com/aliyun/aliyun-cli/releases/download/$aliyun_cli_Ver/$aliyun_cli_bin > /dev/null 2>&1 || Echo_ERROR2
        tar zxvf $aliyun_cli_bin > /dev/null 2>&1
        mv --force aliyun /usr/local/bin/aliyun > /dev/null 2>&1 && chmod +x /usr/local/bin/aliyun && Echo_INFOR "Successfully installed $name $aliyun-cli_Ver" || Echo_ERROR3
        rm -rf /tmp/aliyun-cli
    fi

}

# ===================== Install aws-cli =====================
aws-cli_Install(){

    name="aws"
    which aws > /dev/null 2>&1
    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        Echo_ALERT "Downloading $name"
        mkdir -p /tmp/aws-cli && cd /tmp/aws-cli && $Proxy_OK curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" > /dev/null 2>&1 || Echo_ERROR2
        unzip awscliv2.zip > /dev/null 2>&1
        ./aws/install && Echo_INFOR "Successfully installed $name" || Echo_ERROR3
        rm -rf /tmp/aws-cli
    fi

}

# ===================== Install Serverless_Framework =====================
Serverless_Framework_Install(){

    name="Serverless Framework"

    which serverless > /dev/null 2>&1
    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        npm config set prefix /usr/local
        $Proxy_OK npm install -g serverless
        serverless -v && Echo_INFOR "Successfully installed $name" || Echo_ERROR3
    fi

}

# ===================== Install wrangler =====================
wrangler_Install(){

    name="wrangler"

    which wrangler > /dev/null 2>&1
    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        $Proxy_OK cargo install wrangler
        wrangler -V && Echo_INFOR "Successfully installed $name" || Echo_ERROR3
    fi

}

# ===================== Install SSH =====================
SSH_Tools(){

    case $Linux_Version in
        *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
            Echo_INFOR "RedHat is available by default, this item Pass"
            ;;
        *"Kali"*|*"Debian"*)
            Rm_Lock
            Install_Switch "ssh"
            echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
            yes|ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key > /dev/null 2>&1
            yes|ssh-keygen -t dsa -f /etc/ssh/ssh_host_rsa_key > /dev/null 2>&1
            systemctl start ssh > /dev/null 2>&1 && Echo_INFOR "SSH initialization completed" || Echo_ERROR "SSH initialization failed"
            systemctl enable ssh > /dev/null 2>&1 && Echo_INFOR "SSH configuration boot-up" || Echo_ERROR "SSH configuration boot failure"
            ;;
        *"Ubuntu"*)
            Rm_Lock
            echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
            yes|ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key > /dev/null 2>&1
            yes|ssh-keygen -t dsa -f /etc/ssh/ssh_host_rsa_key > /dev/null 2>&1
            apt remove -y openssh-server > /dev/null 2>&1
            apt remove -y ssh > /dev/null 2>&1
            Install_Switch "openssh-server"
            Install_Switch "ssh"
            systemctl start ssh > /dev/null 2>&1 && Echo_INFOR "SSH initialization completed" || Echo_ERROR "SSH initialization failed"
            systemctl enable ssh > /dev/null 2>&1 && Echo_INFOR "SSH configuration boot-up" || Echo_ERROR "SSH configuration boot failure"
            ;;
        *) ;;
    esac

}

# ===================== pentest directory detection =====================
Pentest_Base_Install(){

    if test -d $P_Dir
    then
        Echo_ALERT "$P_Dir folder already exists"
    else
        mkdir -p $P_Dir && Echo_INFOR "$P_Dir folder created"
    fi

}

# ===================== AboutSecurity dictionary library =====================
Pentest_Dic_Install(){

    name="AboutSecurity"

    if test -d $P_Dir/$name
    then
        Echo_ALERT "$name dictionary already exists"
    else
        rm -rf $P_Dir/$name > /dev/null 2>&1 && $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/ffffffff0x/AboutSecurity.git $P_Dir/$name > /dev/null 2>&1 && Echo_INFOR "Downloaded $name in the $P_Dir/$name" || Echo_ERROR "Failed to download the $name dictionary from github"
    fi

}

# ===================== Install pentest misc tools =====================
Pentest_Misc_Install(){

    if test -e /tmp/f8x_misc.txt
    then
        Echo_ALERT "Tool installation record is detected, skip this step"
    else
        Rm_Lock
        Install_Switch "parallel"
        Install_Switch "rlwrap"
        Install_Switch "yara"
        touch /tmp/f8x_misc.txt > /dev/null 2>&1
    fi

}

# ===================== Install pentest pip module =====================
Pentest_pip_Install(){

    if test -e /tmp/f8x_pip.txt
    then
        Echo_ALERT "pip module record detected, skip this step"
    else
        python3 -m pip install --upgrade pip > /dev/null 2>&1 && Echo_INFOR "Updated python3-pip" || Echo_ERROR "python3-pip update failed"
        Install_Switch4 "PyJWT"
        Install_Switch4 "pyshark"
        Install_Switch4 "requests"
        Install_Switch4 "sqlparse"
        Install_Switch4 "threadpool"
        Install_Switch4 "urllib3"
        Install_Switch4 "lxml"
        Install_Switch4 "pyzbar"
        Install_Switch4 "bs4"
        Install_Switch4 "ftfy"
        Install_Switch4 "updog"
        pip3 install pefile > /dev/null 2>&1
        Install_Switch3 "yara"
        Install_Switch3 "pycrypto"
        Install_Switch3 "openpyxl"
        python2 -m pip install ujson > /dev/null 2>&1
        Install_Switch3 "Crypto"
        Install_Switch3 "pycryptodome"
        Install_Switch3 "pytz"
        python2 -m pip install pefile > /dev/null 2>&1
        touch /tmp/f8x_pip.txt > /dev/null 2>&1
    fi

}

# ===================== Install nmap =====================
Pentest_nmap_Install(){

    name="nmap"

    which nmap > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        Rm_Lock
        Install_Switch "nmap"
    fi

}

# ===================== Install ffuf =====================
Pentest_ffuf_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            ffuf_Install=$ffuf_Install_amd64
            ;;
        *"linux-arm64"*)
            ffuf_Install=$ffuf_Install_arm64
            ;;
    esac

    name="ffuf"
    which ffuf > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && rm -f $ffuf_Install > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/ffuf/ffuf/releases/download/$ffuf_Ver/$ffuf_Install > /dev/null 2>&1 || Echo_ERROR2
        tar -zxvf $ffuf_Install > /dev/null 2>&1
        mv --force ffuf /usr/local/bin/ && chmod +x /usr/local/bin/ffuf && rm -f /tmp/$ffuf_Install > /dev/null 2>&1
        ffuf -V > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $ffuf_Ver in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# ===================== Install JSFinder =====================
Pentest_JSFinder_Install(){

    name="JSFinder"
    dir="$P_Dir/JSFinder"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        $Proxy_OK git clone ${GitProxy}https://github.com/Threezh1/JSFinder.git $dir > /dev/null 2>&1 && cd $dir || Echo_ERROR2
        python3 JSFinder.py -h > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

}

# ===================== Install SecretFinder =====================
Pentest_SecretFinder_Install(){

    name="SecretFinder"
    dir="$P_Dir/SecretFinder"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        $Proxy_OK git clone ${GitProxy}https://github.com/m4ll0k/SecretFinder.git $dir > /dev/null 2>&1 && cd $dir || Echo_ERROR2
        pip3 install -r requirements.txt > /dev/null 2>&1 && Echo_INFOR "Installed dependency modules" || { Echo_ERROR "Failed to install dependency module"; rm -rf $dir; }
        python3 SecretFinder.py -h > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

}

# ===================== Install OneForAll =====================
Pentest_OneForAll_Install(){

    name="OneForAll"
    dir="$P_Dir/OneForAll"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        Install_Switch5 "setuptools"
        Install_Switch5 "wheel"
        $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/shmilylty/OneForAll.git $dir > /dev/null 2>&1 && cd $dir || Echo_ERROR "$name download failed, please check if the network is reachable, proxychains4 configuration is correct, or download using gitee git clone https://gitee.com/shmilylty/OneForAll.git "
        Echo_ALERT "Installing dependency modules\033[0m" && pip3 install -r requirements.txt > /dev/null 2>&1 || { Echo_ERROR "Failed to install dependency module"; rm -rf $dir; }
        python3 oneforall.py version > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" && aarch64_massdns_Install || Echo_ERROR3
    fi

}

aarch64_massdns_Install(){

    case $Linux_architecture_Name in
        *"linux-arm64"*)
            mkdir -p /tmp/massdns && cd $_
            $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/blechschmidt/massdns.git > /dev/null 2>&1
            cd /tmp/massdns/massdns && make > /dev/null 2>&1
            mv /tmp/massdns/massdns/bin/massdns $P_Dir/OneForAll/thirdparty/massdns/massdns_linux_aarch64 && Echo_INFOR "Successfully installed massdns in the $P_Dir/OneForAll/thirdparty/massdns/" && rm -rf /tmp/massdns
            ;;
    esac

}

# ===================== Install ksubdomain =====================
Pentest_ksubdomain_Install(){

    name="ksubdomain"

    which ksubdomain > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        case $Linux_architecture_Name in
            *"linux-x86_64"*)
                cd $T_Dir && rm -f ${ksubdomain_Install} > /dev/null 2>&1 && rm -rf ksubdomain > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/boy-hack/ksubdomain/releases/download/$ksubdomain_Ver/$ksubdomain_Install > /dev/null 2>&1 || Echo_ERROR2
                tar -xvf ${ksubdomain_Install} > /dev/null 2>&1
                mv --force ksubdomain /usr/local/bin/ksubdomain && chmod +x /usr/local/bin/ksubdomain && rm -f ${T_Dir:?}/${ksubdomain_Install} > /dev/null 2>&1
                ksubdomain > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $ksubdomain_Ver in the /usr/local/bin/" || Echo_ERROR3
                ;;
            *"linux-arm64"*)
                go install github.com/boy-hack/ksubdomain/cmd/ksubdomain@latest
                mv $GOPATH/bin/ksubdomain /usr/local/bin/ksubdomain && chmod +x /usr/local/bin/ksubdomain
                which ksubdomain > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the /usr/local/bin/" || Echo_ERROR3
                ;;
        esac
    fi

}

# ===================== Install masscan =====================
Pentest_masscan_Install(){

    name="masscan"

    which masscan > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        Rm_Lock
        Install_Switch "masscan"
    fi

}

# ===================== Install fscan =====================
Pentest_fscan_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            fscan_Install=$fscan_Install_amd64
            ;;
        *"linux-arm64"*)
            fscan_Install=$fscan_Install_arm64
            ;;
    esac

    name="fscan"
    which fscan > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && rm -f $fscan_Install > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/shadow1ng/fscan/releases/download/$fscan_Ver/$fscan_Install > /dev/null 2>&1 || Echo_ERROR2
        mv $fscan_Install fscan && mv --force fscan /usr/local/bin/fscan && chmod +x /usr/local/bin/fscan
        fscan > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $fscan_Ver in the /usr/local/bin/" || Echo_ERROR3
        rm -rf /tmp/fscan > /dev/null 2>&1
    fi

}

# ===================== Install fingerprintx =====================
Pentest_fingerprintx_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            fingerprintx_Install=$fingerprintx_Install_amd64
            ;;
        *"linux-arm64"*)
            fingerprintx_Install=$fingerprintx_Install_arm64
            ;;
    esac

    name="fingerprintx"
    which fingerprintx > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/fingerprintx && cd /tmp/fingerprintx && rm -f $fingerprintx_Install > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/praetorian-inc/fingerprintx/releases/download/$fingerprintx_Ver/$fingerprintx_Install > /dev/null 2>&1 || Echo_ERROR2
        tar -zxvf $fingerprintx_Install > /dev/null 2>&1
        mv --force fingerprintx /usr/local/bin/fingerprintx && chmod +x /usr/local/bin/fingerprintx
        which fingerprintx > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $fingerprintx_Ver in the /usr/local/bin/" || Echo_ERROR3
        rm -rf /tmp/fingerprintx > /dev/null 2>&1
    fi

}

# ===================== Install HostCollision =====================
Pentest_HostCollision_Install(){

    JDK_Check

    name="HostCollision"
    dir="$P_Dir/HostCollision"

    if test -e $dir/HostCollision.jar
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        mkdir -p $dir
        mkdir -p /tmp/HostCollision && cd /tmp/HostCollision && rm -f $HostCollision_Bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/pmiaowu/HostCollision/releases/download/$HostCollision_Ver/$HostCollision_Bin > /dev/null 2>&1 || Echo_ERROR2
        unzip $HostCollision_Bin > /dev/null 2>&1
        mv --force $HostCollision_dir/* $dir
        if test -e $dir/HostCollision.jar
        then
            Echo_INFOR "Successfully installed $name $HostCollision_Ver in the $dir"
        else
            Echo_ERROR3
        fi
        rm -rf /tmp/HostCollision > /dev/null 2>&1
    fi

}

# ===================== Install asnmap =====================
Pentest_asnmap_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            asnmap_bin=$asnmap_bin_amd64
            ;;
        *"linux-arm64"*)
            asnmap_bin=$asnmap_bin_arm64
            ;;
    esac

    name="asnmap"

    which asnmap > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/asnmap && cd /tmp/asnmap && rm -f $asnmap_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/projectdiscovery/asnmap/releases/download/$asnmap_Ver/$asnmap_bin > /dev/null 2>&1 || Echo_ERROR2
        tar -zxvf $asnmap_bin > /dev/null 2>&1
        mv --force asnmap /usr/local/bin/asnmap && chmod +x /usr/local/bin/asnmap
        which asnmap > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $asnmap_Ver in the /usr/local/bin/" || Echo_ERROR3
        rm -rf /tmp/asnmap
    fi

}

# ===================== Install tlsx =====================
Pentest_tlsx_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            tlsx_bin=$tlsx_bin_amd64
            ;;
        *"linux-arm64"*)
            tlsx_bin=$tlsx_bin_arm64
            ;;
    esac

    name="tlsx"

    which tlsx > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/tlsx && cd /tmp/tlsx && rm -f $tlsx_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/projectdiscovery/tlsx/releases/download/$tlsx_Ver/$tlsx_bin > /dev/null 2>&1 || Echo_ERROR2
        unzip $tlsx_bin > /dev/null 2>&1
        mv --force tlsx /usr/local/bin/tlsx && chmod +x /usr/local/bin/tlsx
        which tlsx > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $tlsx_Ver in the /usr/local/bin/" || Echo_ERROR3
        rm -rf /tmp/tlsx
    fi

}

# ===================== Install csprecon =====================
Pentest_csprecon_Install(){

    GO_Check

    name="csprecon"
    which csprecon > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && go install github.com/edoardottt/csprecon/cmd/csprecon@latest
        mv $GOPATH/bin/csprecon /usr/local/bin/csprecon && chmod +x /usr/local/bin/csprecon
        which csprecon > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# ===================== Install rad =====================
Pentest_rad_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            rad_File=$rad_File_amd64
            rad_bin=$rad_bin_amd64
            ;;
        *"linux-arm64"*)
            rad_File=$rad_File_arm64
            rad_bin=$rad_bin_arm64
            ;;
    esac

    name="rad"
    which rad > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/rad && cd /tmp/rad && rm -f ${rad_File} > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/chaitin/rad/releases/download/$rad_Ver/$rad_File > /dev/null 2>&1 || Echo_ERROR2
        unzip $rad_File > /dev/null 2>&1
        mv --force $rad_bin /usr/local/bin/rad && chmod +x /usr/local/bin/rad
        rm -rf /tmp/rad
        which rad > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $rad_Ver in the /usr/local/bin/" || Echo_ERROR3
        Echo_INFOR "$name needs to be used with chromium, you can install chromium with the -chromium option"
    fi

}

# ===================== Install crawlergo =====================
Pentest_crawlergo_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            crawlergo_File=$crawlergo_File_amd64
            ;;
        *"linux-arm64"*)
            crawlergo_File=$crawlergo_File_arm64
            ;;
    esac

    name="crawlergo"
    which crawlergo > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && rm -f $crawlergo_File > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/Qianlitp/crawlergo/releases/download/$crawlergo_Ver/$crawlergo_File > /dev/null 2>&1 || Echo_ERROR2
        # unzip $crawlergo_File > /dev/null 2>&1
        mv --force $crawlergo_File /usr/local/bin/crawlergo && chmod +x /usr/local/bin/crawlergo && rm -f /tmp/$crawlergo_File > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $crawlergo_Ver in the /usr/local/bin/" || Echo_ERROR3

        Echo_INFOR "$name needs to be used with chromium, you can install chromium with the -chromium option"
    fi

}

# ===================== Install katana =====================
Pentest_katana_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            katana_bin=$katana_bin_amd64
            ;;
        *"linux-arm64"*)
            katana_bin=$katana_bin_arm64
            ;;
    esac

    name="katana"
    which katana > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/katana && cd /tmp/katana && rm -f $katana_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/projectdiscovery/katana/releases/download/$katana_Ver/$katana_bin > /dev/null 2>&1 || Echo_ERROR2
        unzip $katana_bin > /dev/null 2>&1
        mv --force katana /usr/local/bin/katana && chmod +x /usr/local/bin/katana
        which katana > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $katana_Ver in the /usr/local/bin/" || Echo_ERROR3
        rm -rf /tmp/katana > /dev/null 2>&1
    fi

}

# ===================== Install Arjun =====================
Pentest_Arjun_Install(){

    name="Arjun"

    which arjun > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        Install_Switch4 "arjun"
    fi

}

# ===================== Install gospider =====================
Pentest_gospider_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            gospider_bin=$gospider_bin_amd64
            gospider_dir=$gospider_dir_amd64
            ;;
        *"linux-arm64"*)
            gospider_bin=$gospider_bin_arm64
            gospider_dir=$gospider_dir_arm64
            ;;
    esac

    name="gospider"
    which gospider > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/gospider && cd /tmp/gospider && rm -f ${gospider_bin} && rm -rf ${gospider_dir} && $Proxy_OK wget ${GitProxy}https://github.com/jaeles-project/gospider/releases/download/$gospider_Ver/$gospider_bin > /dev/null 2>&1 || Echo_ERROR2
        unzip ${gospider_bin} > /dev/null 2>&1
        mv --force ${gospider_dir}/gospider /usr/local/bin/gospider && chmod +x /usr/local/bin/gospider
        rm -rf /tmp/gospider
        which gospider > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $gospider_Ver in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# ===================== Install naabu =====================
Pentest_naabu_Install(){

    name="naabu"

    which naabu > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        case $Linux_architecture_Name in
            *"linux-x86_64"*)
                cd /tmp && rm -f $naabu_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/projectdiscovery/naabu/releases/download/$naabu_Ver/$naabu_bin > /dev/null 2>&1 || Echo_ERROR2
                unzip $naabu_bin > /dev/null 2>&1
                mv --force naabu /usr/local/bin/naabu && chmod +x /usr/local/bin/naabu && rm -f /tmp/$naabu_bin > /dev/null 2>&1
                naabu -version > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $naabu_Ver in the /usr/local/bin/" || Echo_ERROR3
                ;;
            *"linux-arm64"*)
                Rm_Lock
                case $Linux_Version in
                    *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                        Install_Switch "libpcap"
                        Install_Switch "libpcap-devel"
                        ;;
                    *"Kali"*|*"Ubuntu"*|*"Debian"*)
                        Install_Switch "libpcap-dev"
                        ;;
                    *) ;;
                esac
                cd /tmp && go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
                mv $GOPATH/bin/naabu /usr/local/bin/naabu && chmod +x /usr/local/bin/naabu
                which naabu > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the /usr/local/bin/" || Echo_ERROR3
                ;;
        esac
    fi

}

# ===================== Install httpx =====================
Pentest_httpx_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            httpx_bin=$httpx_bin_amd64
            ;;
        *"linux-arm64"*)
            httpx_bin=$httpx_bin_arm64
            ;;
    esac

    name="httpx"
    which httpx > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/httpx && cd /tmp/httpx && rm -f ${httpx_bin} && $Proxy_OK wget ${GitProxy}https://github.com/projectdiscovery/httpx/releases/download/$httpx_Ver/$httpx_bin > /dev/null 2>&1 || Echo_ERROR2
        unzip $httpx_bin > /dev/null 2>&1
        mv --force httpx /usr/local/bin/httpx && chmod +x /usr/local/bin/httpx
        rm -rf /tmp/httpx
        httpx -version > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $httpx_Ver in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# ===================== Install subfinder =====================
Pentest_subfinder_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            subfinder_bin=$subfinder_bin_amd64
            ;;
        *"linux-arm64"*)
            subfinder_bin=$subfinder_bin_arm64
            ;;
    esac

    name="subfinder"
    which subfinder > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && rm -f $subfinder_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/projectdiscovery/subfinder/releases/download/$subfinder_Ver/$subfinder_bin > /dev/null 2>&1 || Echo_ERROR2
        unzip $subfinder_bin > /dev/null 2>&1
        mv --force subfinder /usr/local/bin/subfinder && chmod +x /usr/local/bin/subfinder && rm -f /tmp/$subfinder_bin > /dev/null 2>&1
        subfinder -version > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $subfinder_Ver in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# ===================== Install gau =====================
Pentest_gau_Install(){

    name="gau"

    which gau > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        case $Linux_architecture_Name in
            *"linux-x86_64"*)
                cd /tmp && rm -f $gau_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/lc/gau/releases/download/$gau_Ver/$gau_bin > /dev/null 2>&1 || Echo_ERROR2
                tar -zxvf $gau_bin > /dev/null 2>&1
                mv --force gau /usr/local/bin/gau && chmod +x /usr/local/bin/gau && rm -f /tmp/$gau_bin > /dev/null 2>&1
                which gau > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $gau_Ver in the /usr/local/bin/" || Echo_ERROR3
                ;;
            *"linux-arm64"*)
                go install github.com/lc/gau/v2/cmd/gau@latest
                mv $GOPATH/bin/gau /usr/local/bin/gau && chmod +x /usr/local/bin/gau
                which gau > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the /usr/local/bin/" || Echo_ERROR3
                ;;
        esac
    fi

}

# ===================== Install apktool =====================
Pentest_apktool_Install(){

    JDK_Check

    name="apktool"

    which apktool > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && rm -f apktool && $Proxy_OK wget -O apktool ${GitProxy}https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool > /dev/null 2>&1 || Echo_ERROR2
        rm -f $apktool_bin && $Proxy_OK wget ${GitProxy}https://github.com/iBotPeaches/Apktool/releases/download/$apktool_Ver/$apktool_bin > /dev/null 2>&1 || Echo_ERROR2
        mv $apktool_bin apktool.jar && mv --force apktool.jar /usr/local/bin/apktool.jar && chmod +x /usr/local/bin/apktool.jar
        mv --force apktool /usr/local/bin/apktool && chmod +x /usr/local/bin/apktool
        which apktool > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $apktool_Ver in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# ===================== Install apkleaks =====================
Pentest_apkleaks_Install(){

    name="apkleaks"
    which apkleaks > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        Install_Switch4 "apkleaks"
    fi

}

# ===================== Install ApkAnalyser =====================
Pentest_ApkAnalyser_Install(){

    name="ApkAnalyser"
    dir="$P_Dir/"

    if test -e $P_Dir/apkAnalyser.py
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        Install_Switch4 "apkutils"
        $Proxy_OK curl -o $P_Dir/apkAnalyser.py https://cdn.jsdelivr.net/gh/TheKingOfDuck/ApkAnalyser/apkAnalyser.py > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

}

# ===================== Install Diggy =====================
Pentest_Diggy_Install(){

    name="Diggy"
    dir="$P_Dir/"

    if test -e $P_Dir/diggy.sh
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        cd $P_Dir && $Proxy_OK curl -o diggy.sh https://cdn.jsdelivr.net/gh/s0md3v/Diggy/diggy.sh > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

}

# ===================== Install AppInfoScanner =====================
Pentest_AppInfoScanner_Install(){

    name="AppInfoScanner"
    dir="$P_Dir/AppInfoScanner"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        $Proxy_OK git clone ${GitProxy}https://github.com/kelvinBen/AppInfoScanner.git $dir > /dev/null 2>&1 && Echo_INFOR "Downloaded $name" || Echo_ERROR2
        cd $dir && python3 -m pip install -r requirements.txt > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

}

# ===================== Install Amass =====================
Pentest_Amass_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            Amass_bin=$Amass_bin_amd64
            ;;
        *"linux-arm64"*)
            Amass_bin=$Amass_bin_arm64
            ;;
    esac

    name="Amass"
    which amass > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/Amass && cd /tmp/Amass && rm -rf ${Amass_bin} && rm -rf amass_linux_amd64 && $Proxy_OK wget ${GitProxy}https://github.com/OWASP/Amass/releases/download/$Amass_Ver/$Amass_bin > /dev/null 2>&1 || Echo_ERROR2
        unzip ${Amass_bin} > /dev/null 2>&1
        mv --force amass_linux_*/amass /usr/local/bin/amass && chmod +x /usr/local/bin/amass
        rm -rf /tmp/Amass
        which amass > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $Amass_Ver in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# ===================== Install gobuster =====================
Pentest_gobuster_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            gobuster_bin=$gobuster_bin_amd64
            ;;
        *"linux-arm64"*)
            gobuster_bin=$gobuster_bin_arm64
            ;;
    esac

    name="gobuster"

    which gobuster > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/gobuster && cd /tmp/gobuster && rm -f ${gobuster_bin} && rm -rf gobuster-linux-amd64 && $Proxy_OK wget ${GitProxy}https://github.com/OJ/gobuster/releases/download/$gobuster_Ver/$gobuster_bin > /dev/null 2>&1 || Echo_ERROR2
        tar -zxvf $gobuster_bin > /dev/null 2>&1 && rm -f $gobuster_bin > /dev/null 2>&1
        mv --force gobuster /usr/local/bin/gobuster && chmod +x /usr/local/bin/gobuster
        rm -rf /tmp/gobuster
        which gobuster > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $gobuster_Ver in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# ===================== Install dirsearch =====================
Pentest_dirsearch_Install(){

    name="dirsearch"
    dir="$P_Dir/dirsearch"

    if test -d $dir
    then
        Echo_ALERT "$name installed"
    else
        cd $P_Dir && $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/maurosoria/dirsearch.git > /dev/null 2>&1 || Echo_ERROR2
        cd $dir && pip3 install -r requirements.txt > /dev/null 2>&1
        if test -d $dir
        then
            Echo_INFOR "Successfully installed $name in the $dir"
        else
            Echo_ERROR3
        fi
    fi

}

# ===================== Install dismap =====================
Pentest_dismap_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            dismap_bin=$dismap_bin_amd64
            ;;
        *"linux-arm64"*)
            dismap_bin=$dismap_bin_arm64
            ;;
    esac

    name="dismap"
    which dismap > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && rm -f ${dismap_bin} && $Proxy_OK wget ${GitProxy}https://github.com/zhzyker/dismap/releases/download/$dismap_Ver/$dismap_bin > /dev/null 2>&1 || Echo_ERROR2
        mv --force $dismap_bin /usr/local/bin/dismap && chmod +x /usr/local/bin/dismap
        which dismap > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $dismap_Ver in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# ===================== Install htpwdScan =====================
Pentest_htpwdScan_Install(){

    name="htpwdScan"
    dir="$P_Dir/htpwdScan"

    if test -d $dir
    then
        Echo_ALERT "$name installed"
    else
        cd $P_Dir && $Proxy_OK git clone ${GitProxy}https://github.com/lijiejie/htpwdScan.git > /dev/null 2>&1 || Echo_ERROR2
        cd $dir && pip3 install -r requirements.txt > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

}

# ===================== Install WebCrack =====================
Pentest_WebCrack_Install(){

    name="WebCrack"
    dir="$P_Dir/WebCrack"

    if test -d $dir
    then
        Echo_ALERT "$name installed"
    else
        cd $P_Dir && $Proxy_OK git clone ${GitProxy}https://github.com/yzddmr6/WebCrack.git > /dev/null 2>&1 || Echo_ERROR2
        cd $dir && pip3 install -r requirements.txt > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

}

# ===================== Install netspy =====================
Pentest_netspy_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            netspy_bin=$netspy_bin_amd64
            ;;
        *"linux-arm64"*)
            netspy_bin=$netspy_bin_arm64
            ;;
    esac

    name="netspy"
    which netspy > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir /tmp/netspy && cd /tmp/netspy && $Proxy_OK wget ${GitProxy}https://github.com/shmilylty/netspy/releases/download/$netspy_Ver/$netspy_bin > /dev/null 2>&1 || Echo_ERROR2
        unzip $netspy_bin > /dev/null 2>&1
        mv --force $netspy_bin /usr/local/bin/netspy && chmod +x /usr/local/bin/netspy
        which netspy > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $netspy_Ver in the /usr/local/bin/" || Echo_ERROR3
        rm -rf /tmp/netspy
    fi

}

Pentest_zscan_Install(){

    name="zscan"
    which zscan > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        go install github.com/zyylhn/zscan@latest
        mv $GOPATH/bin/zscan /usr/local/bin/zscan && chmod +x /usr/local/bin/zscan
        which zscan > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# ===================== Install Metasploit =====================
Pentest_Metasploit_Install(){

    name="Metasploit"

    which msfconsole > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed , consider running 'msfupdate' to update to the latest version."
    else
        Rm_Lock
        cd /tmp && rm -f msfinstall > /dev/null 2>&1 && $Proxy_OK curl -o msfinstall https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > /dev/null 2>&1 && chmod 777 msfinstall
        Echo_ALERT "Downloading Metasploit" && $Proxy_OK ./msfinstall > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name" || Echo_ERROR3
        rm -f msfinstall > /dev/null 2>&1
    fi

}

# ===================== Install Sqlmap =====================
Pentest_Sqlmap_Install(){

    name="Sqlmap"
    dir="$P_Dir/sqlmap"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        Echo_ALERT "Downloading Sqlmap" && $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/sqlmapproject/sqlmap $dir > /dev/null 2>&1 || Echo_ERROR2
        cd $dir && Echo_INFOR "Successfully installed $name $(python3 sqlmap.py --version) in the $P_Dir/sqlmap" || Echo_ERROR3
    fi

}

# ===================== Install xray =====================
Pentest_xray_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            xray_File=$xray_File_amd64
            xray_bin=$xray_bin_amd64
            ;;
        *"linux-arm64"*)
            xray_File=$xray_File_arm64
            xray_bin=$xray_bin_arm64
            ;;
    esac

    name="xray"
    which xray > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/xray && cd /tmp/xray && rm -f $xray_File && $Proxy_OK wget ${GitProxy}https://github.com/chaitin/xray/releases/download/$xray_Ver/$xray_File > /dev/null 2>&1 || Echo_ERROR2
        unzip $xray_File > /dev/null 2>&1 && rm -f $xray_File && mv --force $xray_bin /usr/local/bin/xray && chmod +x /usr/local/bin/xray
        rm -rf /tmp/xray
        xray version > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $xray_Ver in the /usr/local/bin/" || Echo_ERROR3
    fi

    #name="xray poc"
    #dir="$P_Dir/xray"

    #if test -d $dir
    #then
        #Echo_ALERT "$name poc is already installed in $dir"
    #else
        #$Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/chaitin/xray.git $dir > /dev/null 2>&1 && Echo_INFOR "Downloaded $name poc in the $dir" || Echo_ERROR4 "chaitin/xray"
    #fi

}

# ===================== Install pocsuite3 =====================
Pentest_pocsuite3_Install(){

    name="pocsuite3"

    which pocsuite > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        Install_Switch4 "pocsuite3"
    fi

}

# ===================== Install Nuclei =====================
Pentest_Nuclei_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            Nuclei_Install=$Nuclei_Install_amd64
            ;;
        *"linux-arm64"*)
            Nuclei_Install=$Nuclei_Install_arm64
            ;;
    esac

    name="Nuclei"
    which nuclei > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && rm -f $Nuclei_Install > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/projectdiscovery/nuclei/releases/download/$Nuclei_Ver/$Nuclei_Install > /dev/null 2>&1 || Echo_ERROR2
        unzip $Nuclei_Install > /dev/null 2>&1
        mv --force nuclei /usr/local/bin/nuclei && chmod +x /usr/local/bin/nuclei && rm -f /tmp/$Nuclei_Install > /dev/null 2>&1
        which nuclei > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $Nuclei_Ver in the /usr/local/bin/" || Echo_ERROR3
    fi

}

Pentest_nuclei-templates_Install(){

    echo -e "\033[1;33m\n>> Updating nuclei-templates\n\033[0m"
    cd $P_Dir && $Proxy_OK nuclei -update-templates > /dev/null 2>&1 && Echo_INFOR "Updated nuclei-templates " || Echo_ERROR "nuclei-templates update failed"

}

# ===================== Install w13scan =====================
Pentest_w13scan_Install(){

    name="w13scan"
    dir="$P_Dir/w13scan"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/w-digital-scanner/w13scan.git $dir > /dev/null 2>&1 && Echo_INFOR "Downloaded $name" || Echo_ERROR2
        cd $dir && pip3 install -r requirements.txt > /dev/null 2>&1 && Install_Switch4 "cowpy" && cd W13SCAN && python3 w13scan.py -h > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || { Echo_ERROR3; rm -rf $dir; }
    fi

}

# ===================== Install commix =====================
Pentest_commix_Install(){

    name="commix"
    dir="$P_Dir/commix"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/commixproject/commix.git $dir > /dev/null 2>&1 && cd $dir || Echo_ERROR2
        python3 commix.py -h > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

}

# ===================== Install tplmap =====================
Pentest_tplmap_Install(){

    name="tplmap"
    dir="$P_Dir/tplmap"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/epinna/tplmap.git $dir > /dev/null 2>&1 && cd $dir || Echo_ERROR2
        python2 tplmap.py -h > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

}

# ===================== Install OpenRedireX =====================
Pentest_OpenRedireX_Install(){

    name="OpenRedireX"
    dir="$P_Dir/OpenRedireX"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        cd $P_Dir && $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/No-Github/OpenRedireX.git > /dev/null 2>&1
        cd $dir && Install_Switch4 "aiohttp" && Echo_INFOR "Successfully installed $name in the $dir" || { Echo_ERROR3; rm -rf $dir; }
    fi

}

# ===================== Install CORScanner =====================
Pentest_CORScanner_Install(){

    name="CORScanner"
    dir="$P_Dir/CORScanner"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/chenjj/CORScanner.git $dir > /dev/null 2>&1 && Echo_INFOR "Downloaded $name" || Echo_ERROR2
        cd $dir && pip3 install -r requirements.txt > /dev/null 2>&1 && python3 cors_scan.py -h > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || { Echo_ERROR3; rm -rf $dir; }
    fi

}

# ===================== Install swagger-exp =====================
Pentest_swagger-exp_Install(){

    name="swagger-exp"
    dir="$P_Dir/swagger-exp"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        cd $P_Dir && $Proxy_OK git clone ${GitProxy}https://github.com/lijiejie/swagger-exp.git > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

}

# ===================== Install swagger-hack =====================
Pentest_swagger-hack_Install(){

    name="swagger-hack"
    dir="$P_Dir/swagger-hack"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        Install_Switch4 "loguru"
        cd $P_Dir && $Proxy_OK git clone ${GitProxy}https://github.com/jayus0821/swagger-hack.git > /dev/null 2>&1 && Echo_INFOR "Downloaded $name" || Echo_ERROR2
        cd $dir && python3 swagger-hack2.0.py -h > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

}

# jitpack.io often download fails
# ===================== Install ysoserial =====================
Pentest_ysoserial_Install(){

    name="ysoserial"
    dir="$P_Dir/ysoserial"

    if test -e $dir/ysoserial.jar
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        mkdir -p $dir && cd $_ && rm -f ysoserial.jar > /dev/null 2>&1 && $Proxy_OK wget -O ysoserial.jar ${GitProxy}https://github.com/frohoff/ysoserial/releases/download/v0.0.6/ysoserial-all.jar > /dev/null 2>&1 || Echo_ERROR2
        if test -e $dir/ysoserial.jar
        then
            Echo_INFOR "Successfully installed $name in the $dir"
        else
            Echo_ERROR3
        fi
    fi

}

# ===================== Install ysuserial =====================
Pentest_ysuserial_Install(){

    name="ysuserial"
    dir="$P_Dir/ysuserial"

    if test -e $dir/ysuserial.jar
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        mkdir -p $dir && cd $_ && rm -f ysuserial.jar > /dev/null 2>&1 && $Proxy_OK wget -O ysuserial.jar ${GitProxy}https://github.com/su18/ysoserial/releases/download/$ysuserial_Ver/$ysuserial_bin > /dev/null 2>&1 || Echo_ERROR2
        if test -e $dir/ysuserial.jar
        then
            Echo_INFOR "Successfully installed $name in the $dir"
        else
            Echo_ERROR3
        fi
    fi

}

# ===================== Install remote-method-guesser =====================
Pentest_remote-method-guesser_Install(){

    JDK_Check

    name="remote-method-guesser"
    dir="$P_Dir/remote-method-guesser"

    if test -e $dir/rmg.jar
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        mkdir -p $dir && cd $_ && rm -f rmg.jar > /dev/null 2>&1 && $Proxy_OK wget -O rmg.jar ${GitProxy}https://github.com/qtc-de/remote-method-guesser/releases/download/$rmg_Ver/$rmg_bin > /dev/null 2>&1 || Echo_ERROR2
        cd $dir && java -jar rmg.jar --help > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

}

# ===================== Install SSRFmap =====================
Pentest_SSRFmap_Install(){

    name="SSRFmap"
    dir="$P_Dir/SSRFmap"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        $Proxy_OK git clone ${GitProxy}https://github.com/swisskyrepo/SSRFmap.git $dir > /dev/null 2>&1 && Echo_INFOR "Downloaded $name" || Echo_ERROR2
        cd $dir && pip3 install -r requirements.txt > /dev/null 2>&1 && python3 ssrfmap.py -h > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || { Echo_ERROR3; rm -rf $dir; }
    fi

}

# ===================== Install testssl =====================
Pentest_testssl_Install(){

    name="testssl"
    dir="$P_Dir/testssl.sh/"

    if test -e $P_Dir/testssl.sh
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        Rm_Lock
        case $Linux_Version in
            *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                Install_Switch "bind-utils"
                ;;
            *"Kali"*|*"Ubuntu"*|*"Debian"*)
                Install_Switch "dnsutils"
                ;;
            *) ;;
        esac
        cd $P_Dir && git clone --depth 1 https://github.com/drwetter/testssl.sh.git > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

}

# ===================== Install dalfox =====================
Pentest_dalfox_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            dalfox_bin=$dalfox_bin_amd64
            ;;
        *"linux-arm64"*)
            dalfox_bin=$dalfox_bin_arm64
            ;;
    esac

    name="dalfox"
    which dalfox > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && rm -f $dalfox_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/hahwul/dalfox/releases/download/$dalfox_Ver/$dalfox_bin > /dev/null 2>&1 || Echo_ERROR2
        tar -zxvf $dalfox_bin > /dev/null 2>&1 && rm -f $dalfox_bin > /dev/null 2>&1
        mv dalfox /usr/local/bin/dalfox && chmod +x /usr/local/bin/dalfox && rm -f /tmp/$dalfox_bin > /dev/null 2>&1
        which dalfox > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $dalfox_Ver in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# ===================== Install JNDI-Injection-Exploit =====================
Pentest_JNDI-Injection-Exploit_Install(){

    name="JNDI-Injection-Exploit"
    dir="$P_Dir/JNDI-Injection-Exploit"

    if test -e $dir/JNDI-Injection-Exploit-1.0-SNAPSHOT-all.jar
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        mkdir -p $dir && cd $_ && rm -f JNDI-Injection-Exploit-1.0-SNAPSHOT-all.jar > /dev/null 2>&1 && $Proxy_OK wget -O JNDI-Injection-Exploit-1.0-SNAPSHOT-all.jar ${GitProxy}https://github.com/welk1n/JNDI-Injection-Exploit/releases/download/v1.0/JNDI-Injection-Exploit-1.0-SNAPSHOT-all.jar > /dev/null 2>&1 || Echo_ERROR2
        if test -e $dir/JNDI-Injection-Exploit-1.0-SNAPSHOT-all.jar
        then
            Echo_INFOR "Successfully installed $name in the $dir"
        else
            Echo_ERROR3
        fi
    fi

}

# ===================== Install Gopherus =====================
Pentest_Gopherus_Install(){

    name="Gopherus"
    which gopherus > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd $P_Dir && rm -rf Gopherus && $Proxy_OK git clone ${GitProxy}https://github.com/tarunkant/Gopherus.git > /dev/null 2>&1 || Echo_ERROR2
        Install_Switch3 "argparse"
        Install_Switch3 "requests"
        cd Gopherus && chmod +x gopherus.py
        ln -sf $(pwd)/gopherus.py /usr/local/bin/gopherus
        which gopherus > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $P_Dir" || Echo_ERROR3
    fi

}

# ===================== Install redis-rogue-server =====================
Pentest_redis-rogue-server_Install(){

    name="redis-rogue-server"
    dir="$P_Dir/redis-rogue-server"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        cd $P_Dir && $Proxy_OK git clone ${GitProxy}https://github.com/Dliv3/redis-rogue-server.git $dir > /dev/null 2>&1 || Echo_ERROR2
        cd $dir && python3 redis-rogue-server.py -h > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

}

# ===================== Install redis-rogue-server-win =====================
Pentest_redis-rogue-server-win_Install(){

    name="redis-rogue-server-win"
    dir="$P_Dir/redis-rogue-server-win"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        cd $P_Dir && $Proxy_OK git clone ${GitProxy}https://github.com/No-Github/redis-rogue-server-win.git $dir > /dev/null 2>&1 || Echo_ERROR2
        cd $dir && python3 redis-rogue-server.py -h > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

}

# ===================== Install redis-rce =====================
Pentest_redis-rce_Install(){

    name="redis-rce"
    dir="$P_Dir/redis-rce"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        Install_Switch4 "six"
        rm -rf $dir && cd $P_Dir && $Proxy_OK git clone ${GitProxy}https://github.com/Ridter/redis-rce.git $dir > /dev/null 2>&1 || Echo_ERROR2
        cd $dir && python3 redis-rce.py -h > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
        cp $P_Dir/redis-rogue-server/exp.so $dir && Echo_INFOR "Copied exp.so to $dir"
    fi

}

# ===================== Install redis_lua_exploit =====================
Pentest_redis_lua_exploit_Install(){

    name="redis_lua_exploit"
    dir="$P_Dir/redis_lua_exploit"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        Install_Switch3 "redis"
        cd $P_Dir && $Proxy_OK git clone ${GitProxy}https://github.com/QAX-A-Team/redis_lua_exploit.git $dir > /dev/null 2>&1 && Echo_INFOR "Downloaded $name" || Echo_ERROR2
    fi

}

# ===================== Install shiro_rce_tool =====================
Pentest_shiro_rce_tool_Install(){

    name="shiro_rce_tool"
    dir="$P_Dir/shiro_tool"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        cd $P_Dir && rm -f shiro_tool.zip && $Proxy_OK wget -O shiro_tool.zip ${GitProxy2}https://raw.githubusercontent.com/No-Github/Archive/master/shiro/shiro_tool.zip > /dev/null 2>&1 || Echo_ERROR2
        unzip shiro_tool.zip > /dev/null 2>&1 && rm -f shiro_tool.zip && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

}

# ===================== Install shiro-exploit =====================
Pentest_shiro-exploit_Install(){

    name="shiro-exploit"
    dir="$P_Dir/shiro-exploit"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        cd $P_Dir && $Proxy_OK git clone ${GitProxy}https://github.com/Ares-X/shiro-exploit.git $dir > /dev/null 2>&1 || Echo_ERROR2
        Install_Switch4 "pycryptodome"
        cd $dir && python3 shiro-exploit.py -h > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

}

# ===================== Install marshalsec =====================
Pentest_marshalsec_Install(){

    name="marshalsec"
    dir="$P_Dir/marshalsec"

    if test -e $dir/marshalsec-0.0.3-SNAPSHOT-all.jar
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        mkdir -p $dir && cd $_ && rm -f marshalsec-0.0.3-SNAPSHOT-all.jar > /dev/null 2>&1
        $Proxy_OK wget -O marshalsec-0.0.3-SNAPSHOT-all.jar ${GitProxy}https://github.com/No-Github/marshalsec/releases/download/v0.0.3/marshalsec-0.0.3-SNAPSHOT-all.jar > /dev/null 2>&1 || rm marshalsec-0.0.3-SNAPSHOT-all.jar
        if test -e $dir/marshalsec-0.0.3-SNAPSHOT-all.jar
        then
            Echo_INFOR "Successfully installed $name in the $dir"
        else
            Echo_ERROR3
        fi
    fi

}

# ===================== Install ysomap =====================
Pentest_ysomap_Install(){

    name="ysomap"
    dir="$P_Dir/ysomap"

    if test -e $dir/$ysomap_bin
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        mkdir -p $dir && cd $_ && rm -f $ysomap_bin > /dev/null 2>&1
        $Proxy_OK wget -O $ysomap_bin ${GitProxy}https://github.com/wh1t3p1g/ysomap/releases/download/$ysomap_Ver/$ysomap_bin > /dev/null 2>&1 || rm $ysomap_bin
        if test -e $dir/$ysomap_bin
        then
            Echo_INFOR "Successfully installed $name in the $dir"
        else
            Echo_ERROR3
        fi
    fi

}

# ===================== Install CDK =====================
Pentest_CDK_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            cdk_bin=$cdk_bin_amd64
            ;;
        *"linux-arm64"*)
            cdk_bin=$cdk_bin_arm64
            ;;
    esac

    name="CDK"
    which cdk > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && rm -f ${cdk_bin} && $Proxy_OK wget ${GitProxy}https://github.com/cdk-team/CDK/releases/download/$cdk_Ver/$cdk_bin > /dev/null 2>&1 || Echo_ERROR2
        mv --force $cdk_bin /usr/local/bin/cdk && chmod +x /usr/local/bin/cdk
        which cdk > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $cdk_Ver in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# ===================== Install cf =====================
Pentest_cf_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            cf_bin=$cf_Install_amd64
            ;;
        *"linux-arm64"*)
            cf_bin=$cf_Install_arm64
            ;;
    esac

    name="cf"
    which cf > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && rm -f $cf_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/teamssix/cf/releases/download/$cf_Ver/$cf_bin > /dev/null 2>&1 || Echo_ERROR2
        tar -zxvf $cf_bin > /dev/null 2>&1 && rm -f $cf_bin > /dev/null 2>&1
        mv cf /usr/local/bin/cf && chmod +x /usr/local/bin/cf && rm -f /tmp/$cf_bin > /dev/null 2>&1
        which cf > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $cf_Ver in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# 原项目删除,已将 jar 包备份一份到 Archive
Pentest_JNDIExploit_0x727_Install(){

    name="JNDIExploit"
    dir="$P_Dir/JNDIExploit"

    if test -e $dir/JNDIExploit-1.3-SNAPSHOT.jar
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        mkdir -p $dir && cd $_
        $Proxy_OK wget -O $JNDIExploit_bin ${GitProxy}https://github.com/0x727/JNDIExploit/releases/download/$JNDIExploit_Ver/$JNDIExploit_bin > /dev/null 2>&1 || rm $JNDIExploit_bin
        unzip $JNDIExploit_bin > /dev/null 2>&1 && rm -f $JNDIExploit_bin
        if test -e $dir/JNDIExploit-1.3-SNAPSHOT.jar
        then
            Echo_INFOR "Successfully installed $name in the $dir"
        else
            Echo_ERROR3
        fi
    fi

}

# 原项目删除,已将 jar 包备份一份到 Archive
Pentest_JNDIExploit_Install(){

    name="JNDIExploit"
    dir="$P_Dir/JNDIExploit"

    if test -e $dir/JNDIExploit-1.2-SNAPSHOT.jar
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        mkdir -p $dir && cd $_ && rm -rf $JNDIExploit_dir > /dev/null 2>&1
        $Proxy_OK wget -O $JNDIExploit_bin ${GitProxy}https://github.com/feihong-cs/JNDIExploit/releases/download/$JNDIExploit_Ver/$JNDIExploit_bin > /dev/null 2>&1 || rm $JNDIExploit_bin
        unzip $JNDIExploit_bin > /dev/null 2>&1 && rm -f $JNDIExploit_bin
        if test -e $dir/JNDIExploit-1.2-SNAPSHOT.jar
        then
            Echo_INFOR "Successfully installed $name in the $dir"
        else
            Echo_ERROR3
        fi
    fi

}

# ===================== Install Impacket =====================
Pentest_Impacket_Install(){

    name="Impacket"
    dir="$P_Dir/impacket"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/SecureAuthCorp/impacket.git $dir > /dev/null 2>&1 || Echo_ERROR2
        cd $dir && pip3 install . > /dev/null 2>&1
        python3 setup.py install > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

}

# ===================== Install CobaltStrike 4.3 =====================
Pentest_CobaltStrike_Install(){

    JDK_Check

    name="CobaltStrike"

    if test -d $P_Dir/$CS_Version
    then
        Echo_ALERT "$CS_Version is already installed in $P_Dir/$CS_Version"
    else
        cd $P_Dir && rm -f $CS_File > /dev/null 2>&1 && $Proxy_OK wget -O $CS_File ${GitProxy2}https://raw.githubusercontent.com/No-Github/Archive/master/CS/$CS_File > /dev/null 2>&1 || Echo_ERROR "$CS_File download failed, please check if the network is reachable, proxychains4 configuration is correct"
        rm -rf $CS_Version > /dev/null 2>&1 && unzip $CS_File > /dev/null 2>&1 && rm -f $CS_File > /dev/null 2>&1
        cd $P_Dir/$CS_Version && chmod +x teamserver > /dev/null 2>&1
        rm -f cobaltstrike.store > /dev/null 2>&1
        Echo_INFOR "Successfully installed $CS_Version in the $P_Dir/$CS_Version" || Echo_ERROR3
    fi

    if test -e $P_Dir/$CS_Version/genCrossC2.Linux
    then
        Echo_ALERT "genCrossC2.Linux file already exists "
    else
        cd $P_Dir/$CS_Version && $Proxy_OK wget ${GitProxy}https://github.com/gloxec/CrossC2/releases/download/$CrossC2_Ver/genCrossC2.Linux > /dev/null 2>&1 && Echo_INFOR "Downloaded CrossC2 in the $P_Dir/$CS_Version/genCrossC2.Linux " || Echo_ERROR "CrossC2 installation failed"
        chmod +x genCrossC2.Linux > /dev/null 2>&1
    fi

    Echo_INFOR "CrossC2 command:\n\033[0m\033[1;32mcd $P_Dir/$CS_Version/ && ./genCrossC2.Linux <IP> <port> ./.cobaltstrike.beacon_keys null Linux x64 <filename> "

    if test -e $P_Dir/$CS_Version/cobaltstrike.store
    then
        Echo_ALERT "cobaltstrike.store file has been generated"
    else
        cd $P_Dir/$CS_Version
        keytool -keystore ./cobaltstrike.store -storepass sUp3r@dm1n -keypass sUp3r@dm1n -genkey -keyalg RSA -alias aliyun -dname "CN=aliyun, OU=aliyun, O=aliyun, L=aliyun, S=aliyun, C=aliyun" > /dev/null 2>&1

        if test -e $P_Dir/$CS_Version/cobaltstrike.store
        then
            Echo_ALERT "keytool 工具使用正常"
            rm -f cobaltstrike.store > /dev/null 2>&1
        else
            Echo_ERROR "keytool 工具使用出现问题,正在重新配置 jenv"
            jenv_config "/usr/local/java/$jdk8_Version"
            jenv local 1.8
            keytool -keystore ./cobaltstrike.store -storepass sUp3r@dm1n -keypass sUp3r@dm1n -genkey -keyalg RSA -alias aliyun -dname "CN=aliyun, OU=aliyun, O=aliyun, L=aliyun, S=aliyun, C=aliyun" > /dev/null 2>&1

            if test -e $P_Dir/$CS_Version/cobaltstrike.store
            then
                Echo_ALERT "keytool 工具使用正常"
                rm -f cobaltstrike.store > /dev/null 2>&1
            else
                Echo_ERROR "keytool 工具使用出现问题,请手动配置 jenv 环境"
            fi
        fi
    fi

}

# ===================== Install CobaltStrike 4.5 =====================
Pentest_CobaltStrike45_Install(){

    JDK_Check

    name="CobaltStrike4.5"

    if test -d $P_Dir/$CS45_Version
    then
        Echo_ALERT "$CS45_Version is already installed in $P_Dir/$CS45_Version"
    else
        cd $P_Dir && rm -f $CS45_File > /dev/null 2>&1 && $Proxy_OK wget -O $CS45_File ${GitProxy2}https://github.com/No-Github/Archive/releases/download/1.0.6/$CS45_File ${wget_option} || Echo_ERROR "$CS45_File download failed, please check if the network is reachable, proxychains4 configuration is correct"
        rm -rf $CS45_Version > /dev/null 2>&1 && unzip $CS45_File > /dev/null 2>&1 && rm -f $CS45_File > /dev/null 2>&1
        cd $P_Dir/$CS45_Version && chmod +x teamserver > /dev/null 2>&1
        rm -f cobaltstrike.store > /dev/null 2>&1
        Echo_INFOR "Successfully installed $CS45_Version in the $P_Dir/$CS45_Version" || Echo_ERROR3
    fi

    if test -e $P_Dir/$CS45_Version/genCrossC2.Linux
    then
        Echo_ALERT "genCrossC2.Linux file already exists "
    else
        cd $P_Dir/$CS45_Version && $Proxy_OK wget ${GitProxy}https://github.com/gloxec/CrossC2/releases/download/$CrossC2_Ver/genCrossC2.Linux ${wget_option} && Echo_INFOR "Downloaded CrossC2 in the $P_Dir/$CS45_Version/genCrossC2.Linux " || Echo_ERROR "CrossC2 installation failed"
        chmod +x genCrossC2.Linux > /dev/null 2>&1
    fi

    Echo_INFOR "CrossC2 command:\n\033[0m\033[1;32mcd $P_Dir/$CS45_Version/ && ./genCrossC2.Linux <IP> <port> ./.cobaltstrike.beacon_keys null Linux x64 <filename> "

    if test -e $P_Dir/$CS45_Version/cobaltstrike.store
    then
        Echo_ALERT "cobaltstrike.store file has been generated"
    else
        cd $P_Dir/$CS45_Version
        keytool -keystore ./cobaltstrike.store -storepass sUp3r@dm1n -keypass sUp3r@dm1n -genkey -keyalg RSA -alias aliyun -dname "CN=aliyun, OU=aliyun, O=aliyun, L=aliyun, S=aliyun, C=aliyun" > /dev/null 2>&1

        if test -e $P_Dir/$CS45_Version/cobaltstrike.store
        then
            Echo_ALERT "keytool 工具使用正常"
            rm -f cobaltstrike.store > /dev/null 2>&1
        else
            Echo_ERROR "keytool 工具使用出现问题,正在重新配置 jenv"
            jenv_config "/usr/local/java/$jdk8_Version"
            jenv local 1.8
            keytool -keystore ./cobaltstrike.store -storepass sUp3r@dm1n -keypass sUp3r@dm1n -genkey -keyalg RSA -alias aliyun -dname "CN=aliyun, OU=aliyun, O=aliyun, L=aliyun, S=aliyun, C=aliyun" > /dev/null 2>&1

            if test -e $P_Dir/$CS45_Version/cobaltstrike.store
            then
                Echo_ALERT "keytool 工具使用正常"
                rm -f cobaltstrike.store > /dev/null 2>&1
            else
                Echo_ERROR "keytool 工具使用出现问题,请手动配置 jenv 环境"
            fi
        fi
    fi

}

# ===================== Install Responder =====================
Pentest_Responder_Install(){

    name="Responder"
    dir="$P_Dir/Responder"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        Install_Switch4 "netifaces"
        $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/lgandx/Responder.git $dir > /dev/null 2>&1 && cd $dir || Echo_ERROR2
        python3 Responder.py -h > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi
}

# ===================== Install krbrelayx =====================
Pentest_krbrelayx_Install(){

    name="krbrelayx"
    dir="$P_Dir/krbrelayx"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        $Proxy_OK git clone ${GitProxy}https://github.com/dirkjanm/krbrelayx.git $dir > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

}

# ===================== Install bettercap =====================
Pentest_bettercap_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            bettercap_bin=$bettercap_bin_amd64
            ;;
        *"linux-arm64"*)
            bettercap_bin=$bettercap_bin_arm64
            ;;
    esac

    name="bettercap"
    which bettercap > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else

        mkdir /tmp/bettercap && cd /tmp/bettercap && rm -f $bettercap_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/bettercap/bettercap/releases/download/$bettercap_Ver/$bettercap_bin > /dev/null 2>&1 || Echo_ERROR2
        unzip $bettercap_bin > /dev/null 2>&1
        mv --force bettercap /usr/local/bin/bettercap && chmod +x /usr/local/bin/bettercap
        rm -rf /tmp/bettercap
        which bettercap > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $bettercap_Ver in the /usr/local/bin/" || Echo_ERROR3

        case $Linux_Version in
            *"Kali"*|*"Ubuntu"*|*"Debian"*)
                Rm_Lock
                Install_Switch "libnetfilter-queue-dev"
                Install_Switch "libusb-1.0-0"
                ;;
            *) ;;
        esac

    fi

}

# ===================== Install mitmproxy =====================
Pentest_mitmproxy_Install(){

    name="mitmproxy"
    which mitmproxy > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && rm -f $mitmproxy_bin > /dev/null 2>&1 && $Proxy_OK wget -O $mitmproxy_bin https://snapshots.mitmproxy.org/$mitmproxy_Ver/$mitmproxy_bin > /dev/null 2>&1 || Echo_ERROR2
        tar -zxvf $mitmproxy_bin > /dev/null 2>&1
        mv --force mitmproxy /usr/local/bin/ && chmod +x /usr/local/bin/mitmproxy && rm -f /tmp/$mitmproxy_bin > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $mitmproxy_Ver in the /usr/local/bin/" || Echo_ERROR3
        mv --force mitmdump /usr/local/bin/ && chmod +x /usr/local/bin/mitmdump && Echo_INFOR "Successfully installed $name in the /usr/local/bin/" || Echo_ERROR "mitmdump installation failed"
        mv --force mitmweb /usr/local/bin/ && chmod +x /usr/local/bin/mitmweb && Echo_INFOR "Successfully installed $name in the /usr/local/bin/" || Echo_ERROR "mitmweb installation failed"
    fi

}

# ===================== Install pypykatz =====================
Pentest_pypykatz_Install(){

    name="pypykatz"
    which pypykatz > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        Install_Switch4 "pypykatz"
    fi

}

# ===================== Install CrackMapExec =====================
Pentest_CrackMapExec_Install(){

    name="CrackMapExec"
    which crackmapexec > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        Install_Switch5 "pipx"
        pipx ensurepath
        pipx install crackmapexec
    fi

}

# ===================== Install Neo-reGeorg =====================
Pentest_Neo-reGeorg_Install(){

    name="Neo-reGeorg"
    dir="$P_Dir/Neo-reGeorg"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/L-codes/Neo-reGeorg.git $dir > /dev/null 2>&1 && Echo_INFOR "Downloaded $name in the $dir" || Echo_ERROR2
    fi

}

# ===================== Install hashcat、7z2hashcat =====================
Pentest_hashcat_Install(){

    name="hashcat"
    dir="$P_Dir/${hashcat_Version}"

    if test -d $dir
    then
        Echo_ALERT "hashcat is already installed in $dir"
    else
        name="hashcat"
        rm -rf /usr/sbin/hashcat
        rm -rf $P_Dir/hashcat-6.2.*
        $Proxy_OK wget -O $P_Dir/${hashcat_Version}.7z ${GitProxy2}https://hashcat.net/files/${hashcat_Version}.7z --no-check-certificate > /dev/null 2>&1 && Echo_INFOR "Downloaded ${hashcat_Version}" || Echo_ERROR2
        7za x $P_Dir/${hashcat_Version}.7z -o$P_Dir > /dev/null 2>&1
        rm -f $P_Dir/${hashcat_Version}.7z > /dev/null 2>&1
        cd $P_Dir/hashcat* > /dev/null 2>&1 && chmod +x hashcat.bin && cp hashcat.bin hashcat
        ln -s $P_Dir/${hashcat_Version}/hashcat /usr/sbin/hashcat > /dev/null 2>&1
        which hashcat > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

    if test -e $P_Dir/7z2hashcat.pl
    then
        Echo_ALERT "7z2hashcat is already installed in $P_Dir"
    else
        name="7z2hashcat"
        $Proxy_OK curl -o $P_Dir/7z2hashcat.pl ${GitProxy}https://raw.githubusercontent.com/philsmd/7z2hashcat/master/7z2hashcat.pl > /dev/null 2>&1 && Echo_INFOR "Downloaded 7z2hashcat.pl in the $P_Dir" || Echo_ERROR2

    fi

}

# ===================== Install ZoomEye-python =====================
Pentest_ZoomEye_Install(){

    name="ZoomEye-python"
    which zoomeye > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        Install_Switch4 "zoomeye"
    fi

}

# ===================== Install jadx =====================
Pentest_jadx_Install(){

    name="jadx"
    which jadx > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /usr/local/jadx && cd /usr/local/jadx && rm -f $jadx_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/skylot/jadx/releases/download/$jadx_Ver/$jadx_bin > /dev/null 2>&1 || Echo_ERROR2
        unzip $jadx_bin > /dev/null 2>&1
        chmod +x /usr/local/jadx/bin/jadx && ln -s /usr/local/jadx/bin/jadx /usr/local/bin/jadx && rm -f /usr/local/$jadx_bin > /dev/null 2>&1
        which jadx > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $jadx_Ver in the /usr/local/jadx/" || Echo_ERROR3

    fi

}

# ===================== Install ncat =====================
Pentest_ncat_Install(){

    name="ncat"

    case $Linux_Version in
        *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
            Echo_INFOR "Installed when nmap was installed $name"
            ;;
        *"Kali"*|*"Ubuntu"*|*"Debian"*)
            ncat --version > /dev/null 2>&1

            if [ $? == 0 ]
            then
                Echo_ALERT "$name installed"
            else
                Rm_Lock
                Install_Switch "ncat"
                Echo_INFOR "If there is no response for a long time, please press enter manually"
                update-alternatives --set nc /usr/bin/ncat >/dev/null 2>&1 && Echo_INFOR "The default nc is configured as /usr/bin/ncat" || Echo_ERROR "Set default nc to /usr/bin/ncat Failed"
            fi

            ;;
        *) ;;
    esac

}

# ===================== Install Platypus =====================
Pentest_Platypus_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            Platypus_bin=$Platypus_bin_amd64
            ;;
        *"linux-arm64"*)
            Platypus_bin=$Platypus_bin_arm64
            ;;
    esac

    name="Platypus"
    which Platypus > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/Platypus && cd /tmp/Platypus && rm -f ${Platypus_bin} > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/WangYihang/Platypus/releases/download/${Platypus_Ver}/${Platypus_bin} > /dev/null 2>&1 || Echo_ERROR2
        mv ${Platypus_bin} /usr/local/bin/Platypus && chmod +x /usr/local/bin/Platypus
        rm -rf /tmp/Platypus
        which Platypus > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name ${Platypus_Ver} in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# ===================== Install MoreFind =====================
Pentest_MoreFind_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            MoreFind_bin=$MoreFind_bin_amd64
            ;;
        *"linux-arm64"*)
            MoreFind_bin=$MoreFind_bin_arm64
            ;;
    esac

    name="MoreFind"
    which MoreFind > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/MoreFind && cd /tmp/MoreFind && $Proxy_OK wget ${GitProxy}https://github.com/mstxq17/MoreFind/releases/download/$MoreFind_Ver/$MoreFind_bin > /dev/null 2>&1 || Echo_ERROR2
        tar -zxvf $MoreFind_bin > /dev/null 2>&1
        mv --force MoreFind /usr/local/bin/MoreFind && chmod +x /usr/local/bin/MoreFind
        which MoreFind > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $MoreFind_Ver in the /usr/local/bin/" || Echo_ERROR3
        rm -rf /tmp/MoreFind > /dev/null 2>&1
    fi

}

# ===================== Install mapcidr =====================
Pentest_mapcidr_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            mapcidr_bin=$mapcidr_bin_amd64
            ;;
        *"linux-arm64"*)
            mapcidr_bin=$mapcidr_bin_arm64
            ;;
    esac

    name="mapcidr"
    which mapcidr > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && rm -f $mapcidr_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/projectdiscovery/mapcidr/releases/download/$mapcidr_Ver/$mapcidr_bin > /dev/null 2>&1 || Echo_ERROR2
        tar -zxvf $mapcidr_bin > /dev/null 2>&1
        mv --force mapcidr /usr/local/bin/mapcidr && chmod +x /usr/local/bin/mapcidr && rm -f /tmp/$mapcidr_bin > /dev/null 2>&1
        mapcidr -version > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $mapcidr_Ver in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# 建议使用 mapcidr
# ===================== Install iprange =====================
Pentest_iprange_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            iprange_bin=$iprange_bin_amd64
            ;;
        *"linux-arm64"*)
            iprange_bin=$iprange_bin_arm64
            ;;
    esac

    name="iprange"
    which iprange > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && rm -f $iprange_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/ffffffff0x/iprange/releases/download/$iprange_Ver/$iprange_bin > /dev/null 2>&1 || Echo_ERROR2
        tar -zxvf $iprange_bin > /dev/null 2>&1
        mv --force iprange /usr/local/bin/iprange && chmod +x /usr/local/bin/iprange && rm -f /tmp/$iprange_bin > /dev/null 2>&1
        which iprange > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $iprange_Ver in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# ===================== Install dnsx =====================
Pentest_dnsx_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            dnsx_bin=$dnsx_bin_amd64
            ;;
        *"linux-arm64"*)
            dnsx_bin=$dnsx_bin_arm64
            ;;
    esac

    name="dnsx"
    which dnsx > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/dnsx && cd /tmp/dnsx && rm -f $dnsx_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/projectdiscovery/dnsx/releases/download/$dnsx_Ver/$dnsx_bin > /dev/null 2>&1 || Echo_ERROR2
        unzip $dnsx_bin > /dev/null 2>&1
        mv --force dnsx /usr/local/bin/dnsx && chmod +x /usr/local/bin/dnsx
        which dnsx > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $dnsx_Ver in the /usr/local/bin/" || Echo_ERROR3
        rm -rf /tmp/dnsx > /dev/null 2>&1
    fi

}

# ===================== Install uncover =====================
Pentest_uncover_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            uncover_bin=$uncover_bin_amd64
            ;;
        *"linux-arm64"*)
            uncover_bin=$uncover_bin_arm64
            ;;
    esac

    name="uncover"
    which uncover > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/uncover && cd /tmp/uncover && rm -f $uncover_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/projectdiscovery/uncover/releases/download/$uncover_Ver/$uncover_bin > /dev/null 2>&1 || Echo_ERROR2
        unzip $uncover_bin > /dev/null 2>&1
        mv --force uncover /usr/local/bin/uncover && chmod +x /usr/local/bin/uncover
        which uncover > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $uncover_Ver in the /usr/local/bin/" || Echo_ERROR3
        rm -rf /tmp/uncover > /dev/null 2>&1
    fi

}

# ===================== Install nali =====================
Pentest_nali_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            nali_bin=$nali_bin_amd64
            ;;
        *"linux-arm64"*)
            nali_bin=$nali_bin_arm64
            ;;
    esac

    name="nali"
    which nali > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && rm -f nali-linux-* > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/zu1k/nali/releases/download/$nali_Ver/$nali_bin > /dev/null 2>&1 || Echo_ERROR2
        gunzip $nali_bin > /dev/null 2>&1 && rm -f $nali_bin > /dev/null 2>&1
        mv nali-linux-* /usr/local/bin/nali && chmod +x /usr/local/bin/nali && rm -f $nali_bin > /dev/null 2>&1
        which nali > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $nali_Ver in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# ===================== Install anew =====================
Pentest_anew_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            anew_bin=$anew_bin_amd64
            ;;
        *"linux-arm64"*)
            anew_bin=$anew_bin_arm64
            ;;
    esac

    name="anew"
    which anew  > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/anew && cd /tmp/anew && rm -f ${anew_bin} > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/No-Github/anew/releases/download/$anew_Ver/$anew_bin > /dev/null 2>&1 || Echo_ERROR2
        tar -xzvf ${anew_bin} > /dev/null
        mv anew /usr/local/bin/anew && chmod +x /usr/local/bin/anew
        which anew > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $anew_Ver in the /usr/local/bin/" || Echo_ERROR3
        rm -rf /tmp/anew
    fi

}

# ===================== Install gron =====================
Pentest_gron_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            gron_bin=$gron_bin_amd64
            ;;
        *"linux-arm64"*)
            gron_bin=$gron_bin_arm64
            ;;
    esac

    name="gron"
    which gron > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/gron && cd /tmp/gron && rm -f ${gron_bin} > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/tomnomnom/gron/releases/download/${gron_Ver}/${gron_bin} > /dev/null 2>&1 || Echo_ERROR2
        tar -xzvf ${gron_bin} > /dev/null 2>&1
        mv /tmp/gron/gron /usr/local/bin/gron && chmod +x /usr/local/bin/gron
        which gron > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name ${gron_Ver} in the /usr/local/bin/" || Echo_ERROR3
        rm -rf /tmp/gron
    fi

}

# ===================== Install unfurl =====================
Pentest_unfurl_Install(){

    name="unfurl"
    which unfurl > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        case $Linux_architecture_Name in
            *"linux-x86_64"*)
                mkdir -p /tmp/unfurl && cd /tmp/unfurl && rm -f ${unfurl_Bin} > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/tomnomnom/unfurl/releases/download/${unfurl_Ver}/${unfurl_Bin} > /dev/null 2>&1 || Echo_ERROR2
                tar -xzvf ${unfurl_Bin} > /dev/null 2>&1
                mv /tmp/unfurl/unfurl /usr/local/bin/unfurl && chmod +x /usr/local/bin/unfurl
                which unfurl > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name ${unfurl_Ver} in the /usr/local/bin/" || Echo_ERROR3
                rm -rf /tmp/unfurl
                ;;
            *"linux-arm64"*)
                go install github.com/tomnomnom/unfurl@latest
                mv $GOPATH/bin/unfurl /usr/local/bin/unfurl && chmod +x /usr/local/bin/unfurl
                which unfurl > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the /usr/local/bin/" || Echo_ERROR3
                ;;
        esac
    fi

}

# ===================== Install qsreplace =====================
Pentest_qsreplace_Install(){

    name="qsreplace"
    which qsreplace > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        case $Linux_architecture_Name in
            *"linux-x86_64"*)
                mkdir -p /tmp/qsreplace && cd /tmp/qsreplace && rm -f ${qsreplace_bin} > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/tomnomnom/qsreplace/releases/download/${qsreplace_Ver}/${qsreplace_bin} > /dev/null 2>&1 || Echo_ERROR2
                tar -xzvf ${qsreplace_bin} > /dev/null 2>&1
                mv /tmp/qsreplace/qsreplace /usr/local/bin/qsreplace && chmod +x /usr/local/bin/qsreplace
                rm -rf /tmp/qsreplace
                which qsreplace > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name ${qsreplace_Ver} in the /usr/local/bin/" || Echo_ERROR3
                ;;
            *"linux-arm64"*)
                go install github.com/tomnomnom/qsreplace@latest
                mv $GOPATH/bin/qsreplace /usr/local/bin/qsreplace && chmod +x /usr/local/bin/qsreplace
                which qsreplace > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the /usr/local/bin/" || Echo_ERROR3
                ;;
        esac
    fi

}

# ===================== Install Interlace =====================
Pentest_Interlace_Install(){

    name="Interlace"
    which interlace > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && rm -rf Interlace
        $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/codingo/Interlace.git > /dev/null 2>&1 && Echo_INFOR "Downloaded $name" || Echo_ERROR2
        cd Interlace && $Proxy_OK python3 setup.py install > /dev/null 2>&1
        which interlace > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name" || Echo_ERROR3
        rm -rf /tmp/Interlace
    fi

}

# ===================== Install sttr =====================
Pentest_sttr_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            sttr_bin=$sttr_bin_amd64
            ;;
        *"linux-arm64"*)
            sttr_bin=$sttr_bin_arm64
            ;;
    esac

    name="sttr"
    which sttr > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && rm -f $sttr_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/abhimanyu003/sttr/releases/download/$sttr_Ver/$sttr_bin > /dev/null 2>&1 || Echo_ERROR2
        tar -zxvf $sttr_bin > /dev/null 2>&1
        mv --force sttr /usr/local/bin/ && chmod +x /usr/local/bin/sttr && rm -f /tmp/$sttr_bin > /dev/null 2>&1
        which sttr > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $sttr_Ver in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# ===================== Install jwtcat =====================
Pentest_jwtcat_Install(){

    name="jwtcat"
    dir="$P_Dir/jwtcat"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        cd $P_Dir && $Proxy_OK git clone ${GitProxy}https://github.com/aress31/jwtcat.git $dir > /dev/null 2>&1 || Echo_ERROR2
        cd $dir && python3 -m pip install -r requirements.txt > /dev/null 2>&1
        python3 jwtcat.py -h > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

}

# ===================== Install gojwtcrack =====================
Pentest_gojwtcrack_Install(){

    name="gojwtcrack"
    which gojwtcrack > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        case $Linux_architecture_Name in
            *"linux-x86_64"*)
                cd /tmp && rm -f ${gojwtcrack_bin} > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/x1sec/gojwtcrack/releases/download/${gojwtcrack_Ver}/${gojwtcrack_bin} > /dev/null 2>&1 || Echo_ERROR2
                gunzip ${gojwtcrack_bin} && rm -rf ${gojwtcrack_bin}
                mv gojwtcrack-linux-* /usr/local/bin/gojwtcrack && chmod +x /usr/local/bin/gojwtcrack
                which gojwtcrack > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name ${gojwtcrack_Ver} in the /usr/local/bin/" || Echo_ERROR3
                ;;
            *"linux-arm64"*)
                go install github.com/x1sec/gojwtcrack@latest
                mv $GOPATH/bin/gojwtcrack /usr/local/bin/gojwtcrack && chmod +x /usr/local/bin/gojwtcrack
                which gojwtcrack > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the /usr/local/bin/" || Echo_ERROR3
                ;;
        esac
    fi

}

# 域名分割工具,默认不安装
# ===================== Install DomainSplit =====================
Pentest_DomainSplit_Install(){

    name="DomainSplit"
    dir="$P_Dir/DomainSplit"

    if test -e $dir/DomainSplit.jar
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        mkdir -p $dir && cd $_ && rm -f DomainSplit.jar > /dev/null 2>&1 && $Proxy_OK wget -O DomainSplit.jar ${GitProxy}https://github.com/ffffffff0x/DomainSplit/releases/download/$DomainSplit_Ver/DomainSplit.jar > /dev/null 2>&1 || Echo_ERROR2
        if test -e $dir/DomainSplit.jar
        then
            Echo_INFOR "Successfully installed $name in the $dir"
        else
            Echo_ERROR3
        fi
    fi

}

# 实际使用较少,默认不安装
# ===================== Install proxify =====================
Pentest_proxify_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            proxify_bin=$proxify_bin_amd64
            ;;
        *"linux-arm64"*)
            proxify_bin=$proxify_bin_arm64
            ;;
    esac

    name="proxify"
    which proxify > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && rm -f $proxify_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/projectdiscovery/proxify/releases/download/$proxify_Ver/$proxify_bin > /dev/null 2>&1 || Echo_ERROR2
        unzip $proxify_bin > /dev/null 2>&1
        mv --force proxify /usr/local/bin/proxify && chmod +x /usr/local/bin/proxify && rm -f /tmp/$proxify_bin > /dev/null 2>&1
        proxify -version > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $proxify_Ver in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# 安装时间较长,且与 AboutSecurity 功能重叠,默认放 E 分类
# ===================== SecLists =====================
Pentest_SecLists_Install(){

    name="SecLists"

    if test -d $P_Dir/$name
    then
        Echo_ALERT "$name dictionary already exists"
    else
        rm -rf $P_Dir/$name > /dev/null 2>&1 && $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/danielmiessler/SecLists.git $P_Dir/$name > /dev/null 2>&1 && Echo_INFOR "Downloaded $name in the $P_Dir/$name" || Echo_ERROR "Failed to download the $name dictionary from github"
    fi

}

# ===================== Install jaeles =====================
Pentest_jaeles_Install(){

    name="jaeles"
    which jaeles > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        case $Linux_architecture_Name in
            *"linux-x86_64"*)
                mkdir -p /tmp/jaeles
                cd /tmp/jaeles && rm -f $jaeles_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/jaeles-project/jaeles/releases/download/$jaeles_Ver/$jaeles_bin > /dev/null 2>&1 || Echo_ERROR2
                unzip $jaeles_bin > /dev/null 2>&1
                mv $jaeles_sbin /usr/local/bin/jaeles && chmod +x /usr/local/bin/jaeles
                rm -rf /tmp/jaeles
                which jaeles > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $jaeles_Ver in the /usr/local/bin/" || Echo_ERROR3
                ;;
            *"linux-arm64"*)
                go install github.com/jaeles-project/jaeles@latest
                mv $GOPATH/bin/jaeles /usr/local/bin/jaeles && chmod +x /usr/local/bin/jaeles
                which jaeles > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the /usr/local/bin/" || Echo_ERROR3
                ;;
        esac
    fi

}

# ===================== Install Girsh =====================
Pentest_Girsh_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            Girsh_bin=$Girsh_bin_amd64
            ;;
        *"linux-arm64"*)
            Girsh_bin=$Girsh_bin_arm64
            ;;
    esac

    name="Girsh"
    which Girsh > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && rm -f $Girsh_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/nodauf/Girsh/releases/download/$Girsh_Ver/$Girsh_bin > /dev/null 2>&1 || Echo_ERROR2
        tar -zxvf $Girsh_bin > /dev/null 2>&1
        mv --force Girsh /usr/local/bin/ && chmod +x /usr/local/bin/Girsh && rm -f /tmp/$Girsh_bin > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $Girsh_Ver in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# ===================== Install See-SURF =====================
Pentest_See-SURF_Install(){

    name="See-SURF"
    dir="$P_Dir/See-SURF"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/In3tinct/See-SURF.git $dir > /dev/null 2>&1 && Echo_INFOR "Downloaded $name" || Echo_ERROR2
        cd $dir && python3 see-surf.py -h > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

}

# ===================== Install subjs =====================
Pentest_subjs_Install(){

    name="subjs"
    which subjs > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        case $Linux_architecture_Name in
            *"linux-x86_64"*)
                mkdir -p /tmp/subjs
                cd /tmp/subjs && rm -f $subjs_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/lc/subjs/releases/download/$subjs_Ver/$subjs_bin > /dev/null 2>&1 || Echo_ERROR2
                tar -zxvf $subjs_bin > /dev/null 2>&1
                mv subjs /usr/local/bin/subjs && chmod +x /usr/local/bin/subjs
                rm -rf /tmp/subjs
                which subjs > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $subjs_Ver in the /usr/local/bin/" || Echo_ERROR3
                ;;
            *"linux-arm64"*)
                go install github.com/lc/subjs@latest
                mv $GOPATH/bin/subjs /usr/local/bin/subjs && chmod +x /usr/local/bin/subjs
                which subjs > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the /usr/local/bin/" || Echo_ERROR3
                ;;
        esac
    fi

}

# ===================== Install assetfinder =====================
Pentest_assetfinder_Install(){

    name="assetfinder"
    which assetfinder > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        case $Linux_architecture_Name in
            *"linux-x86_64"*)
                mkdir -p /tmp/assetfinder
                cd /tmp/assetfinder && rm -f $assetfinder_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/tomnomnom/assetfinder/releases/download/$assetfinder_Ver/$assetfinder_bin > /dev/null 2>&1 || Echo_ERROR2
                tar -xzvf $assetfinder_bin > /dev/null 2>&1
                mv assetfinder /usr/local/bin/assetfinder && chmod +x /usr/local/bin/assetfinder
                rm -rf /tmp/assetfinder
                which assetfinder > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $assetfinder_Ver in the /usr/local/bin/" || Echo_ERROR3
                ;;
            *"linux-arm64"*)
                go install github.com/tomnomnom/assetfinder@latest
                mv $GOPATH/bin/assetfinder /usr/local/bin/assetfinder && chmod +x /usr/local/bin/assetfinder
                which assetfinder > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the /usr/local/bin/" || Echo_ERROR3
                ;;
        esac
    fi

}

# ===================== Install hakrawler =====================
Pentest_hakrawler_Install(){

    GO_Check

    name="hakrawler"
    which hakrawler > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        Echo_INFOR "Local compilation and installation, if the compilation timeout, please deal with it yourself"
        cd /tmp && rm -rf hakrawler
        $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/hakluke/hakrawler.git > /dev/null 2>&1 && cd hakrawler || Echo_ERROR2
        go build hakrawler.go
        mv hakrawler /usr/local/bin/hakrawler && chmod +x /usr/local/bin/hakrawler && rm -rf /tmp/hakrawler
        which hakrawler > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# ===================== Install routersploit =====================
Pentest_routersploit_Install(){

    name="routersploit"
    dir="$P_Dir/routersploit"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/threat9/routersploit.git $dir > /dev/null 2>&1 && cd $dir || Echo_ERROR2
        Echo_ALERT "Installing dependency modules" && pip3 install -r requirements.txt > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
        case $Linux_Version in
            *"Kali"*|*"Ubuntu"*|*"Debian"*)
                Echo_ALERT "Installing Bluetooth Low Energy support"
                Rm_Lock
                Install_Switch "libglib2.0-dev"
                Install_Switch5 "bluepy"
                ;;
            *) ;;
        esac

    fi

}

# git clone 时间过长,默认不安装
# ===================== Install exploitdb 库 =====================
Pentest_exploitdb_Install(){

    name="exploitdb"
    dir="$P_Dir/exploitdb"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/offensive-security/exploitdb.git $dir > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

}

# 不友好的 wiki 和使用帮助
# ===================== Install RustScan =====================
Pentest_RustScan_Install(){

    name="RustScan"
    which rustscan > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        case $Linux_Version in
            *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                rm -f /var/cache/dnf/metadata_lock.pid > /dev/null 2>&1
                $Proxy_OK dnf install -y 'dnf-command(copr)' > /dev/null 2>&1 && $Proxy_OK dnf copr enable atim/rustscan -y > /dev/null 2>&1 && $Proxy_OK dnf install -y rustscan > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name" || Echo_ERROR3
                ;;
            *"Kali"*|*"Ubuntu"*|*"Debian"*)
                cd /tmp && rm -f $RustScan_Install > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/RustScan/RustScan/releases/download/$RustScan_Version/$RustScan_Install > /dev/null 2>&1 || Echo_ERROR2
                dpkg -i $RustScan_Install > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name" || Echo_ERROR3
                rm -f $RustScan_Install > /dev/null 2>&1
                ;;
            *) ;;
        esac

    fi

}

# 使用较少,默认不安装
# ===================== Install WAFW00F =====================
Pentest_WAFW00F_Install(){

    name="WAFW00F"
    dir="$P_Dir/wafw00f"

    which wafw00f > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        rm -rf $dir && $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/EnableSecurity/wafw00f $dir > /dev/null 2>&1 || Echo_ERROR2
        cd $dir && python3 setup.py install > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name" || Echo_ERROR3
    fi

}

# 依赖库报错,默认不安装
# ===================== Install WebAliveScan =====================
Pentest_WebAliveScan_Install(){

    name="WebAliveScan"
    dir="$P_Dir/WebAliveScan"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/broken5/WebAliveScan.git $dir > /dev/null 2>&1 && cd $dir || Echo_ERROR2
        pip3 install -r requirements.txt > /dev/null 2>&1 && Echo_INFOR "Installed dependency modules" && Install_Switch4 "gevent" || { Echo_ERROR "Failed to install dependency module"; rm -rf $dir; }
        python3 webscan.py --help > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir" || Echo_ERROR3
    fi

}

# 实际使用较少默认不安装
# ===================== Install MassBleed =====================
Pentest_MassBleed_Install(){

    name="MassBleed"
    dir="$P_Dir/MassBleed"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/1N3/MassBleed.git $dir > /dev/null 2>&1 && Echo_INFOR "Downloaded $name in the $dir" || Echo_ERROR2
    fi

}

# 实际使用较少默认不安装
# ===================== Install jmet =====================
Pentest_jmet_Install(){

    name="jmet"
    dir="$P_Dir/jmet"

    if test -e $dir/jmet.jar
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        mkdir -p $dir && cd $_ && rm -f jmet.jar > /dev/null 2>&1 && $Proxy_OK wget -O jmet.jar ${GitProxy2}https://github.com/matthiaskaiser/jmet/releases/download/0.1.0/jmet-0.1.0-all.jar > /dev/null 2>&1 || Echo_ERROR2
        if test -e $dir/jmet.jar
        then
            Echo_INFOR "Successfully installed $name in the $dir"
        else
            Echo_ERROR3
        fi
    fi

}

# ===================== Install unyaffs =====================
unyaffs_Install(){

    name="unyaffs"

    cd $T_Dir && rm -f unyaffs > /dev/null 2>&1 && $Proxy_OK wget -O unyaffs ${GitProxy2}https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/unyaffs/unyaffs > /dev/null 2>&1 || Echo_ERROR2
    mv --force unyaffs /usr/local/bin/unyaffs && chmod +x /usr/local/bin/unyaffs && Echo_INFOR "Successfully installed $name 在 /usr/local/bin/" || Echo_ERROR3

}

# ===================== Install Fail2Ban =====================
Secure_Fail2Ban_Install(){

    name="Fail2Ban"
    fail2ban-client -V > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        Rm_Lock
        Install_Switch "fail2ban"
        systemctl restart fail2ban > /dev/null 2>&1 && sleep 1.5
        fail2ban-client ping
    fi

}

# ===================== Install chkrootkit =====================
Secure_chkrootkit_Install(){

    name="chkrootkit"

    if test -d $T_Dir/chkrootkit-*
    then
        Echo_ALERT "$name is already installed in $T_Dir/"
    else
        cd $T_Dir && rm -f chkrootkit.tar.gz > /dev/null 2>&1 && $Proxy_OK wget ftp://ftp.pangeia.com.br/pub/seg/pac/chkrootkit.tar.gz > /dev/null 2>&1 && Echo_INFOR "Downloaded $name" || Echo_ERROR2
        tar zxvf chkrootkit.tar.gz > /dev/null 2>&1 && rm -f chkrootkit.tar.gz > /dev/null 2>&1
        cd chkrootkit-* && make sense > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $T_Dir" || Echo_ERROR3
    fi

}

# ===================== Install rkhunter =====================
Secure_rkhunter_Install(){

    name="rkhunter"
    which rkhunter > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        Rm_Lock
        Install_Switch "rkhunter"
    fi

}

# ===================== Install shellpub =====================
Secure_shellpub_Install(){

    name="shellpub"

    if test -d $T_Dir/hm
    then
        Echo_ALERT "$name is already installed in $T_Dir/hm"
    else
        mkdir -p $T_Dir/hm && cd $_ && $Proxy_OK wget -O hm-linux.tgz http://dl.shellpub.com/hm/latest/hm-linux-amd64.tgz?version=1.8.2 > /dev/null 2>&1 && Echo_INFOR "Downloaded shellpub" || Echo_ERROR2
        tar zxvf hm-linux.tgz > /dev/null 2>&1 && rm -f hm-linux.tgz > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $T_Dir/hm" || Echo_ERROR3
    fi

}

# ===================== Install anti-portscan =====================
Secure_anti_portscan_Install(){

    name="anti-portscan"

    if test -d $T_Dir/anti-portscan
    then
        Echo_ALERT "$name is already installed in $T_Dir/anti-portscan"
    else
        cd $T_Dir && rm -f anti-portscan > /dev/null 2>&1 && $Proxy_OK git clone ${GitProxy}https://github.com/EtherDream/anti-portscan.git > /dev/null 2>&1 && Echo_INFOR "Downloaded anti-portscan in the $T_Dir/anti-portscan" || Echo_ERROR2
    fi

}

# ===================== Install BruteShark =====================
Secure_BruteShark_Install(){

    name="BruteShark"
    dir="$T_Dir/BruteShark"

    if test -d $T_Dir/BruteShark
    then
        Echo_ALERT "$name is already installed in $T_Dir/ "
    else
        Rm_Lock
        case $Linux_Version in
            *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                Install_Switch "libpcap"
                Install_Switch "libpcap-devel"
                ;;
            *"Kali"*|*"Ubuntu"*|*"Debian"*)
                Install_Switch "libpcap-dev"
                ;;
            *) ;;
        esac
        mkdir -p $T_Dir/BruteShark && cd $_ && $Proxy_OK wget ${GitProxy}https://github.com/odedshimon/BruteShark/releases/latest/download/BruteSharkCli > /dev/null 2>&1 && chmod +x BruteSharkCli && Echo_INFOR "Downloaded $name in the $dir " || Echo_ERROR2
        find /usr/lib/x86_64-linux-gnu -type f | grep libpcap | head -1 | xargs -i sudo ln -s {} /usr/lib/x86_64-linux-gnu/libpcap.so > /dev/null 2>&1
    fi

}

# ===================== Install fapro =====================
Secure_fapro_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            fapro_bin=$fapro_bin_amd64
            ;;
        *"linux-arm64"*)
            fapro_bin=$fapro_bin_arm64
            ;;
    esac

    name="fapro"
    which fapro > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && rm -f $fapro_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/fofapro/fapro/releases/download/$fapro_Ver/$fapro_bin > /dev/null 2>&1 || Echo_ERROR2
        tar -zxvf $fapro_bin > /dev/null 2>&1
        mv --force fapro /usr/local/bin/ && chmod +x /usr/local/bin/fapro && rm -f /tmp/$fapro_bin > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $fapro_Ver in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# ===================== Install Bash_Insulter =====================
Bash_Insulter(){

    name="Bash_Insulter"

    if test -e /etc/bash.command-not-found
    then
        Echo_ALERT "$name is already installed in /etc/bash.command-not-found"
    else
        rm -rf $T_Dir/bash-insulter > /dev/null 2>&1 && $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/No-Github/bash-insulter.git $T_Dir/bash-insulter > /dev/null 2>&1 || Echo_ERROR2
        mv --force $T_Dir/bash-insulter/src/bash.command-not-found /etc/ && rm -rf $T_Dir/bash-insulter > /dev/null 2>&1
        chmod 777 /etc/bash.command-not-found && Echo_INFOR ":)"

        case $Linux_Version in
            *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                echo ". /etc/bash.command-not-found" >> /etc/bashrc
                ;;
            *"Kali"*|*"Ubuntu"*|*"Debian"*)
                echo ". /etc/bash.command-not-found" >> /etc/bash.bashrc
                ;;
            *) ;;
        esac
    fi

}

# ===================== Install vlmcsd =====================
vlmcsd_Install(){

    name="vlmcsd"

    if test -d $T_Dir/vlmcsd
    then
        Echo_ALERT "$name is already installed in $T_Dir/vlmcsd"
    else
        cd $T_Dir && rm -f binaries.tar.gz > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/Wind4/vlmcsd/releases/download/svn1113/binaries.tar.gz > /dev/null 2>&1 || Echo_ERROR2
        tar -xzvf binaries.tar.gz > /dev/null 2>&1
        mv --force binaries vlmcsd && rm -f binaries.tar.gz > /dev/null 2>&1 && Echo_INFOR "$name is already installed in $T_Dir/vlmcsd, the vlmcsd service can be run with the following command:\ncd $T_Dir/vlmcsd/Linux/intel/static && ./vlmcsd-x86-musl-static"
    fi

}

# ===================== Install AdGuardHome =====================
AdGuardHome_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            AdGuardHome_File=$AdGuardHome_File_amd64
            ;;
        *"linux-arm64"*)
            AdGuardHome_File=$AdGuardHome_File_arm64
            ;;
    esac

    name="AdGuardHome"

    if test -d $T_Dir/AdGuardHome
    then
        Echo_ALERT "AdGuardHome is already installed in $T_Dir/AdGuardHome"
    else
        cd $T_Dir && rm -f $AdGuardHome_File > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/AdguardTeam/AdGuardHome/releases/download/$AdGuardHome_Version/$AdGuardHome_File > /dev/null 2>&1 || Echo_ERROR2
        tar -xzvf $AdGuardHome_File > /dev/null 2>&1 && rm -f $AdGuardHome_File > /dev/null 2>&1
        cd AdGuardHome && Echo_INFOR "Successfully installed $name $AdGuardHome_Version , run the following command to enable the AdGuardHome service\n\033[0m\033[1;32mcd $T_Dir/AdGuardHome && ./AdGuardHome -s install" || Echo_ERROR3
    fi

}

# ===================== Install trash-cli =====================
trash-cli_Install(){

    name="trash-cli"
    trash-list --version > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        pip3 install trash-cli > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name" || Echo_ERROR3
    fi

}

# ===================== Install thefuck =====================
thefuck_Install(){

    name="thefuck"
    which thefuck > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        Install_Switch4 "thefuck"
    fi

}

# ===================== Install fzf =====================
fzf_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            fzf_bin=$fzf_bin_amd64
            ;;
        *"linux-arm64"*)
            fzf_bin=$fzf_bin_arm64
            ;;
    esac

    name="fzf"
    which fzf > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && rm -f $fzf_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/junegunn/fzf/releases/download/$fzf_Ver/$fzf_bin > /dev/null 2>&1 || Echo_ERROR2
        tar -zxvf $fzf_bin > /dev/null 2>&1 && mv fzf /usr/local/bin/fzf && chmod +x /usr/local/bin/fzf && rm -f $fzf_bin > /dev/null 2>&1
        fzf --version > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name" || Echo_ERROR3
    fi

}

# ===================== Install lux =====================
lux_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            lux_bin=$lux_bin_amd64
            ;;
        *"linux-arm64"*)
            lux_bin=$lux_bin_arm64
            ;;
    esac

    name="lux"
    which lux > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && rm -f $lux_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/iawia002/lux/releases/download/$lux_Ver/$lux_bin > /dev/null 2>&1 || Echo_ERROR2
        tar -zxvf $lux_bin > /dev/null 2>&1
        mv --force lux /usr/local/bin/lux && chmod +x /usr/local/bin/lux && rm -f $lux_bin > /dev/null 2>&1
        lux -v > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $lux_Ver in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# ===================== Install you-get =====================
you-get_Install(){

    name="you-get"
    which you-get > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        Install_Switch4 "you-get"
    fi

}

# ===================== Install ffmpeg =====================
ffmpeg_Install(){

    name="ffmpeg"
    which ffmpeg > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        Rm_Lock
        case $Linux_Version in
            *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                Echo_INFOR "The current script does not support RedHat system, this item Pass"
                ;;
            *"Kali"*|*"Ubuntu"*|*"Debian"*)
                Install_Switch "ffmpeg"
                ;;
            *) ;;
        esac
    fi

}

# ===================== Install aria2 =====================
aria2_Install(){

    name="aria2"
    which aria2c > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        Rm_Lock
        Install_Switch "aria2"
    fi

    Echo_INFOR "Recommended Projects : https://github.com/P3TERX/aria2.sh"
    Echo_INFOR "wget -N git.io/aria2.sh && chmod +x aria2.sh && bash aria2.sh"

}

# ===================== Install filebrowser =====================
filebrowser_Install(){

    name="filebrowser"
    which filebrowser > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed, Run the following command to turn on the service:"
    else
        cd /tmp && $Proxy_OK curl -o install.sh https://raw.githubusercontent.com/filebrowser/get/master/get.sh > /dev/null 2>&1 && $Proxy_OK bash install.sh > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name, Run the following command to turn on the service:" || Echo_ERROR2
    fi

    Echo_INFOR "filebrowser -a [Listening IP] -r [Folder path]" && Echo_INFOR "Default account password admin"

}

# ===================== Install starship =====================
starship_Install(){

    name="starship"
    starship --version > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && rm -f install.sh > /dev/null 2>&1 && $Proxy_OK curl -o install.sh https://starship.rs/install.sh > /dev/null 2>&1 && $Proxy_OK bash install.sh && Echo_INFOR "Successfully installed $name" || Echo_ERROR2
        rm -f /tmp/install.sh > /dev/null 2>&1
    fi

    Echo_INFOR "Bash :  echo \"eval \\\"\\\$(starship init bash)\\\"\" >> ~/.bashrc"
    Echo_INFOR "Fish :  echo \"starship init fish | source\" >> ~/.config/fish/config.fish"
    Echo_INFOR "Zsh  :  echo \"eval \\\"\\\$(starship init zsh)\\\"\" >> ~/.zshrc"

}

# ===================== Install ttyd =====================
ttyd_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            ttyd_bin=$ttyd_bin_amd64
            ;;
        *"linux-arm64"*)
            ttyd_bin=$ttyd_bin_arm64
            ;;
    esac

    name="ttyd"
    which ttyd > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        $Proxy_OK wget -O /usr/local/bin/ttyd ${GitProxy}https://github.com/tsl0922/ttyd/releases/download/$ttyd_Ver/$ttyd_bin > /dev/null 2>&1 || Echo_ERROR2
        chmod +x /usr/local/bin/ttyd
        which ttyd > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $ttyd_Ver in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# ===================== Install duf =====================
duf_Install(){

    name="duf"
    which duf > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        case $Linux_Version in
            *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)

                case $Linux_architecture_Name in
                    *"linux-x86_64"*)
                        duf_bin1=$duf_bin1_amd64
                        ;;
                    *"linux-arm64"*)
                        duf_bin1=$duf_bin1_arm64
                        ;;
                esac

                mkdir -p /tmp/dufinstall && cd $_ && $Proxy_OK wget ${GitProxy}https://github.com/muesli/duf/releases/download/$duf_Ver/$duf_bin1 > /dev/null 2>&1 || Echo_ERROR2
                rpm -i $duf_bin1 > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $duf_Ver" || Echo_ERROR3
                rm -rf /tmp/dufinstall
                ;;
            *"Kali"*|*"Ubuntu"*|*"Debian"*)

                case $Linux_architecture_Name in
                    *"linux-x86_64"*)
                        duf_bin2=$duf_bin2_amd64
                        ;;
                    *"linux-arm64"*)
                        duf_bin2=$duf_bin2_arm64
                        ;;
                esac

                mkdir -p /tmp/dufinstall && cd $_ && $Proxy_OK wget ${GitProxy}https://github.com/muesli/duf/releases/download/$duf_Ver/$duf_bin2 > /dev/null 2>&1 || Echo_ERROR2
                dpkg -i $duf_bin2 > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $duf_Ver" || Echo_ERROR3
                rm -rf /tmp/dufinstall
                ;;
            *) ;;
        esac
    fi

}

# ===================== Install yq =====================
yq_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            yq_File=$yq_File_amd64
            yq_bin=$yq_bin_amd64
            ;;
        *"linux-arm64"*)
            yq_File=$yq_File_arm64
            yq_bin=$yq_bin_arm64
            ;;
    esac

    name="yq"
    which yq > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/yqinstall && cd $_
        $Proxy_OK wget ${GitProxy}https://github.com/mikefarah/yq/releases/download/$yq_Ver/$yq_File > /dev/null 2>&1 || Echo_ERROR2
        tar -zxvf $yq_File > /dev/null 2>&1
        mv --force $yq_bin /usr/local/bin/yq && chmod +x /usr/local/bin/yq
        which yq > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $yq_Ver in the /usr/local/bin/" || Echo_ERROR3
        rm -rf /tmp/yqinstall
    fi

}

# ===================== Install procs =====================
procs_Install(){

    name="procs"
    which procs > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/procsinstall && cd $_
        $Proxy_OK wget ${GitProxy}https://github.com/dalance/procs/releases/download/$procs_Ver/$procs_bin > /dev/null 2>&1 || Echo_ERROR2
        unzip $procs_bin > /dev/null 2>&1
        mv --force procs /usr/local/bin/procs && chmod +x /usr/local/bin/procs
        which procs > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $procs_Ver in the /usr/local/bin/" || Echo_ERROR3
        rm -rf /tmp/procsinstall
    fi

}

# ===================== Install ncdu =====================
ncdu_Install(){

    name="ncdu"
    which ncdu > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        Install_Switch "ncdu"
    fi

}

# ===================== Install exa =====================
exa_Install(){

    name="exa"
    which exa > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        Install_Switch "exa"
    fi

}

# ===================== Install htop =====================
htop_Install(){

    name="htop"
    which htop > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        Install_Switch "htop"
    fi

}

# ===================== Install bat =====================
bat_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            bat_bin=$bat_bin_amd64
            ;;
        *"linux-arm64"*)
            bat_bin=$bat_bin_arm64
            ;;
    esac

    name="bat"
    which bat > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/batinstall && cd $_
        $Proxy_OK wget ${GitProxy}https://github.com/sharkdp/bat/releases/download/$bat_Ver/$bat_bin > /dev/null 2>&1 || Echo_ERROR2
        dpkg -i $bat_bin > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $bat_Ver" || Echo_ERROR3
        rm -rf /tmp/batinstall
    fi

}

# ===================== Install fd =====================
fd_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            fd_bin=$fd_bin_amd64
            ;;
        *"linux-arm64"*)
            fd_bin=$fd_bin_arm64
            ;;
    esac

    name="fd"
    which fd > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/fdinstall && cd $_
        $Proxy_OK wget ${GitProxy}https://github.com/sharkdp/fd/releases/download/$fd_Ver/$fd_bin > /dev/null 2>&1 || Echo_ERROR2
        dpkg -i $fd_bin > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $fd_Ver" || Echo_ERROR3
        rm -rf /tmp/fdinstall
    fi

}

# ===================== Install ctop =====================
ctop_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            ctop_bin=$ctop_bin_amd64
            ;;
        *"linux-arm64"*)
            ctop_bin=$ctop_bin_arm64
            ;;
    esac

    name="ctop"
    which ctop > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/ctop && cd $_
        $Proxy_OK wget ${GitProxy}https://github.com/bcicen/ctop/releases/download/$ctop_Ver/$ctop_bin > /dev/null 2>&1 || Echo_ERROR2
        mv /tmp/ctop/$ctop_bin /usr/local/bin/ctop && chmod +x /usr/local/bin/ctop && rm -rf /tmp/ctop
        which ctop > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $ctop_Ver" || Echo_ERROR3
        rm -rf /tmp/ctop
    fi

}

# -code
# ===================== Install code-server =====================
code-server_Install(){

    name="code-server"
    which code-server > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        case $Linux_Version in
            *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                case $Linux_architecture_Name in
                    *"linux-x86_64"*)
                        code_server_bin1=$code_server_bin1_amd64
                        ;;
                    *"linux-arm64"*)
                        code_server_bin1=$code_server_bin1_arm64
                        ;;
                esac

                mkdir -p /tmp/code-serverinstall && cd $_ && $Proxy_OK wget ${GitProxy}https://github.com/cdr/code-server/releases/download/$code_server_Ver/$code_server_bin1 ${wget_option} || Echo_ERROR2
                rpm -i $code_server_bin1 > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $code_server_Ver" || Echo_ERROR3
                rm -rf /tmp/code-serverinstall
                # sudo systemctl enable --now code-server@$USER
                # Now visit http://127.0.0.1:8080. Your password is in ~/.config/code-server/config.yaml
                ;;
            *"Kali"*|*"Ubuntu"*|*"Debian"*)
                case $Linux_architecture_Name in
                    *"linux-x86_64"*)
                        code_server_bin2=$code_server_bin2_amd64
                        ;;
                    *"linux-arm64"*)
                        code_server_bin2=$code_server_bin2_arm64
                        ;;
                esac

                mkdir -p /tmp/code-serverinstall && cd $_ && $Proxy_OK wget ${GitProxy}https://github.com/cdr/code-server/releases/download/$code_server_Ver/$code_server_bin2 ${wget_option} || Echo_ERROR2
                dpkg -i $code_server_bin2 > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $code_server_Ver" || Echo_ERROR3
                rm -rf /tmp/code-serverinstall
                # sudo systemctl enable --now code-server@$USER
                # Now visit http://127.0.0.1:8080. Your password is in ~/.config/code-server/config.yaml
                ;;
            *) ;;
        esac
    fi

}

# ===================== Install wait-for =====================
wait-for_Install(){

    name="wait-for"
    if test -e $T_Dir/wait-for
    then
        Echo_ALERT "$name is already installed in $T_Dir"
    else
        $Proxy_OK curl -o $T_Dir/wait-for ${GitProxy}https://raw.githubusercontent.com/eficode/wait-for/master/wait-for > /dev/null 2>&1 && Echo_INFOR "Downloaded $name in the $T_Dir" || Echo_ERROR2
    fi

}

# -vol
Volatility_Install(){

    name="Volatility"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    case $Linux_Version in
        *"Ubuntu"*|*"Debian"*)

            which volatility > /dev/null 2>&1

            if [ $? == 0 ]
            then
                Echo_ALERT "$name installed"
            else
                Rm_Lock
                Install_Switch3 "distorm3==3.4.4"
                Install_Switch3 "yara-python"
                Install_Switch "xdot"
                ln -s /usr/local/lib/python2.7/dist-packages/usr/lib/libyara.so /usr/lib/libyara.so > /dev/null 2>&1
                Install_Switch "volatility"
            fi

            ;;
        *)
            if test -d $P_Dir/volatility
            then
                Echo_ALERT "$name is already installed in $P_Dir/volatility"
            else
                Rm_Lock
                case $Linux_Version in
                    *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                        Install_Switch "pcre-devel"
                        Install_Switch "libpcre++-devel"
                        Install_Switch "python-devel"
                        Install_Switch "pycrypto"
                        ;;
                    *) ;;
                esac

                Install_Switch3 "distorm3==3.4.4"
                Install_Switch3 "yara-python"
                ln -s /usr/local/lib/python2.7/dist-packages/usr/lib/libyara.so /usr/lib/libyara.so > /dev/null 2>&1

                $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/volatilityfoundation/volatility.git $P_Dir/volatility > /dev/null 2>&1 && Echo_INFOR "Downloaded $name" || Echo_ERROR2
                cd $P_Dir/volatility && python setup.py build > /dev/null 2>&1 || Echo_ERROR "Failed to install dependency module"
                python setup.py install > /dev/null 2>&1 || Echo_ERROR "Failed to install dependency module"
                python vol.py --info > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $P_Dir/volatility" || Echo_ERROR3
            fi
            ;;
    esac

}

# -vol3
volatility3_Install(){

    name="volatility3"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    if test -d $P_Dir/volatility3
    then
        Echo_ALERT "$name is already installed in $P_Dir/volatility3"
    else

        case $Linux_Version in
            *"Kali"*|*"Ubuntu"*|*"Debian"*)
                Rm_Lock
                Install_Switch "xdot"
                ;;
            *) ;;
        esac

        $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/volatilityfoundation/volatility3.git $P_Dir/volatility3 > /dev/null 2>&1 && Echo_INFOR "Downloaded $name" || Echo_ERROR2
        cd $P_Dir/volatility3 && python3 setup.py build > /dev/null 2>&1 || Echo_ERROR "Failed to install dependency module"
        python3 setup.py install > /dev/null 2>&1 || Echo_ERROR "Failed to install dependency module"
        python3 vol.py -h > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $P_Dir/volatility3" || Echo_ERROR3
    fi

    if test -d $P_Dir/volatility3/symbols
    then
        Echo_ALERT "$P_Dir/volatility3/symbols folder already exists"
    else
        Echo_ALERT "Symbol Tables download command is as follows, we suggest you download it by yourself"
        Echo_INFOR "cd /tmp && wget https://downloads.volatilityfoundation.org/volatility3/symbols/windows.zip"
        Echo_INFOR "wget https://downloads.volatilityfoundation.org/volatility3/symbols/mac.zip"
        Echo_INFOR "wget https://downloads.volatilityfoundation.org/volatility3/symbols/linux.zip"
        Echo_INFOR "mkdir -p $P_Dir/volatility3/symbols"
        Echo_INFOR "mv --force /tmp/windows.zip $P_Dir/volatility3/symbols"
        Echo_INFOR "mv --force /tmp/mac.zip $P_Dir/volatility3/symbols"
        Echo_INFOR "mv --force /tmp/linux.zip $P_Dir/volatility3/symbols"

        # echo -e "\033[1;33m\n>> Downloading Symbol Tables \n\033[0m"
        # cd /tmp && $Proxy_OK wget https://downloads.volatilityfoundation.org/volatility3/symbols/windows.zip > /dev/null 2>&1
        # $Proxy_OK wget https://downloads.volatilityfoundation.org/volatility3/symbols/mac.zip > /dev/null 2>&1
        # $Proxy_OK wget https://downloads.volatilityfoundation.org/volatility3/symbols/linux.zip > /dev/null 2>&1
        # mkdir -p $P_Dir/volatility3/symbols
        # mv --force /tmp/windows.zip $P_Dir/volatility3/symbols && Echo_INFOR "Downloaded windows Symbol Tables in the $P_Dir/volatility3/symbols " || Echo_ERROR "windows Symbol Tables download failed"
        # mv --force /tmp/mac.zip $P_Dir/volatility3/symbols && Echo_INFOR "Downloaded mac Symbol Tables in the $P_Dir/volatility3/symbols " || Echo_ERROR "windows Symbol Tables download failed"
        # mv --force /tmp/linux.zip $P_Dir/volatility3/symbols && Echo_INFOR "Downloaded linux Symbol Tables in the $P_Dir/volatility3/symbols " || Echo_ERROR "windows Symbol Tables download failed"
    fi

}

# -lt
lt_Install(){

    Docker_Check
    name="LogonTracer"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    docker pull jpcertcc/docker-logontracer && Echo_INFOR "Pulled the latest LogonTracer image, please run through the following command:\ndocker run --name logontracer --detach -p 7474:7474 -p 7687:7687 -p 8080:8080 -e LTHOSTNAME=[IP_Address] jpcertcc/docker-logontracer\n\n-browser access：http://[IP_Address]:8080/" || Echo_ERROR3

}

# -binwalk
binwalk_Install(){

    name="binwalk"
    which binwalk > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        echo -e "\033[1;33m\n>> Installing binwalk\n\033[0m"
        case $Linux_Version in
            *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                Echo_INFOR "RedHat system is not recommended to install, this item Pass\n"
                ;;
            *"Kali"*|*"Ubuntu"*|*"Debian"*)
                Echo_ALERT "Installing binwalk"
                cd $T_Dir && rm -rf binwalk > /dev/null 2>&1 && $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/ReFirmLabs/binwalk.git > /dev/null 2>&1 && cd binwalk  > /dev/null 2>&1 || Echo_ERROR2
                $Proxy_OK sudo ./deps.sh && python setup.py uninstall > /dev/null 2>&1 && python setup.py install > /dev/null 2>&1
                binwalk -h > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name" && touch /tmp/f8x_binwalk.txt > /dev/null 2>&1 || Echo_ERROR "binwalk installation failed, recommended to use -binwalk-f for installation"
                echo -e "\033[1;33m\n>> Installing unyaffs\n\033[0m"
                unyaffs_Install
                ;;
            *) ;;
        esac
    fi

}

# -binwalk-f
binwalk_force_Install(){

    name="binwalk"
    which binwalk > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else

        echo -e "\033[1;33m\n>> Installing binwalk\n\033[0m"
        case $Linux_Version in
            *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                Echo_INFOR "RedHat system is not recommended to install, this item Pass\n"
                ;;
            *"Kali"*|*"Ubuntu"*|*"Debian"*)
                Rm_Lock
                Install_Switch "python3-pip"
                Install_Switch "python-lzma"
                Install_Switch "python3-crypto"
                Install_Switch "libqt4-opengl"
                Install_Switch "python3-opengl"
                Install_Switch "python3-pyqt4"
                Install_Switch "python3-pyqt4.qtopengl"
                Install_Switch "python3-numpy"
                Install_Switch "python3-scipy"
                Install_Switch "python3-pip"
                Install_Switch "mtd-utils"
                Install_Switch "gzip"
                Install_Switch "bzip2"
                Install_Switch "tar"
                Install_Switch "arj"
                Install_Switch "lhasa"
                Install_Switch "p7zip"
                Install_Switch "p7zip-full"
                Install_Switch "cabextract"
                Install_Switch "cramfsprogs"
                Install_Switch "cramfsswap"
                Install_Switch "squashfs-tools"
                Install_Switch "sleuthkit"
                Install_Switch "default-jdk"
                Install_Switch "lzop"
                Install_Switch "srecord"
                Install_Switch "zlib1g-dev"
                Install_Switch "liblzma-dev"
                Install_Switch "liblzo2-dev"
                Install_Switch "python-lzo"
                pip install cstruct > /dev/null 2>&1 && Echo_INFOR "Successfully installed cstruct" || Echo_ERROR "cstruct installation failed"

                Install_Switch4 "nose"
                Install_Switch4 "coverage"
                Install_Switch4 "pyqtgraph"
                Install_Switch4 "capstone"

                # sasquatch
                name="sasquatch"
                echo -e "\033[1;33m\n>> Installing sasquatch\n\033[0m"
                cd $T_Dir && rm -rf sasquatch > /dev/null 2>&1 && $Proxy_OK git clone ${GitProxy}https://github.com/devttys0/sasquatch > /dev/null 2>&1 && cd sasquatch || Echo_ERROR2
                $Proxy_OK ./build.sh > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name" || Echo_ERROR3

                # jefferson
                name="jefferson"
                echo -e "\033[1;33m\n>> Installing jefferson\n\033[0m"
                cd $T_Dir && rm -rf jefferson > /dev/null 2>&1 && $Proxy_OK git clone ${GitProxy}https://github.com/sviehb/jefferson > /dev/null 2>&1 && cd jefferson || Echo_ERROR2
                $Proxy_OK python setup.py install > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name" || Echo_ERROR3

                # ubi_reader
                name="ubi_reader"
                echo -e "\033[1;33m\n>> Installing ubi_reader\n\033[0m"
                cd $T_Dir && rm -rf ubi_reader > /dev/null 2>&1 && $Proxy_OK git clone ${GitProxy}https://github.com/jrspruitt/ubi_reader > /dev/null 2>&1 && cd ubi_reader || Echo_ERROR2
                $Proxy_OK python setup.py install > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name" || Echo_ERROR3

                # yaffshiv
                name="yaffshiv"
                echo -e "\033[1;33m\n>> Installing yaffshiv\n\033[0m"
                cd $T_Dir && rm -rf yaffshiv > /dev/null 2>&1 && $Proxy_OK git clone ${GitProxy}https://github.com/devttys0/yaffshiv > /dev/null 2>&1 && cd yaffshiv || Echo_ERROR2
                $Proxy_OK python setup.py install > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name" || Echo_ERROR3

                # unstuff
                name="unstuff"
                echo -e "\033[1;33m\n>> Installing unstuff\n\033[0m"
                cd $T_Dir && $Proxy_OK curl -o stuffit520.611linux-i386.tar.gz ${GitProxy2}https://github.com/No-Github/Archive/releases/download/1.0.7/stuffit520.611linux-i386.tar.gz > /dev/null 2>&1 && tar -zxvf stuffit520.611linux-i386.tar.gz > /dev/null 2>&1
                mv --force bin/unstuff /usr/local/bin/unstuff && chmod +x /usr/local/bin/unstuff && Echo_INFOR "Successfully installed $name" || Echo_ERROR3

                # unyaffs
                name="unyaffs"
                echo -e "\033[1;33m\n>> Installing unyaffs\n\033[0m"
                unyaffs_Install

                # binwalk
                name="binwalk"
                echo -e "\033[1;33m\n>> Installing binwalk\n\033[0m"
                cd $T_Dir && rm -rf binwalk > /dev/null 2>&1 && $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/ReFirmLabs/binwalk > /dev/null 2>&1 && cd binwalk || Echo_ERROR2

                python3 setup.py install > /dev/null 2>&1

                binwalk -h > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name" && touch /tmp/f8x_binwalk_force.txt > /dev/null 2>&1 || Echo_ERROR3
                ;;
            *) ;;
        esac

    fi

}

# -clamav
clamav_Install(){

    name="clamav"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    clamscan --version > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        Rm_Lock
        case $Linux_Version in
            *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                Install_Switch "clamav"
                Install_Switch "clamav-update"
                $Proxy_OK freshclam
                ;;
            *"Kali"*|*"Ubuntu"*|*"Debian"*)
                Install_Switch "clamav"
                systemctl stop clamav-freshclam.service
                $Proxy_OK freshclam -v
                ;;
            *) ;;
        esac
    fi

}

# -python2
Python2_Install(){

    name="python2"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    Rm_Lock
    case $Linux_Version in
        *"CentOS"*|*"RedHat"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)

            ( (python -h > /dev/null 2>&1 || python2 -h > /dev/null 2>&1) && Echo_INFOR "Successfully installed python2" ) || ( ( (yum install -y python > /dev/null 2>&1 || yum install -y python2 > /dev/null 2>&1) && Echo_INFOR "Successfully installed python2") || Echo_ERROR "python installation failed")

            ( yum install -y python-devel > /dev/null 2>&1 || yum install -y python2-devel > /dev/null 2>&1) && Echo_INFOR "Successfully installed python-devel" || Echo_ERROR "python-devel installation failed"
            yum install -y python2-pip > /dev/null 2>&1 && Echo_INFOR "Successfully installed python2-pip" || { Echo_ERROR "python2-pipinstallation failed, start autorun -pip2-force option"; pip2_Install; }
            ;;
        *"Fedora"*)
            yum install -y python > /dev/null 2>&1
            yum install -y python2 > /dev/null 2>&1 && Echo_INFOR "Successfully installed python2" || Echo_ERROR "python2 installation failed"
            yum install -y python-devel > /dev/null 2>&1
            yum install -y python2-devel > /dev/null 2>&1
            yum install -y python2-pip > /dev/null 2>&1 && Echo_INFOR "Successfully installed python2-pip" || { Echo_ERROR "python2-pip installation failed, start autorun -pip2-force option"; pip2_Install; }
            ;;
        *"Kali"*|*"Debian"*)
            Install_Switch "python"
            Install_Switch "python-dev"
            apt-get install -y python-pip > /dev/null 2>&1 && Echo_INFOR "Successfully installed python2-pip" || { Echo_ERROR "python2-pip installation failed, start autorun -pip2-force option"; pip2_Install; }
            Install_Switch3 "setuptools"
            ;;
        *"Ubuntu"*)
            Install_Switch "python"
            Install_Switch "python-dev"
            apt-get install -y python-pip > /dev/null 2>&1 && Echo_INFOR "Successfully installed python2-pip" || { Echo_ERROR "python2-pip installation failed, start autorun -pip2-force option"; pip2_Install; }
            Install_Switch3 "setuptools"
            case $Linux_Version_Num in
                "16.04")
                    cd /tmp && rm -rf get-pip.py && $Proxy_OK wget https://bootstrap.pypa.io/pip/2.7/get-pip.py > /dev/null 2>&1
                    $Proxy_OK python2 get-pip.py > /dev/null 2>&1 && rm -rf get-pip.py
                    ;;
            esac
            ;;
        *) ;;
    esac

}

# -pip2-force
pip2_Install(){

    echo -e "\033[1;33m\n>> Installing pip2\n\033[0m"
    cd $T_Dir && $Proxy_OK curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py > /dev/null 2>&1 || Echo_ERROR "https://bootstrap.pypa.io/get-pip.py download failed, please check if the network is reachable, proxychains4 configuration is correct"
    $Proxy_OK python2 get-pip.py > /dev/null 2>&1 && Echo_INFOR "Successfully installed python-pip" || Echo_ERROR "python-pip installation failed"
    rm -f get-pip.py > /dev/null 2>&1

    Install_Switch3 "setuptools"

}

# -ruby
Ruby_Install(){

    name="ruby"

    echo -e "\033[1;33m\n>> Installing Ruby\n\033[0m"
    Rm_Lock
    case $Linux_Version in
        *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
            Install_Switch "ruby"
            Install_Switch "rubygems"
            Install_Switch "ruby-devel"
            ;;
        *"Kali"*|*"Ubuntu"*|*"Debian"*)
            Install_Switch "ruby"
            Install_Switch "rubygems"
            Install_Switch "ruby-dev"
            ;;
        *) ;;
    esac

}

# -ruby-f
Ruby_Install_f(){

    name="ruby"

    echo -e "\033[1;33m\n>> Installing Ruby\n\033[0m"
    cd $T_Dir && rm -f $Ruby_bin > /dev/null 2>&1 && $Proxy_OK wget https://cache.ruby-lang.org/pub/ruby/$Ruby_Ver/$Ruby_bin ${wget_option} || Echo_ERROR2
    tar xvfvz $Ruby_bin > /dev/null 2>&1
    cd $Ruby_Dir && ./configure > /dev/null 2>&1 && make > /dev/null 2>&1 && make install > /dev/null 2>&1 && Echo_INFOR "Successfully installed $(ruby -v) in the /usr/local/bin/" || Echo_ERROR3
    rm -f $T_Dir/$Ruby_bin

}

# -rust
Rust_Install(){

    name="rust"

    echo -e "\033[1;33m\n>> Installing rust\n\033[0m"
    $Proxy_OK curl https://sh.rustup.rs -sSf | $Proxy_OK sh

}

# -chromium
chromium_Install(){

    echo -e "\033[1;33m\n>> Installing dependency libraries\n\033[0m"

    name="chromium"

    Rm_Lock
    case $Linux_Version in
        *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
            Install_Switch "pango.x86_64"
            Install_Switch "libXcomposite.x86_64"
            Install_Switch "libXcursor.x86_64"
            Install_Switch "libXdamage.x86_64"
            Install_Switch "libXext.x86_64"
            Install_Switch "libXi.x86_64"
            Install_Switch "libXtst.x86_64"
            Install_Switch "cups-libs.x86_64"
            Install_Switch "libXScrnSaver.x86_64"
            Install_Switch "libXrandr.x86_64"
            Install_Switch "libX11-xcb.x86_64"
            Install_Switch "GConf2.x86_64"
            Install_Switch "alsa-lib.x86_64"
            Install_Switch "atk.x86_64"
            Install_Switch "gtk3.x86_64"
            Install_Switch "ipa-gothic-fonts"
            Install_Switch "xorg-x11-fonts-100dpi"
            Install_Switch "xorg-x11-fonts-75dpi"
            Install_Switch "xorg-x11-utils"
            Install_Switch "xorg-x11-fonts-cyrillic"
            Install_Switch "xorg-x11-fonts-Type1"
            Install_Switch "xorg-x11-fonts-misc"
            ;;
        *"Kali"*|*"Ubuntu"*|*"Debian"*)
            Install_Switch2 "libasound2"
            Install_Switch2 "libatk1.0-0"
            Install_Switch2 "libc6"
            Install_Switch2 "libcairo2"
            Install_Switch2 "libcups2"
            Install_Switch2 "libdbus-1-3"
            Install_Switch2 "libexpat1"
            Install_Switch2 "libfontconfig1"
            Install_Switch2 "libgcc1"
            Install_Switch2 "libgconf-2-4"
            Install_Switch2 "libgdk-pixbuf2.0-0"
            Install_Switch2 "libglib2.0-0"
            Install_Switch2 "libgtk-3-0"
            Install_Switch2 "libnspr4"
            Install_Switch2 "libpango-1.0-0"
            Install_Switch2 "libpangocairo-1.0-0"
            Install_Switch2 "libstdc++6"
            Install_Switch2 "libx11-6"
            Install_Switch2 "libx11-xcb1"
            Install_Switch2 "libxcb1"
            Install_Switch2 "libxcursor1"
            Install_Switch2 "libxdamage1"
            Install_Switch2 "libxext6"
            Install_Switch2 "libxfixes3"
            Install_Switch2 "libxi6"
            Install_Switch2 "libxrandr2"
            Install_Switch2 "libxrender1"
            Install_Switch2 "libxss1"
            Install_Switch2 "libxtst6"
            Install_Switch2 "libnss3"
            Install_Switch2 "libgbm-dev"
            ;;
        *) ;;
    esac

    linux_arm64_Check || exit 1

    echo -e "\033[1;33m\n>> Installing chromium (~120M)\n\033[0m"

    cd $T_Dir && rm -rf chrome-linux* > /dev/null 2>&1 && $Proxy_OK wget https://storage.googleapis.com/chromium-browser-snapshots/Linux_x64/$chromium_Ver/chrome-linux.zip ${wget_option} || Echo_ERROR "download failed, please check if the network is reachable, proxychains4 configuration is correct"

    unzip chrome-linux.zip > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $T_Dir/chrome-linux" || Echo_ERROR3
    rm -f chrome-linux.zip > /dev/null 2>&1

}

# -phantomjs
phantomjs_Install(){

    name="PhantomJS"
    phantomjs -v > /dev/null 2>&1

    if [ $? == 0 ]
    then
        echo -e "\033[1;33m\n>> Installing $name\n\033[0m"
        Echo_ALERT "$name installed"
    else
        Rm_Lock
        echo -e "\033[1;33m\n>> Installing dependency libraries\n\033[0m"
        case $Linux_Version in
            *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                Install_Switch "gcc"
                Install_Switch "gcc-c++"
                Install_Switch "make"
                Install_Switch "openssl-devel"
                Install_Switch "freetype-devel"
                Install_Switch "fontconfig-devel"
                ;;
            *"Kali"*|*"Ubuntu"*|*"Debian"*)
                Install_Switch "build-essential"
                Install_Switch "chrpath"
                Install_Switch "git-core"
                Install_Switch "libssl-dev"
                Install_Switch "libfontconfig1-dev"
                Install_Switch "libxft-dev"
                ;;
            *) ;;
        esac

        echo -e "\033[1;33m\n>> Installing $name\n\033[0m"
        mkdir /tmp/phantomjs && cd $_ && rm -rf $phantomjs_bin > /dev/null 2>&1 && $Proxy_OK wget https://bitbucket.org/ariya/phantomjs/downloads/$phantomjs_bin ${wget_option} || Echo_ERROR "download failed, please check if the network is reachable, proxychains4 configuration is correct"
        tar -xvf $phantomjs_bin > /dev/null 2>&1
        mv $phantomjs_dir/bin/phantomjs /usr/local/bin/phantomjs && chmod +x /usr/local/bin/phantomjs && rm -rf /tmp/phantomjs
        which phantomjs > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name" || Echo_ERROR3
    fi
}

# -k8s
k8s_Install(){

    kubectl_Install

}

kubectl_Install(){

    name="kubectl"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    which kubectl > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_INFOR "$name installed"
    else
        case $Linux_architecture_Name in
            *"linux-x86_64"*)
                kubectl_version=$($Proxy_OK curl -L -s https://dl.k8s.io/release/stable.txt)
                mkdir /tmp/kubectl && cd $_ && rm -rf kubectl > /dev/null 2>&1 && $Proxy_OK wget https://dl.k8s.io/release/$kubectl_version/bin/linux/amd64/kubectl ${wget_option} || Echo_ERROR "download failed, please check if the network is reachable, proxychains4 configuration is correct"
                mv /tmp/kubectl/kubectl /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl && rm -rf /tmp/kubectl
                which kubectl > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $kubectl_version in the /usr/local/bin/" || Echo_ERROR3
                ;;
            *"linux-arm64"*)
                case $Linux_Version in
                    *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                        Echo_ERROR "The script currently supports only Debian installations of kubectl,bye bye~\n"
                        exit 1
                        ;;
                    *"Kali"*|*"Ubuntu"*|*"Debian"*)
                        $Proxy_OK curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
                        echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
                        apt-get update
                        apt-get install -y kubectl
                        ;;
                    *) ;;
                esac
                ;;
        esac
    fi

}

# -openjdk
Openjdk_Install(){

    name="openjdk"

    java -version > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_INFOR "java installed"
    else
        echo -e "\033[1;33m\n>> Installing Java environment(openjdk)\n\033[0m"
        Rm_Lock
        case $Linux_Version in
            *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                Install_Switch "java-1.8.0-openjdk"
                Install_Switch "java-1.8.0-openjdk-devel"
                java -version && Echo_INFOR "Successfully installed Java environment(openjdk)" || Echo_ERROR3
                ;;
            *"Kali"*|*"Ubuntu"*|*"Debian"*)
                Install_Switch "openjdk-11-jdk"
                java -version && Echo_INFOR "Successfully installed Java environment(openjdk)" || Echo_ERROR3
                ;;
            *) ;;
        esac
    fi

}

Oraclejdk_Install(){

    name="Oraclejdk"

    jenv_Install || jenv_Install

    case "$1" in
        oraclejdk8)
            Oraclejdk8_Install
            ;;
        oraclejdk11)
            Oraclejdk11_Install
            ;;
        *)
            Oraclejdk8_Install
            ;;
    esac

}

# -oraclejdk8
Oraclejdk8_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            orclejdk8_bin=$orclejdk8_bin_amd64
            ;;
        *"linux-arm64"*)
            orclejdk8_bin=$orclejdk8_bin_arm64
            ;;
    esac

    name="oraclejdk8"
    dir="/usr/local/java/$jdk8_Version"

    if test -d $dir
    then
        Echo_INFOR "java8 installed"
    else
        echo -e "\033[1;33m\n>> Installing Java environment(oraclejdk8)\n\033[0m"

        cd $T_Dir && rm -f $orclejdk8_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy2}https://github.com/No-Github/Archive/releases/download/$orclejdk_tmp_ver/$orclejdk8_bin ${wget_option} || Echo_ERROR "download failed, please check if the network is reachable, proxychains4 configuration is correct"

        tar -xzvf $orclejdk8_bin > /dev/null 2>&1
        rm -rf /usr/local/java/ > /dev/null 2>&1 && mkdir -p /usr/local/java/
        mv --force $jdk8_Version/ /usr/local/java

        ln -s /usr/local/java/$jdk8_Version/bin/java /usr/bin/java > /dev/null 2>&1
        ln -s /usr/local/java/$jdk8_Version/bin/keytool /usr/bin/keytool > /dev/null 2>&1

        #case $Linux_Version in
            #*"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                #echo "JAVA_HOME=/usr/local/java/$jdk8_Version" >> /etc/bashrc
                #echo "JRE_HOME=\$JAVA_HOME/jre" >> /etc/bashrc
                #echo "CLASSPATH=.:\$JAVA_HOME/lib:\$JRE_HOME/lib" >> /etc/bashrc
                #echo "PATH=\$PATH:\$JAVA_HOME/bin" >> /etc/bashrc
                #/usr/bin/java -version && Echo_INFOR "Successfully installed java environment, environment variables may need to be re-entered in bash to take effect" || Echo_ERROR "java installation failed (Maybe a false positive, execute the following command and re-enter bash\nexport JAVA_HOME=/usr/local/java/$jdk8_Version\nexport JRE_HOME=\$JAVA_HOME/jre\nexport CLASSPATH=.:\$JAVA_HOME/lib:\$JRE_HOME/lib\nexport PATH=\$JAVA_HOME/bin:\$PATH)"
                #;;
            #*"Kali"*|*"Ubuntu"*|*"Debian"*)
                #echo "JAVA_HOME=/usr/local/java/$jdk8_Version" >> /etc/bash.bashrc
                #echo "JRE_HOME=\$JAVA_HOME/jre" >> /etc/bash.bashrc
                #echo "CLASSPATH=.:\$JAVA_HOME/lib:\$JRE_HOME/lib" >> /etc/bash.bashrc
                #echo "PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/bash.bashrc
                #/usr/bin/java -version && Echo_INFOR "Successfully installed java environment, environment variables may need to be re-entered in bash to take effect\nexport JAVA_HOME=/usr/local/java/$jdk8_Version\nexport JRE_HOME=\$JAVA_HOME/jre\nexport CLASSPATH=.:\$JAVA_HOME/lib:\$JRE_HOME/lib\nexport PATH=\$JAVA_HOME/bin:\$PATH" || Echo_ERROR3
                #;;
            #*) ;;
        #esac

        rm -f $orclejdk8_bin > /dev/null 2>&1
    fi

    jenv_config "/usr/local/java/$jdk8_Version"
    jenv global 1.8 && jenv local 1.8 && echo -e "" && Echo_INFOR "Successfully installed java, Please run the following command:\njenv global 1.8 && jenv local 1.8"

}

# -oraclejdk11
Oraclejdk11_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            orclejdk11_bin=$orclejdk11_bin_amd64
            ;;
        *"linux-arm64"*)
            orclejdk11_bin=$orclejdk11_bin_arm64
            ;;
    esac

    name="oraclejdk11"
    dir="/usr/local/java/$jdk11_Version"

    if test -d $dir
    then
        Echo_INFOR "java11 installed"
    else
        echo -e "\033[1;33m\n>> Installing Java environment(oraclejdk11)\n\033[0m"

        cd $T_Dir && rm -f $orclejdk11_bin > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy2}https://github.com/No-Github/Archive/releases/download/$orclejdk_tmp_ver/$orclejdk11_bin ${wget_option} || Echo_ERROR "download failed, please check if the network is reachable, proxychains4 configuration is correct"

        tar -xzvf $orclejdk11_bin > /dev/null 2>&1
        # rm -rf /usr/local/java/ > /dev/null 2>&1
        mkdir -p /usr/local/java/
        mv --force $jdk11_Version/ /usr/local/java

        ln -s /usr/local/java/$jdk11_Version/bin/java /usr/bin/java > /dev/null 2>&1
        ln -s /usr/local/java/$jdk11_Version/bin/keytool /usr/bin/keytool > /dev/null 2>&1

        #case $Linux_Version in
            #*"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                #echo "JAVA_HOME=/usr/local/java/$jdk11_Version" >> /etc/bashrc
                #echo "JRE_HOME=\$JAVA_HOME/jre" >> /etc/bashrc
                #echo "CLASSPATH=.:\$JAVA_HOME/lib:\$JRE_HOME/lib" >> /etc/bashrc
                #echo "PATH=\$PATH:\$JAVA_HOME/bin" >> /etc/bashrc
                #/usr/bin/java -version && Echo_INFOR "Successfully installed java environment, environment variables may need to be re-entered in bash to take effect" || Echo_ERROR "java installation failed (Maybe a false positive, execute the following command and re-enter bash\nexport JAVA_HOME=/usr/local/java/$jdk11_Version\nexport JRE_HOME=\$JAVA_HOME/jre\nexport CLASSPATH=.:\$JAVA_HOME/lib:\$JRE_HOME/lib\nexport PATH=\$JAVA_HOME/bin:\$PATH)"
                #;;
            #*"Kali"*|*"Ubuntu"*|*"Debian"*)
                #echo "JAVA_HOME=/usr/local/java/$jdk11_Version" >> /etc/bash.bashrc
                #echo "JRE_HOME=\$JAVA_HOME/jre" >> /etc/bash.bashrc
                #echo "CLASSPATH=.:\$JAVA_HOME/lib:\$JRE_HOME/lib" >> /etc/bash.bashrc
                #echo "PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/bash.bashrc
                #/usr/bin/java -version && Echo_INFOR "Successfully installed java environment, environment variables may need to be re-entered in bash to take effect\nexport JAVA_HOME=/usr/local/java/$jdk11_Version\nexport JRE_HOME=\$JAVA_HOME/jre\nexport CLASSPATH=.:\$JAVA_HOME/lib:\$JRE_HOME/lib\nexport PATH=\$JAVA_HOME/bin:\$PATH" || Echo_ERROR3
                #;;
            #*) ;;
        #esac

        rm -f $orclejdk11_bin > /dev/null 2>&1
    fi

    jenv_config "/usr/local/java/$jdk11_Version"
    jenv global 11 && jenv local 11 && echo -e "" && Echo_INFOR "Successfully installed java, Please run the following command:\njenv global 11 && jenv local 11"

}

jenv_Install(){

    name="jenv"
    dir="$T_Dir/.jenv"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    which jenv > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_INFOR "$name installed"
    else
        if test -d $dir
        then
            Echo_ALERT "$name is already installed in $dir"
        else
            $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/jenv/jenv.git $dir > /dev/null 2>&1 && Echo_INFOR "Successfully installed jenv, environment variables may need to be re-entered in bash to take effect\nexport PATH=\"$T_Dir/.jenv/bin:\$PATH\"\neval \"\$(jenv init -)\"" || { Echo_ERROR2; return 1; }

            case $Linux_Version in
                *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                    echo "export PATH=\"$T_Dir/.jenv/bin:\$PATH\"" >> /etc/bashrc
                    echo 'eval "$(jenv init -)"' >> /etc/bashrc
                    ;;
                *"Kali"*|*"Ubuntu"*|*"Debian"*)
                    echo "export PATH=\"$T_Dir/.jenv/bin:\$PATH\"" >> /etc/bash.bashrc
                    echo 'eval "$(jenv init -)"' >> /etc/bash.bashrc
                    ;;
                *) ;;
            esac
        fi
    fi

}

jenv_config(){

    name="jenv"
    dir="$T_Dir/.jenv"

    which jenv > /dev/null 2>&1

    if [ $? == 0 ]
    then
        jenv add $1
        jenv doctor
    else
        if test -d $dir
        then
            export PATH="$T_Dir/.jenv/bin:$PATH"
            eval "$(jenv init -)"
            jenv add $1
            jenv doctor
        else
            Echo_ERROR "不存在 jenv 环境"
        fi
    fi

}

# -lua
lua_Install(){

    name="lua"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    which lua > /dev/null 2>&1
    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/lua && cd /tmp/lua && rm -rf ${lua_bin} && $Proxy_OK curl -R -O http://www.lua.org/ftp/$lua_bin > /dev/null 2>&1 && Echo_INFOR "Downloaded $lua_bin" || Echo_ERROR "$lua_bin download failed"
        tar -zxvf ${lua_bin} > /dev/null 2>&1 && cd ${lua_dir}
        make linux test && make install && Echo_INFOR "Successfully installed $name" || Echo_ERROR3
        rm -rf /tmp/lua
    fi

    name="luajit"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    which luajit > /dev/null 2>&1
    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/luajit && cd /tmp/luajit && rm -rf luajit && $Proxy_OK git clone --depth 1 ${GitProxy}https://luajit.org/git/luajit.git
        cd luajit && make && make install
        Echo_INFOR "Please link by output information"
        rm -rf /tmp/luajit
    fi

    echo -e "\033[1;33m\n>> Installing common libraries\n\033[0m"
    Rm_Lock
    Install_Switch "luarocks"
    cd /tmp && luarocks install luafilesystem

}

# -perl
Perl_Install(){

    name="perl"

    echo -e "\033[1;33m\n>> Installing $name(Pay attention to the installation options, if the installation does not respond for a long time, please press enter a few times, and after the installation is complete, you need to exit manually.)\n\033[0m" && cd $T_Dir && $Proxy_OK sh <(curl -q https://platform.activestate.com/dl/cli/install.sh) --activate-default ActiveState/ActivePerl-5.28

}

# -nn
nn_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            node_bin=$node_bin_amd64
            node_Dir=$node_Dir_amd64
            ;;
        *"linux-arm64"*)
            node_bin=$node_bin_arm64
            node_Dir=$node_Dir_arm64
            ;;
    esac

    name="nodejs && npm"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    if test -e /usr/local/bin/node
    then
        Echo_ALERT "nodejs && npm installed"
    else
        cd /tmp && $Proxy_OK wget https://nodejs.org/dist/$node_Ver/$node_bin > /dev/null 2>&1 && Echo_INFOR "Downloaded $node_bin " || Echo_ERROR "$node_bin download failed, please check if the network is reachable, proxychains4 configuration is correct"
        mkdir /usr/local/nodejs/ && tar -C /usr/local/nodejs -xvJf $node_bin > /dev/null 2>&1 && rm $node_bin
        ln -s /usr/local/nodejs/$node_Dir/bin/node /usr/local/bin/node && Echo_INFOR "Successfully installed nodejs" || Echo_ERROR "nodejs installation failed"
        ln -s /usr/local/nodejs/$node_Dir/bin/npm /usr/local/bin/npm && Echo_INFOR "Successfully installed npm" || Echo_ERROR "npm installation failed"

        case $Linux_Version in
            *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                echo "PATH=\$PATH:/usr/local/nodejs/$node_Dir/bin/" >> /etc/bashrc
                ;;
            *"Kali"*|*"Ubuntu"*|*"Debian"*)
                echo "PATH=\$PATH:/usr/local/nodejs/$node_Dir/bin/" >> /etc/bash.bashrc
                ;;
            *) ;;
        esac
    fi

}

# -metarget
metarget_Install(){

    Pentest_Base_Install
    Docker_Check
    name="metarget"
    dir="$P_Dir/metarget"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

        cd $P_Dir && rm -rf metarget > /dev/null 2>&1 && Echo_ALERT "Downloading $name" && $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/brant-ruan/metarget || Echo_ERROR2
        cd metarget && pip3 install -r requirements.txt > /dev/null 2>&1 && Echo_INFOR "Downloaded $name in the $dir" || Echo_ERROR3
    fi

}

# -vulhub
vulhub_Install(){

    Pentest_Base_Install
    Docker_Check
    name="vulhub"
    dir="$P_Dir/vulhub"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

        cd $P_Dir && rm -rf vulhub > /dev/null 2>&1 && Echo_ALERT "Downloading $name" && $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/vulhub/vulhub || Echo_ERROR2
        cd vulhub && Echo_INFOR "Downloaded $name in the $dir" || Echo_ERROR3
    fi

}

# -vulfocus
vulfocus_Install(){

    Docker_Check
    name="vulfocus"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    docker pull vulfocus/vulfocus:latest && Echo_INFOR "Pulled the latest vulfocus image, For more information, please refer to https://fofapro.github.io/vulfocus/#/INSTALL" || Echo_ERROR3

}

# -TerraformGoat
TerraformGoat_Install(){

    Pentest_Base_Install
    Docker_Check
    name="TerraformGoat"
    dir="$P_Dir/TerraformGoat"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
        Echo_INFOR "Please run through the following command:\ndocker run -itd --name terraformgoat terraformgoat:v0.0.3\ndocker exec -it terraformgoat /bin/bash\n"
    else
        echo -e "\033[1;33m\n>> Installing $name\n\033[0m"
        cd $P_Dir && rm -rf TerraformGoat > /dev/null 2>&1 && Echo_ALERT "Downloading $name" && $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/HXSecurity/TerraformGoat.git > /dev/null 2>&1 || Echo_ERROR2
        cd TerraformGoat && Echo_INFOR "Downloaded $name in the $P_Dir/TerraformGoat" || Echo_ERROR3
        docker build . -t terraformgoat:v0.0.3 && Echo_INFOR "Please run through the following command:\ndocker run -itd --name terraformgoat terraformgoat:v0.0.3\ndocker exec -it terraformgoat /bin/bash\n" || Echo_ERROR3
    fi

}

# -goby
Goby_Install(){

    name="goby"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    if test -d $P_Dir/goby
    then
        Echo_INFOR "Goby is already installed in $P_Dir/goby, Please run through the following command:\ncd $P_Dir/goby/goby* && ./goby (Graphical interface required)"
    else

        Rm_Lock
        case $Linux_Version in
            *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                Install_Switch "libXScrnSaver*"
                ;;
            *"Kali"*|*"Ubuntu"*|*"Debian"*)
                Install_Switch "libgconf2"
                ;;
            *) ;;
        esac

        Echo_ALERT "Downloading Goby(~120M)"
        cd $P_Dir && mkdir -p $P_Dir/goby > /dev/null 2>&1 && $Proxy_OK wget https://cn.gobies.org/$goby_File > /dev/null 2>&1 || Echo_ERROR "$goby_File download failed"
        unzip $goby_File -d $P_Dir/goby > /dev/null 2>&1 && rm -f $goby_File && Echo_INFOR "Goby $goby_Ver in the $P_Dir/goby, Please run through the following command:\ncd $P_Dir/goby/goby* && ./goby (Graphical interface required)" || Echo_ERROR3
    fi

    if test -d $P_Dir/goby
    then

        echo -e "\033[5;33m\nSet up server-side account(Special characters should be preceded by a backslash \"\\\" Escape)\033[0m" && read -r input
        Goby_User=$input
        echo -e "\033[5;33m\nSet server-side password(Special characters should be preceded by a backslash \"\\\" Escape)\033[0m" && read -r input
        Goby_Pass=$input
        Echo_INFOR "请运行以下命令:\n\033[0m\033[1;32mcd $P_Dir/goby/goby*/golib && nohup ./goby-cmd-linux -apiauth $Goby_User:$Goby_Pass -mode api -bind 0.0.0.0:8361 & "

    else
        Echo_ERROR "Goby is not installed, or is not in the specified path"
    fi

}

# -awvs14
awvs14_Install(){

    Docker_Check
    name="awvs14"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    docker pull secfa/docker-awvs && Echo_INFOR "Pulled the latest awvs14 image, Please run through the following command:\ndocker run -it -d -p 13443:3443 secfa/docker-awvs\n\n-awvs14 username: admin@admin.com\n-awvs14 password: Admin123\n-AWVS Version：14.2.210503151\n-browser access：https://127.0.0.1:13443/\n" || Echo_ERROR3

    Echo_INFOR "Recommended Projects : https://github.com/test502git/awvs13_batch_py3"

}

# -awvs15
# https://www.fahai.org/index.php/archives/31/
awvs15_Install(){

    Docker_Check
    name="awvs15"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    bash <(curl -sLk https://www.fahai.org/aDisk/Awvs/check.sh) xrsec/awvs:v15
    # docker pull xrsec/awvs:v15 && Echo_INFOR "Pulled the latest awvs15 image, Please run through the following command:\ndocker run -it -d -p 13443:3443 xrsec/awvs:v15\n\n-awvs14 username: awvs@awvs.lan\n-awvs14 password: Awvs@awvs.lan\n-browser access：https://127.0.0.1:13443/\n" || Echo_ERROR3

}


# -mobsf
mobsf_Install(){

    Docker_Check
    name="MobSF"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    docker pull opensecurity/mobile-security-framework-mobsf && Echo_INFOR "Pulled the latest MobSF image, Please run through the following command:\n$Proxy_OK docker run -it --rm -p 8000:8000 opensecurity/mobile-security-framework-mobsf:latest\n\n-browser access：http://127.0.0.1:8000/" || Echo_ERROR3

}

# -nodejsscan
nodejsscan_Install(){

    Docker_Check
    name="nodejsscan"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    docker pull opensecurity/nodejsscan:latest && Echo_INFOR "Pulled the latest nodejsscan image, Please run through the following command:\ndocker run -it -p 9090:9090 opensecurity/nodejsscan:latest\n\n-browser access：http://127.0.0.1:9090/" || Echo_ERROR3

}

# -pupy
pupy_Install(){

    Docker_Check
    name="pupy"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    docker pull alxchk/pupy:unstable && echo -e "" && Echo_INFOR "Pulled the latest pupy image" || Echo_ERROR3

    echo -e "\033[5;33m\n输入 pupy 容器 ssh 端口 (默认 2022)\033[0m" && read -r input
    pupy_ssh_port=$input

    if [ $pupy_ssh_port ==  ] 2>> /tmp/f8x_error.log
    then
        echo -e "输入为空,默认监听端口为 2022"
        pupy_ssh_port="2022"
    fi

    echo -e "\033[5;33m\n输入 pupy 容器 http 端口 (默认 80)\033[0m" && read -r input
    pupy_http_port=$input

    if [ $pupy_http_port ==  ] 2>> /tmp/f8x_error.log
    then
        echo -e "输入为空,默认监听端口为 80"
        pupy_http_port="80"
    fi

    echo -e "\033[5;33m\n输入 pupy 容器 https 端口 (默认 443)\033[0m" && read -r input
    pupy_https_port=$input

    if [ $pupy_https_port ==  ] 2>> /tmp/f8x_error.log
    then
        echo -e "输入为空,默认监听端口为 443"
        pupy_https_port="443"
    fi

    echo -e "\033[5;33m\npupy 容器是否监听 53 端口 [y/N,Default N] (注意: 如果监听 53 会关闭系统自带 systemd-resolved,请知晓这个选项的用意)\033[0m" && read -r input
    case $input in
        [yY][eE][sS]|[Yy])
            systemctl stop systemd-resolved
            pupy_dns="-p 53:53 "
        ;;
        *)
            echo -e "pass~"
        ;;
    esac

    echo -e "" && Echo_INFOR "docker run -d --name pupy-server -p $pupy_ssh_port:22 $pupy_dns-p $pupy_http_port:80 -p $pupy_https_port:443 -v /tmp/projects:/projects alxchk/pupy:unstable"
    docker run -d --name pupy-server -p $pupy_ssh_port:22 $pupy_dns-p $pupy_http_port:80 -p $pupy_https_port:443 -v /tmp/projects:/projects alxchk/pupy:unstable

    # ssh-keygen 免交互
    yes | ssh-keygen -t rsa -N "" -C "test@email.com" -f ~/.ssh/id_rsa_pupy
    cp ~/.ssh/id_rsa_pupy.pub /tmp/projects/keys/authorized_keys

    # ssh首次交互免输入yes
    # ssh -i ~/.ssh/id_rsa_pupy -p 2022 -o stricthostkeychecking=no pupy@127.0.0.1
    Echo_INFOR "pupy 交互命令:\nssh -i ~/.ssh/id_rsa_pupy -p 2022 -o stricthostkeychecking=no pupy@127.0.0.1"

}

# -sps
SharPyShell_Install(){

    name="SharPyShell"
    dir="$P_Dir/SharPyShell"

    if test -e $dir/SharPyShell.py
    then
        Echo_ALERT "$name installed"
    else
        rm -rf $P_Dir/SharPyShell
        cd $P_Dir && $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/antonioCoco/SharPyShell.git > /dev/null 2>&1
        cd $dir

        python2 -m pip install --upgrade --force pip > /dev/null 2>&1
        python2 -m pip install install setuptools==33.1.1 > /dev/null 2>&1
        python2 -m pip install pefile==2019.4.18 > /dev/null 2>&1

        case $Linux_Version in
            *"Kali"*|*"Ubuntu"*|*"Debian"*)
                case $Linux_architecture_Name in
                    *"linux-arm64"*)
                        Rm_Lock
                        Install_Switch "libffi-dev"
                        Install_Switch "libssl-dev"
                        Install_Switch "libssh-dev"

                        Install_Switch3 "cffi==1.12.3"
                        Install_Switch3 "pyOpenSSL==19.0.0"
                        python2 -m pip install -r requirements.txt > /dev/null 2>&1
                        ;;
                esac
                ;;
        esac

        python2 -m pip install -r requirements.txt > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the $dir"
    fi

}

# -viper
viper_Install(){

    Docker_Check
    name="viper"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    mkdir -p /root/VIPER && cd /root/VIPER && rm -f docker-compose.* > /dev/null 2>&1

    viper_conf > /dev/null 2>&1

    echo -e "\033[5;33m\nPlease enter your Viper password(Password needs to be greater than 8 digits)\033[0m" && read -r input
    Viper_Pass=$input
    cat docker-compose.yml.bak | sed "s/diypassword/$Viper_Pass/" >> docker-compose.yml
    cd /root/VIPER && docker-compose up -d

    Echo_INFOR "Waiting for the system to start(15s), access https://vpsip:60000 Login to the server. Username : root Password : $Viper_Pass"

}

viper_conf(){

tee docker-compose.yml.bak <<-'EOF'
version: "3"
services:
  viper:
    image: registry.cn-shenzhen.aliyuncs.com/toys/viper:latest
    container_name: viper-c
    network_mode: "host"
    restart: always
    volumes:
      - ${PWD}/loot:/root/.msf4/loot
      - ${PWD}/db:/root/viper/Docker/db
      - ${PWD}/module:/root/viper/Docker/module
      - ${PWD}/log:/root/viper/Docker/log
      - ${PWD}/nginxconfig:/root/viper/Docker/nginxconfig
    command: ["diypassword"]
EOF

}

# -arl
arl_Install(){

    Docker_Check
    name="ARL"

    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"
    cd $P_Dir && rm -rf ARL > /dev/null 2>&1 && $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/TophantTechnology/ARL > /dev/null 2>&1 || Echo_ERROR4 "TophantTechnology/ARL"
    # docker pull tophant/arl && Echo_INFOR "Pulled the latest ARL image" || Echo_ERROR3
    Echo_INFOR "Please run through the following command:\ncd $P_Dir/ARL/docker/ && docker volume create arl_db && docker-compose up -d\nDefault port: 5003\nDefault username: admin\n/Default password: arlpass"

}

# -music
music_Install(){

    nn_Check
    name="UnblockNeteaseMusic"

    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    Echo_ALERT "Installing npx module" && $Proxy_OK npm install npx -g > /dev/null 2>&1 && Echo_INFOR "npx module installed successfully" || Echo_ERROR "npx module installation failed"
    cd $T_Dir && rm -rf UnblockNeteaseMusic > /dev/null 2>&1 && $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/nondanee/UnblockNeteaseMusic > /dev/null 2>&1 || Echo_ERROR4 "nondanee/UnblockNeteaseMusic"
    cd UnblockNeteaseMusic && $Proxy_OK npm install && Echo_INFOR "After installation, run the following command to start the service:\n\033[0m\033[1;32mcd $T_Dir/UnblockNeteaseMusic && npx @nondanee/unblockneteasemusic\n" || Echo_ERROR3

}

# -nginx
nginx_Install(){

    name="nginx"

    echo -e "\033[1;33m\n>> Installing $name $nginx_Ver\n\033[0m"

    nginx -h > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else

        Rm_Lock
        case $Linux_Version in
            *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                Install_Switch "pcre-devel"
                ;;
            *"Kali"*|*"Ubuntu"*|*"Debian"*)
                Install_Switch "libpcre3-dev"
                Install_Switch "zlib1g"
                Install_Switch "zlib1g.dev"
                ;;
            *) ;;
        esac

        cd /tmp && rm -f $nginx_bin > /dev/null 2>&1 && $Proxy_OK wget -O $nginx_bin https://nginx.org/download/$nginx_bin > /dev/null 2>&1 || Echo_ERROR "$nginx_bin download failed"
        tar -zxvf $nginx_bin > /dev/null 2>&1 && rm -f $nginx_bin > /dev/null 2>&1 && cd nginx-*
        ./configure && make && make install && Echo_INFOR "Compile successfully" || Echo_ERROR "Compile failure"
        mv --force /usr/local/nginx/sbin/nginx /usr/local/bin/nginx && chmod +x /usr/local/bin/nginx && nginx -h > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name, the configuration file is located in /usr/local/nginx/conf/" || Echo_ERROR3
    fi

}

# -aircrack
aircrack_Install(){

    name="aircrack-ng"
    dir="$P_Dir/aircrack-ng"

    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    if test -d $dir
    then
        Echo_ALERT "$name is already installed in $dir"
    else
        cd $P_Dir && rm -rf aircrack-ng > /dev/null 2>&1 && $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/aircrack-ng/aircrack-ng.git > /dev/null 2>&1 && cd $dir || Echo_ERROR4 "aircrack-ng/aircrack-ng"

        Rm_Lock
        case $Linux_Version in
            *"CentOS"*|*"RedHat"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                Update_EPEL_Mirror
                case $Linux_Version_Num in
                    8)
                        yum config-manager --set-enabled powertools
                        Install_Switch "libtool"
                        Install_Switch "pkgconfig sqlite-devel"
                        Install_Switch "autoconf"
                        Install_Switch "automake"
                        Install_Switch "openssl-devel"
                        Install_Switch "libpcap-devel"
                        Install_Switch "pcre-devel"
                        Install_Switch "rfkill"
                        Install_Switch "libnl3-devel"
                        Install_Switch "gcc"
                        Install_Switch "gcc-c++"
                        Install_Switch "ethtool"
                        Install_Switch "hwloc-devel"
                        Install_Switch "libcmocka-devl"
                        Install_Switch "make"
                        Install_Switch "file"
                        Install_Switch "expect"
                        Install_Switch "hostapd"
                        Install_Switch "wpa_supplicant"
                        Install_Switch "iw"
                        Install_Switch "usbutils"
                        Install_Switch "tcpdump"
                        Install_Switch "screen"
                        Install_Switch "zlib-devel"
                        ;;
                    7)
                        ./centos_autotools.sh
                        yum remove -y autoconf automake
                        Install_Switch "sqlite-devel"
                        Install_Switch "openssl-devel"
                        Install_Switch "libpcap-devel"
                        Install_Switch "pcre-devel"
                        Install_Switch "rfkill"
                        Install_Switch "libnl3-devel"
                        Install_Switch "ethtool"
                        Install_Switch "hwloc-devel"
                        Install_Switch "libcmocka-devel"
                        Install_Switch "make"
                        Install_Switch "file"
                        Install_Switch "expect"
                        Install_Switch "hostapd"
                        Install_Switch "wpa_supplicant"
                        Install_Switch "iw"
                        Install_Switch "usbutils"
                        Install_Switch "tcpdump"
                        Install_Switch "screen"
                        Install_Switch "zlib-devel"
                        ;;
                    *)
                        Echo_ERROR "版本不支持,pass"
                        ;;
                esac
                ;;
            *"Fedora"*)
                Install_Switch "libtool"
                Install_Switch "pkgconfig"
                Install_Switch "sqlite-devel"
                Install_Switch "autoconf"
                Install_Switch "automake"
                Install_Switch "openssl-devel"
                Install_Switch "libpcap-devel"
                Install_Switch "pcre-devel"
                Install_Switch "rfkill"
                Install_Switch "libnl3-devel"
                Install_Switch "gcc"
                Install_Switch "gcc-c++"
                Install_Switch "ethtool"
                Install_Switch "hwloc-devel"
                Install_Switch "libcmocka-devel"
                Install_Switch "make"
                Install_Switch "file"
                Install_Switch "expect"
                Install_Switch "hostapd"
                Install_Switch "wpa_supplicant"
                Install_Switch "iw"
                Install_Switch "usbutils"
                Install_Switch "tcpdump"
                Install_Switch "screen"
                Install_Switch "zlib-devel"
                ;;
            *"Kali"*|*"Ubuntu"*|*"Debian"*)
                Install_Switch "build-essential"
                Install_Switch "autoconf"
                Install_Switch "automake"
                Install_Switch "libtool"
                Install_Switch "pkg-config"
                Install_Switch "libnl-3-dev"
                Install_Switch "libnl-genl-3-dev"
                Install_Switch "libssl-dev"
                Install_Switch "ethtool"
                Install_Switch "shtool"
                Install_Switch "rfkill"
                Install_Switch "zlib1g-dev"
                Install_Switch "libpcap-dev"
                Install_Switch "libsqlite3-dev"
                Install_Switch "libpcre3-dev"
                Install_Switch "libhwloc-dev"
                Install_Switch "libcmocka-dev"
                Install_Switch "hostapd"
                Install_Switch "wpasupplicant"
                Install_Switch "tcpdump"
                Install_Switch "screen"
                Install_Switch "iw"
                Install_Switch "usbutils"
                ;;
            *) ;;
        esac

        ./autogen.sh && ./configure && make && make install && ldconfig && Echo_INFOR "Successfully installed $name" || Echo_ERROR3

    fi

}

# -bypass
bypass_Install(){

    GO_Check
    Pentest_Base_Install

    echo -e "\033[1;33m\n>> Installing garble\n\033[0m"
    go env -w GO111MODULE=on
    go get mvdan.cc/garble > /dev/null 2>&1 && Echo_INFOR "Successfully installed garble in the $P_Dir/garble " || Echo_ERROR "garble installation failed"

    echo -e "\033[1;33m\n>> Installing intensio-obfuscator\n\033[0m"
    Install_Switch5 "intensio-obfuscator"

}

# -cs
cs_Install(){

    Pentest_Base_Install

    echo -e "\033[1;33m\n>> Installing $CS_Version\n\033[0m"
    Pentest_CobaltStrike_Install
    echo -e "\033[5;33m\nPlease enter your teamserver server IP\033[0m" && read -r input
    CS_IP=$input
    echo -e "\033[5;33m\nPlease enter your teamserver server password(Special characters should be preceded by a backslash \"\\\" to escape them)\033[0m" && read -r input
    CS_Pass=$input
    Echo_INFOR "Please create a new bash session and run the following command:(Default Port 41337)\n\033[0m\033[1;32mcd $P_Dir/$CS_Version/ && nohup ./teamserver $CS_IP $CS_Pass & "

}

# -cs45
cs45_Install(){

    Pentest_Base_Install

    echo -e "\033[1;33m\n>> Installing $CS45_Version\n\033[0m"
    Pentest_CobaltStrike45_Install
    echo -e "\033[5;33m\nPlease enter your teamserver server IP\033[0m" && read -r input
    CS_IP=$input
    echo -e "\033[5;33m\nPlease enter your teamserver server password(Special characters should be preceded by a backslash \"\\\" to escape them)\033[0m" && read -r input
    CS_Pass=$input
    Echo_INFOR "Please create a new bash session and run the following command:(Default Port 50050)\n\033[0m\033[1;32mcd $P_Dir/$CS45_Version/ && nohup ./teamserver $CS_IP $CS_Pass & "

}

# -interactsh
interactsh_Install(){

    name="interactsh-server"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            interactsh_server_bin=$interactsh_server_bin_amd64
            ;;
        *"linux-arm64"*)
            interactsh_server_bin=$interactsh_server_bin_arm64
            ;;
    esac

    which interactsh-server > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/interactsh && cd /tmp/interactsh && $Proxy_OK wget ${GitProxy}https://github.com/projectdiscovery/interactsh/releases/download/${interactsh_Ver}/${interactsh_server_bin} ${wget_option} || Echo_ERROR2
        unzip ${interactsh_server_bin} > /dev/null 2>&1
        mv /tmp/interactsh/interactsh-server /usr/local/bin/interactsh-server && chmod +x /usr/local/bin/interactsh-server
        which interactsh-server > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name ${interactsh_Ver} in the /usr/local/bin/interactsh-server" || Echo_ERROR3
        rm -rf /tmp/interactsh
    fi

    interactsh_client_Install

}

interactsh_client_Install(){

    name="interactsh-client"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            interactsh_client_bin=$interactsh_client_bin_amd64
            ;;
        *"linux-arm64"*)
            interactsh_client_bin=$interactsh_client_bin_arm64
            ;;
    esac

    which interactsh-client > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/interactsh && cd /tmp/interactsh && $Proxy_OK wget ${GitProxy}https://github.com/projectdiscovery/interactsh/releases/download/${interactsh_Ver}/${interactsh_client_bin} ${wget_option} || Echo_ERROR2
        unzip ${interactsh_client_bin} > /dev/null 2>&1
        mv /tmp/interactsh/interactsh-client /usr/local/bin/interactsh-client && chmod +x /usr/local/bin/interactsh-client
        which interactsh-client > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name ${interactsh_Ver} in the /usr/local/bin/interactsh-client" || Echo_ERROR3
        rm -rf /tmp/interactsh
    fi

}

# -merlin
merlin_Install(){

    name="merlin"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    which merlinServer > /dev/null 2>&1
    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
        Echo_INFOR "Merlin Server Command   : merlinServer"
    else
        mkdir -p /tmp/merlin && cd /tmp/merlin && rm -f ${merlin_Install_amd64} > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/Ne0nd0g/merlin/releases/download/$merlin_Ver/$merlin_Install_amd64 > /dev/null 2>&1 || Echo_ERROR2
        7za x -pmerlin ${merlin_Install_amd64} > /dev/null 2>&1
        mv --force merlinServer-Linux-x64 /usr/local/bin/merlinServer && chmod +x /usr/local/bin/merlinServer && rm -rf /tmp/merlin > /dev/null 2>&1
        which merlinServer > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $merlin_Ver in the /usr/local/bin/" && Echo_INFOR "Merlin Server Command   : merlinServer" || Echo_ERROR3
    fi

    dir="$P_Dir/merlinAgent"

    if test -d $dir
    then
        Echo_INFOR "Merlin Agent Folder     : $dir"
    else
        mkdir $dir
        mkdir -p /tmp/merlin && cd /tmp/merlin && rm -f ${merlin_agent_windows} > /dev/null 2>&1 && rm -f ${merlin_agent_linux} > /dev/null 2>&1 && rm -f ${merlin_agent_darwin} > /dev/null 2>&1
        $Proxy_OK wget ${GitProxy}https://github.com/Ne0nd0g/merlin/releases/download/$merlin_Ver/$merlin_agent_windows > /dev/null 2>&1 || Echo_ERROR2
        $Proxy_OK wget ${GitProxy}https://github.com/Ne0nd0g/merlin/releases/download/$merlin_Ver/$merlin_agent_linux > /dev/null 2>&1 || Echo_ERROR2
        $Proxy_OK wget ${GitProxy}https://github.com/Ne0nd0g/merlin/releases/download/$merlin_Ver/$merlin_agent_darwin > /dev/null 2>&1 || Echo_ERROR2
        7za x -pmerlin ${merlin_agent_windows} > /dev/null 2>&1
        7za x -pmerlin ${merlin_agent_linux} > /dev/null 2>&1
        7za x -pmerlin ${merlin_agent_darwin} > /dev/null 2>&1

        mv --force merlinAgent-Windows-x64.exe $dir/merlinAgent-Windows-x64.exe
        mv --force merlinAgent-Linux-x64 $dir/merlinAgent-Linux-x64
        mv --force merlinAgent-Darwin-x64 $dir/merlinAgent-Darwin-x64 && Echo_INFOR "Merlin Agent Folder     : $dir" || Echo_ERROR3

        rm -rf /tmp/merlin > /dev/null 2>&1
    fi

}

# -frp
frp_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            frp_File=$frp_File_amd64
            frp_Dir=$frp_Dir_amd64
            ;;
        *"linux-arm64"*)
            frp_File=$frp_File_arm64
            frp_Dir=$frp_Dir_arm64
            ;;
    esac

    name="frp"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    if test -d $T_Dir/frp
    then
        Echo_INFOR "$name is already installed in $T_Dir/frp"
    else
        mkdir -p $T_Dir/frp && cd $T_Dir/frp && rm -rf frp* > /dev/null 2>&1 && $Proxy_OK wget ${GitProxy}https://github.com/fatedier/frp/releases/download/$frp_Ver/$frp_File ${wget_option} || Echo_ERROR "$frp_File download failed"
        tar -zxvf $frp_File > /dev/null 2>&1
        cd $frp_Dir && Echo_INFOR "frp is already installed in $T_Dir/frp/$frp_Dir" || Echo_ERROR3
        rm -rf $T_Dir/frp/$frp_File > /dev/null 2>&1
    fi

}

# -nps
nps_Install(){

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            nps_File=$nps_File_amd64
            ;;
        *"linux-arm64"*)
            nps_File=$nps_File_arm64
            ;;
    esac

    name="nps"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    if test -d $T_Dir/nps
    then
        Echo_INFOR "$name is already installed in $T_Dir/nps"
    else
        mkdir -p $T_Dir/nps && cd $T_Dir/nps && $Proxy_OK wget ${GitProxy}https://github.com/ehang-io/nps/releases/download/$nps_Ver/$nps_File ${wget_option} || Echo_ERROR "$nps_File download failed"
        tar -zxvf $nps_File > /dev/null 2>&1
        chmod +x $T_Dir/nps/nps && $T_Dir/nps/nps install > /dev/null 2>&1
        $T_Dir/nps/nps -version > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name $nps_Ver in the $T_Dir/nps" || Echo_ERROR3
        rm -f $T_Dir/nps/$nps_File > /dev/null 2>&1
    fi

}

# -rg
RedGuard_Install(){

    name="RedGuard"
    which RedGuard > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/rg && cd /tmp/rg && $Proxy_OK wget ${GitProxy}https://github.com/wikiZ/RedGuard/releases/download/$RedGuard_Ver/$RedGuard_File_amd64 ${wget_option} || Echo_ERROR2
        mv --force $RedGuard_File_amd64 /usr/local/bin/RedGuard && chmod +x /usr/local/bin/RedGuard
        which RedGuard > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the /usr/local/bin/" || Echo_ERROR3
        rm -f /tmp/rg > /dev/null 2>&1
    fi

}

# -sliver-server
sliver-server_Install(){

    name="sliver-server"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    if test -e /root/sliver-server
    then
        Echo_ALERT "$name installed"
    else
        Rm_Lock
        case $Linux_Version in
            *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
                Install_Switch "gcc"
                Install_Switch "gcc-c++"
                Install_Switch "make"
                Install_Switch "mingw64-gcc"
                ;;
            *"Kali"*|*"Ubuntu"*|*"Debian"*)
                Install_Switch "build-essential"
                Install_Switch "mingw-w64"
                Install_Switch "binutils-mingw-w64"
                Install_Switch "g++-mingw-w64"
                ;;
            *) ;;
        esac

        mkdir -p /tmp/sliver-server && cd /tmp/sliver-server && $Proxy_OK wget ${GitProxy}https://github.com/BishopFox/sliver/releases/download/$sliver_Ver/$sliver_bin_Server ${wget_option} || Echo_ERROR2
        mv --force $sliver_bin_Server /root/sliver-server && chmod 755 /root/sliver-server
        /root/sliver-server unpack --force && Echo_INFOR "Successfully installed $name in the /root/sliver-server" || Echo_ERROR3
        rm -f /tmp/sliver-server > /dev/null 2>&1

        # systemd
        Echo_INFOR "Configuring systemd service ..."
cat > /etc/systemd/system/sliver.service <<-EOF
[Unit]
Description=Sliver
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=on-failure
RestartSec=3
User=root
ExecStart=/root/sliver-server daemon

[Install]
WantedBy=multi-user.target
EOF
        chown root:root /etc/systemd/system/sliver.service
        chmod 600 /etc/systemd/system/sliver.service

        Echo_INFOR "systemctl start sliver"
        systemctl start sliver

        # Generate local configs
        Echo_INFOR "Generating operator configs ..."
        mkdir -p /root/.sliver-client/configs
        /root/sliver-server operator --name root --lhost localhost --save /root/.sliver-client/configs
        chown -R root:root /root/.sliver-client/

        USER_DIRS=(/home/*)
        for USER_DIR in "${USER_DIRS[@]}"; do
            USER=$(basename $USER_DIR)
            if id -u $USER >/dev/null 2>&1; then
                mkdir -p $USER_DIR/.sliver-client/configs
                /root/sliver-server operator --name $USER --lhost localhost --save $USER_DIR/.sliver-client/configs
                chown -R $USER:$USER $USER_DIR/.sliver-client/
            fi
        done

    fi

    sliver-client_Install

}

sliver-client_Install(){

    name="sliver-client"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    which sliver > /dev/null 2>&1
    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/sliver-client && cd /tmp/sliver-client && $Proxy_OK wget ${GitProxy}https://github.com/BishopFox/sliver/releases/download/$sliver_Ver/$sliver_bin_Client ${wget_option} || Echo_ERROR2
        mv --force $sliver_bin_Client /usr/local/bin/sliver && chmod 755 /usr/local/bin/sliver
        which sliver > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the /usr/local/bin/sliver" || Echo_ERROR3
        rm -f /tmp/sliver-client > /dev/null 2>&1
    fi

}

# -yakit
yakit_Install(){

    name="yakit"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"
    which yak > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        cd /tmp && rm -f yak_linux_amd64 && $Proxy_OK wget ${GitProxy}https://yaklang.oss-cn-beijing.aliyuncs.com/yak/latest/yak_linux_amd64 ${wget_option} || Echo_ERROR2
        mv --force yak_linux_amd64 /usr/local/bin/yak && chmod +x /usr/local/bin/yak
        which yak > /dev/null 2>&1 && Echo_INFOR "Successfully installed $name in the /usr/local/bin/" || Echo_ERROR3
    fi

}

# -wpscan
wpscan_Install(){

    name="wpscan"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"
    which wpscan > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        gem update --system
        gem install wpscan
    fi

}

# -suricata
suricata_Install(){

    name="suricata"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    case $Linux_Version in
        *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
            Echo_ERROR "The script currently supports only Debian installations of suricata,bye bye~\n"
            exit 1
            ;;
        *"Kali"*|*"Ubuntu"*|*"Debian"*)
            Rm_Lock
            add-apt-repository ppa:oisf/suricata-stable
            Install_Switch "jq"
            Install_Switch "suricata"
            Install_Switch "suricata-update"
            suricata-update && Echo_INFOR "Updated suricata rules" || Echo_ERROR "Failure to update suricata rules"
            ;;
        *) ;;
    esac

}

# -ssr
ssr_Install(){

    name="ssr"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    if test -d $T_Dir/shadowsocksr
    then
        Echo_ALERT "$name is already installed in $T_Dir/shadowsocksr"
    else
        cd $T_Dir && rm -f ssr.zip > /dev/null 2>&1 && wget https://cdn.jsdelivr.net/gh/No-Github/Archive@1.0.3/ssr/ssr.zip > /dev/null 2>&1
        unzip -P 123456 ssr.zip > /dev/null 2>&1 && rm -f ssr.zip > /dev/null 2>&1
        cd shadowsocksr && bash initcfg.sh && Echo_INFOR "Successfully installed ssr" || Echo_ERROR "ssr installation failed"
        Echo_INFOR "Run the following command to modify the ssr configuration:\n\033[0m\033[1;32mvim $T_Dir/shadowsocksr/user-config.json\n"
        Echo_INFOR "Run the following command to enable the ssr service:\n\033[0m\033[1;32mcd $T_Dir/shadowsocksr/shadowsocks/ && python local.py"
    fi

}

# -zsh
zsh_Install(){

    name="zsh"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    Echo_INFOR "The current system shell presence is as follows:"
    cat /etc/shells
    echo -e ""

    Echo_INFOR "The current default shell is:"
    echo -e $SHELL
    echo -e ""

    zsh --version > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "zsh installed"
    else
        Rm_Lock
        Echo_INFOR "Installing zsh"
        Install_Switch "zsh"
    fi

    Echo_INFOR "Configuring Oh My Zsh"

    if [ $Proxy_OK == proxychains4 ] 2>> /tmp/f8x_error.log
    then
        $Proxy_OK wget https://raw.githubusercontent.com/No-Github/Archive/master/zsh/install.sh > /dev/null 2>&1
        $Proxy_OK bash install.sh
        $Proxy_OK exec zsh -l
    else
        wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh > /dev/null 2>&1
        Echo_INFOR "Please exit the subshell environment manually when you see ➜ ~ to continue the installation"
        sleep 1
        bash install.sh
    fi

    cat ~/.zshrc | sed "s/robbyrussell/agnoster/" >> ~/.zshrc

    $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    cat ~/.zshrc | sed "s/git/git zsh-syntax-highlighting/" >> ~/.zshrc

    $Proxy_OK git clone --depth 1 ${GitProxy}https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
    echo 'source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh' >>~/.zshrc

    echo -e "\033[1;33m\n>> Do you need to configure powerlevel10k theme [Y/n,Default Y] \033[0m" && read -r input
    case $input in
        [nN][oO]|[nN])
            Echo_INFOR "Pass~"
            ;;
        *)
            $Proxy_OK git clone --depth 1 ${GitProxy}--depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
            echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
            Echo_ALERT "If you don't need it, you can delete the last few lines of powerlevel10k in ~/.zshrc file"
            ;;
    esac

    Echo_INFOR "Over,Please reopen a shell to see the effect~"

}

# -optimize
optimize_setting(){

    echo -e "\033[1;33m\n>> In sync\n\033[0m"
    sync && Echo_INFOR "sync"
    echo -e "\033[1;33m\n>> Cache being released\n\033[0m"
    echo 1 > /proc/sys/vm/drop_caches && Echo_INFOR "Cleared pagecache"
    echo 2 > /proc/sys/vm/drop_caches && Echo_INFOR "Cleared dentries and inodes"
    echo 3 > /proc/sys/vm/drop_caches && Echo_INFOR "Cleared pagecache、dentries and inodes"
    sync
    echo -e "\033[1;33m\n>> The limit on the number of open files is being removed\n\033[0m"
    ulimit -n 65535 && Echo_INFOR "ulimit -n 65535"
    echo -e "\033[1;33m\n>> Memory settings are being optimized\n\033[0m"
    echo 128 > /proc/sys/vm/nr_hugepages > /dev/null 2>&1
    sysctl -w vm.nr_hugepages=128 > /dev/null 2>&1 && Echo_INFOR "vm.nr_hugepages=128"

}

# -info
System_info(){

    rm -f /tmp/f8x_info.log > /dev/null 2>&1

    date +"%Y-%m-%d" > /tmp/f8x_info.log

    echo -e "\033[1;33m\n>> System Info\n\033[0m"

    Echo_INFOR "Current User:"
    w

    echo -e "" && Echo_INFOR "Current system administrator:"
    awk -F: '($3 == "0") {print}' /etc/passwd

    echo -e "" && Echo_INFOR "Last logins:"
    last

    echo -e "\033[1;33m\n>> Hardware Info\n\033[0m"

    Echo_INFOR "Current Kernel Version:"
    uname -r

    echo -e "" && Echo_INFOR "Current CPU info:"
    case $Running_Mode in
        *"Darwin"*)
            sysctl -n machdep.cpu.brand_string
            ;;
        *"Linux"*)
            cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq
            ;;
    esac

    echo -e "" && Echo_INFOR "Current CPU Usage:"
    uptime

    awk '$0 ~/cpu[0-9]/' /proc/stat 2>/dev/null | while read line; do
	echo "$line" | awk '{total=$2+$3+$4+$5+$6+$7+$8;free=$5;\
        print$1" Free "free/total*100"%",\
        "Used " (total-free)/total*100"%"}'
    done

    echo -e "" && Echo_INFOR "Current CPU cores:"
    case $Running_Mode in
        *"Darwin"*)
            sysctl -n machdep.cpu.core_count
            ;;
        *"Linux"*)
            cat /proc/cpuinfo | grep 'processor' | sort | uniq | wc -l
            ;;
    esac

    echo -e "\033[1;33m\n>> Resource Usage\n\033[0m"

    Echo_INFOR "Current Memory Usage:"
    case $Running_Mode in
        *"Darwin"*)
            top -l 1 | head -n 10 | grep PhysMem
            ;;
        *"Linux"*)
            free -h
            ;;
    esac

    echo -e "" && Echo_INFOR "The 10 processes that use the most CPU resources:"
    case $Running_Mode in
        *"Darwin"*)
            ps aux | sort -nr -k 3 | head -10
            ;;
        *"Linux"*)
            ps auxf |sort -nr -k 3 |head -10
            ;;
    esac

    echo -e "" && Echo_INFOR "The 10 processes that use the most memory resources:"
    case $Running_Mode in
        *"Darwin"*)
            ps aux | sort -nr -k 4 | head -10
            ;;
        *"Linux"*)
            ps auxf |sort -nr -k 4 |head -10
            ;;
    esac

    echo -e "" && Echo_INFOR "Disk space utilization:"
    df -h

    df_a1=$(df -h|sed '1d'|awk '{print $5}'|sed 's/%//g'|sed -n 1p)
    df_a2=$(df -h|sed '1d'|awk '{print $5}'|sed 's/%//g'|sed -n 2p)
    df_a3=$(df -h|sed '1d'|awk '{print $5}'|sed 's/%//g'|sed -n 3p)
    df_a4=$(df -h|sed '1d'|awk '{print $5}'|sed 's/%//g'|sed -n 4p)

    df_b1=$(df -h|sed 1d|awk '{print $1}'|sed -n 1p)
    df_b2=$(df -h|sed 1d|awk '{print $1}'|sed -n 2p)
    df_b3=$(df -h|sed 1d|awk '{print $1}'|sed -n 3p)
    df_b4=$(df -h|sed 1d|awk '{print $1}'|sed -n 4p)

    if [ $df_a1 -gt 69 ];then Echo_ERROR "$DAY $df_b1 over 70% usage !!!!!"; fi
    if [ $df_a2 -gt 69 ];then Echo_ERROR "$DAY $df_b2 over 70% usage !!!!!"; fi
    if [ $df_a3 -gt 69 ];then Echo_ERROR "$DAY $df_b3 over 70% usage !!!!!"; fi
    if [ $df_a4 -gt 69 ];then Echo_ERROR "$DAY $df_b4 over 70% usage !!!!!"; fi

    echo -e "" && Echo_INFOR "Available Device Info:"
    case $Running_Mode in
        *"Darwin"*)
            diskutil list
            ;;
        *"Linux"*)
            lsblk
            ;;
    esac

    case $Running_Mode in
        *"Linux"*)
            echo -e "" && Echo_INFOR "Current swap partition usage: (empty means no swap partition is configured)"
            swapon -s 2>> /tmp/f8x_error.log
            echo -e "" && Echo_INFOR "Mount Status:"
            more /etc/fstab  | grep -v "^#" | grep -v "^$"
            ;;
    esac

    echo -e "\033[1;33m\n>> Network Status\n\033[0m"

    Echo_INFOR "Current IP address:"
    case $Running_Mode in
        *"Darwin"*)
            ifconfig | grep inet | grep -v "inet6" | grep -v "127.0.0.1" | awk '{ print $2; }' | tr '\n' '\t'
            ;;
        *"Linux"*)
            ip addr | grep inet | grep -v "inet6" | grep -v "127.0.0.1" | awk '{ print $2; }' | tr '\n' '\t'
            ;;
    esac

    case $Running_Mode in
        *"Linux"*)
            echo -e "" && Echo_INFOR "Current TCP connection:"
            cat  /proc/net/tcp | wc -l
            echo -e "" && Echo_INFOR "Routing forward status:"
            ip_forward=$(more /proc/sys/net/ipv4/ip_forward | awk -F: '{if ($1==1) print "1"}')
            if [ -n "$ip_forward" ]; then
                echo "Route forward is enabled"
            else
                echo "Route forward is not enabled"
            fi
            ;;
    esac

    echo -e "\n" && Echo_INFOR "Current routing table:"
    case $Running_Mode in
        *"Darwin"*)
            netstat -nr
            ;;
        *"Linux"*)
            ip route 2>> /tmp/f8x_error.log || route -n 2>> /tmp/f8x_error.log
            ;;
    esac

    echo -e "" && Echo_INFOR "Listening port:"
    case $Running_Mode in
        *"Darwin"*)
            netstat -anvp tcp
            netstat -anvp udp
            ;;
        *"Linux"*)
            netstat -tunlp 2>> /tmp/f8x_error.log || ss -tnlp 2>> /tmp/f8x_error.log
            ;;
    esac

    echo -e "\033[1;33m\n>> Identity Information\n\033[0m"

    Echo_INFOR "All system users:"
    echo -e "\n\n\n>> All system users: " >> /tmp/f8x_info.log
    cut -d: -f1 /etc/passwd >> /tmp/f8x_info.log && echo -e "Due to more echoes, it has been output to /tmp/f8x_info.log"

    echo -e "" && Echo_INFOR "System Super User:"
    grep -v -E "^#" /etc/passwd | awk -F: '$3 == 0 { print $1}'

    case $Running_Mode in
        *"Linux"*)
            echo -e "" && Echo_INFOR "Account information for remote login:"
            awk '/\$1|\$6/{print $1}' /etc/shadow
            echo -e "" && Echo_INFOR "Startup service:"
            echo -e "\n\n\n>> Startup service: " >> /tmp/f8x_info.log
            systemctl list-unit-files | grep enabled >> /tmp/f8x_info.log && echo -e "Due to more echoes, it has been output to /tmp/f8x_info.log"
            ;;
    esac

    echo -e "" && Echo_INFOR "All groups in the system:"
    echo -e "\n\n\n>> All groups in the system: " >> /tmp/f8x_info.log
    cut -d: -f1,2,3 /etc/group >> /tmp/f8x_info.log && echo -e "Due to more echoes, it has been output to /tmp/f8x_info.log"

    echo -e "" && Echo_INFOR "Scheduled tasks for the current user:"
    crontab -l

    echo -e "" && Echo_INFOR "Resource limits for currently logged-in users:"
    ulimit -a

    echo -e "\033[1;33m\n>> Security Information\033[0m"

    echo -e "" && Echo_INFOR "Environment Variables:"
    echo -e "\n\n\n>> Environment Variables: " >> /tmp/f8x_info.log
    env >> /tmp/f8x_info.log && echo -e "Output to /tmp/f8x_info.log"

    case $Linux_Version in
        *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
            echo -e "" && Echo_INFOR "Check all rpm packages to see which commands have been replaced:"
            rpm -Va
            ;;
        *"Kali"*|*"Ubuntu"*|*"Debian"*)
            echo -e "" && Echo_INFOR "View repository key:"
            echo -e "\n\n\n>> View repository key: " >> /tmp/f8x_info.log
            apt-key list 1>> /tmp/f8x_info.log 2>> /tmp/f8x_error.log && echo -e "Output to /tmp/f8x_info.log"
            ;;
    esac

}

# -clear
clear_log(){

    echo -e "\033[1;33m\n>> System usage traces are being cleaned\n\033[0m"

    cat /dev/null > /var/log/auth.log && Echo_INFOR "cat /dev/null > /var/log/auth.log"
    cat /dev/null > /var/log/kern.log && Echo_INFOR "cat /dev/null > /var/log/kern.log"
    cat /dev/null > /var/log/cron.log && Echo_INFOR "cat /dev/null > /var/log/cron.log"
    cat /dev/null > /var/log/mysqld.log && Echo_INFOR "cat /dev/null > /var/log/mysqld.log"
    cat /dev/null > /var/log/system.log && Echo_INFOR "cat /dev/null > /var/log/system.log"

    cat /dev/null > /var/log/boot.log && Echo_INFOR "cat /dev/null > /var/log/boot.log"
    cat /dev/null > /var/log/yum.log && Echo_INFOR "cat /dev/null > /var/log/yum.log"
    cat /dev/null > /var/log/mail.info && Echo_INFOR "cat /dev/null > /var/log/mail.info"
    cat /dev/null > /var/log/wpa_supplicant.log && Echo_INFOR "cat /dev/null > /var/log/wpa_supplicant.log"

    cat /dev/null > /var/log/btmp && Echo_INFOR "cat /dev/null > /var/log/btmp"
    cat /dev/null > /var/log/cron && Echo_INFOR "cat /dev/null > /var/log/cron"
    cat /dev/null > /var/log/dmesg && Echo_INFOR "cat /dev/null > /var/log/dmesg"
    cat /dev/null > /var/log/firewalld && Echo_INFOR "cat /dev/null > /var/log/firewalld"
    cat /dev/null > /var/log/grubby && Echo_INFOR "cat /dev/null > /var/log/grubby"
    cat /dev/null > /var/log/lastlog && Echo_INFOR "cat /dev/null > /var/log/lastlog"
    cat /dev/null > /var/log/maillog && Echo_INFOR "cat /dev/null > /var/log/maillog"
    cat /dev/null > /var/log/messages && Echo_INFOR "cat /dev/null > /var/log/messages"
    cat /dev/null > /var/log/secure && Echo_INFOR "cat /dev/null > /var/log/secure"
    cat /dev/null > /var/log/spooler && Echo_INFOR "cat /dev/null > /var/log/spooler"
    cat /dev/null > /var/log/syslog && Echo_INFOR "cat /dev/null > /var/log/syslog"
    cat /dev/null > /var/log/tallylog && Echo_INFOR "cat /dev/null > /var/log/tallylog"
    cat /dev/null > /var/log/wtmp && Echo_INFOR "cat /dev/null > /var/log/wtmp"
    cat /dev/null > /var/log/utmp && Echo_INFOR "cat /dev/null > /var/log/utmp"

    cat /dev/null > ~/.bash_history && Echo_INFOR "cat /dev/null > ~/.bash_history"
    cat /dev/null > ~/.zsh_history && Echo_INFOR "cat /dev/null > ~/.zsh_history"

    Echo_INFOR "Cleaned up"

}

# -remove
remove_watcher(){

    echo -e "\033[1;33m\n>> Uninstall some vps cloud monitoring\n\033[0m"

    if ps aux | grep -i '[a]liyun'
    then
        # 卸载阿里云盾和监控服务
        /etc/init.d/aegis uninstall
        wget "http://update2.aegis.aliyun.com/download/uninstall.sh" && chmod +x uninstall.sh && ./uninstall.sh
        wget http://update.aegis.aliyun.com/download/uninstall.sh && chmod +x uninstall.sh && ./uninstall.sh
        wget http://update.aegis.aliyun.com/download/quartz_uninstall.sh && chmod +x quartz_uninstall.sh && ./quartz_uninstall.sh

        sudo pkill aliyun-service
        killall -9 aliyun-service
        sudo pkill AliYunDun
        killall -9 AliYunDun
        sudo rm -fr /etc/init.d/agentwatch /usr/sbin/aliyun-service
        sudo rm -rf /usr/local/aegis*
        systemctl stop aliyun.service
        systemctl disable aliyun.service

        # 屏蔽云盾 IP，用包过滤屏蔽如下 IP
        iptables -I INPUT -s 100.100.30.1/28 -j DROP
        iptables -I INPUT -s 140.205.201.0/28 -j DROP
        iptables -I INPUT -s 140.205.201.16/29 -j DROP
        iptables -I INPUT -s 140.205.201.32/28 -j DROP
        iptables -I INPUT -s 140.205.225.192/29 -j DROP
        iptables -I INPUT -s 140.205.225.200/30 -j DROP
        iptables -I INPUT -s 140.205.225.184/29 -j DROP
        iptables -I INPUT -s 140.205.225.183/32 -j DROP
        iptables -I INPUT -s 140.205.225.206/32 -j DROP
        iptables -I INPUT -s 140.205.225.205/32 -j DROP
        iptables -I INPUT -s 140.205.225.195/32 -j DROP
        iptables -I INPUT -s 140.205.225.204/32 -j DROP
        service iptables save
        service iptables restart

        rm -rf /etc/init.d/agentwatch /usr/sbin/aliyun-service
        rm -rf /usr/local/aegis*
        systemctl stop aliyun.service
        systemctl disable aliyun.service
        service bcm-agent stop
        yum remove bcm-agent -y
        apt-get remove bcm-agent -y

        # 卸载云监控 Java 版本插件
        sudo /usr/local/cloudmonitor/wrapper/bin/cloudmonitor.sh stop
        sudo /usr/local/cloudmonitor/wrapper/bin/cloudmonitor.sh remove
        sudo rm -rf /usr/local/cloudmonitor
    elif ps aux | grep -i '[y]unjing'
    then
        # 卸载腾讯云镜
        process=(sap100 secu-tcs-agent sgagent64 barad_agent agent agentPlugInD pvdriver )
        for i in ${process[@]}
        do
            for A in $(ps aux | grep $i | grep -v grep | awk '{print $2}')
            do
                kill -9 $A
            done
        done
        chkconfig --level 35 postfix off
        service postfix stop
        /usr/local/qcloud/stargate/admin/stop.sh
        /usr/local/qcloud/stargate/admin/uninstall.sh
        /usr/local/qcloud/YunJing/uninst.sh
        /usr/local/qcloud/monitor/barad/admin/stop.sh
        /usr/local/qcloud/monitor/barad/admin/uninstall.sh

        rm -rf /usr/local/qcloud/
        rm -rf /usr/local/sa/
        rm -rf /usr/local/agenttools
        rm -f /etc/cron.d/sgagenttask
    fi

    Echo_INFOR "Uninstallation completed"

}

# -swap
swap_setting(){

    echo -e "\033[1;33m\n>> Swap partition configuration in progress\n\033[0m"
    Echo_INFOR "The current swap partition usage is as follows: (Empty means no swap partition is configured)"
    swapon -s 2>> /tmp/f8x_error.log

    if test -e /home/f8xswap
    then
        Echo_ALERT "/home/f8xswap file already exists"
        exit 1
    fi

    echo -e "\033[5;33m\nPlease enter the size of the swap partition(Unit is G) [Default 4G]\033[0m" && read -r input

    VALID_CHECK=$(echo "$input"|awk -F. '$1>0&&$1<=254{print "yes"}')
    if [ "${VALID_CHECK:-no}" == "yes" ]; then
        echo -e "\033[1;32m\n>> ${input}G\033[0m"
        swap_bin=`expr ${input} \* 1024`
    else
        echo -e "\033[1;32m\n>> The default size will be used\033[0m"
        swap_bin="4096"
    fi

    echo -e "\033[1;33m\n>> Swap file being created, time varies with size\n\033[0m"
    dd if=/dev/zero of=/home/f8xswap bs=1M count=$swap_bin && Echo_INFOR "Created swap in the /home/f8xswap"
    mkswap /home/f8xswap 1> /dev/null
    swapon /home/f8xswap 1> /dev/null && Echo_INFOR "Mounted file partition /home/f8xswap"
    echo -e "\n/home/f8xswap swap swap default 0 0" >> /etc/fstab
    Echo_INFOR "The current swap partition usage is as follows: (Empty means no swap partition is configured)"
    swapon -s 2>> /tmp/f8x_error.log

}

# -asciinema
asciinema_Install(){

    name="asciinema"
    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    asciinema --version > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        Install_Switch4 "asciinema"
        asciinema --version > /dev/null 2>&1

        if [ $? == 0 ]
        then
            Echo_INFOR "pip is very useful, isn't it :)"
        else
            Echo_ERROR "pip3 failed to install $name, about to switch to package manager to install"
            Rm_Lock
            Install_Switch "asciinema"
        fi

    fi
    Echo_INFOR "Run the following command to enable screenshots:"
    Echo_INFOR "asciinema rec"

}

# -bt
bt_Install(){

    echo -e "\033[1;33m\n>> Installing 宝塔 Linux 面板\n\033[0m"

    case $Linux_Version in
        *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
            cd /tmp && curl -o install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh
            ;;
        *"Kali"*|*"Ubuntu"*|*"Debian"*)
            cd /tmp && curl -o install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && sudo bash install.sh
            ;;
        *) ;;
    esac

}

# -aa
aaPanel_Install(){

    echo -e "\033[1;33m\n>> Installing aaPanel\n\033[0m"

    case $Linux_Version in
        *"CentOS"*|*"RedHat"*|*"Fedora"*|*"AlmaLinux"*|*"VzLinux"*|*"Rocky"*)
            cd /tmp && curl -o install.sh http://www.aapanel.com/script/install_6.0_en.sh && bash install.sh aapanel
            ;;
        *"Kali"*|*"Ubuntu"*|*"Debian"*)
            cd /tmp && curl -o install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh && sudo bash install.sh aapanel
            ;;
        *) ;;
    esac

}

# -clash
clash_Install(){

    name="clash"

    echo -e "\033[1;33m\n>> Installing $name\n\033[0m"

    clash -v > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
        Echo_INFOR "如果提示找不到 clash 命令,请尝试输入 source /etc/profile &> /dev/null && clash"
    else
        # https://github.com/juewuy/ShellClash
        export tmp_url='https://cdn.jsdelivr.net/gh/juewuy/ShellClash@master' && sh -c "$(curl -kfsSl $tmp_url/install.sh)" && source /etc/profile &> /dev/null
        Echo_INFOR "如果提示找不到 clash 命令,请输入 source /etc/profile &> /dev/null && clash"
    fi

}

# Compile and install jq does not run by default
jq_Install(){

    name="jq"
    which jq > /dev/null 2>&1

    if [ $? == 0 ]
    then
        Echo_ALERT "$name installed"
    else
        mkdir -p /tmp/jq && cd /tmp/jq && rm -rf ${jq_bin} && rm -rf ${jq_dir} && $Proxy_OK wget -O ${jq_bin} ${GitProxy}https://github.com/stedolan/jq/releases/download/${jq_ver}/${jq_bin} > /dev/null 2>&1 || Echo_ERROR "${jq_bin} download failed"
        unzip ${jq_bin} > /dev/null 2>&1
        cd ${jq_dir} && ./configure --prefix=/usr/local && make && make install
        ls -s /opt/jq/${jq_dir}/jq /usr/local/bin/jq
        rm -rf /tmp/jq
        jq -h > /dev/null 2>&1 && Echo_INFOR "${name} installed" || Echo_ERROR3
    fi

}

# 更新已经安装的软件
pentest_tool_upgrade(){

    nuclei -version > /dev/null 2>&1
    if [ $? == 0 ]
    then
        if test -e /tmp/IS_CI
        then
            input="y"
        else
            Echo_ALERT "Nuclei 已安装,是否需要覆盖更新 nuclei $Nuclei_Ver ? [y/N,默认No]" && read -r input
        fi
        case $input in
            [yY][eE][sS]|[Yy])
                rm -rf /usr/local/bin/nuclei
                Pentest_Nuclei_Install
                ;;
            *)
                sleep 0.001
                ;;
        esac
    else
        Echo_ERROR "Nuclei 未安装"
        Pentest_Nuclei_Install
    fi

    which httpx > /dev/null 2>&1
    if [ $? == 0 ]
    then
        if test -e /tmp/IS_CI
        then
            input="y"
        else
            Echo_ALERT "httpx 已安装,是否需要覆盖更新 httpx $httpx_Ver ? [y/N,默认No]" && read -r input
        fi
        case $input in
            [yY][eE][sS]|[Yy])
                rm -rf /usr/local/bin/httpx
                Pentest_httpx_Install
                ;;
            *)
                sleep 0.001
                ;;
        esac
    else
        Echo_ERROR "httpx 未安装"
        Pentest_httpx_Install
    fi

    naabu -version > /dev/null 2>&1
    if [ $? == 0 ]
    then
        if test -e /tmp/IS_CI
        then
            input="y"
        else
            Echo_ALERT "naabu 已安装,是否需要覆盖更新 naabu $naabu_Ver ? [y/N,默认No]" && read -r input
        fi
        case $input in
            [yY][eE][sS]|[Yy])
                rm -rf /usr/local/bin/naabu
                Pentest_naabu_Install
                ;;
            *)
                sleep 0.001
                ;;
        esac
    else
        Echo_ERROR "naabu 未安装"
        Pentest_naabu_Install
    fi

    name="AboutSecurity"
    if test -d $P_Dir/$name
    then
        Echo_ALERT "$name 字典库已安装,以下是最近3条更新记录"
        cd $P_Dir/AboutSecurity && git log --color --date=format:'%Y-%m-%d %H:%M:%S' --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Cblue %s %Cgreen(%cd) %C(bold blue)<%an>%Creset' --abbrev-commit --no-merges -n 3
        echo -e ""
        if test -e /tmp/IS_CI
        then
            input="y"
        else
            Echo_ALERT "是否需要更新 AboutSecurity ? [y/N,默认No]" && read -r input
        fi
        case $input in
            [yY][eE][sS]|[Yy])
                cd $P_Dir/AboutSecurity && $Proxy_OK git pull
                ;;
            *)
                sleep 0.001
                ;;
        esac
    else
        Echo_ERROR "$name 未安装"
        Pentest_Dic_Install
    fi

}

# -all
all_Install(){

    Base_Install

    optimize_setting

    Dev_Tools

    Oraclejdk_Install

    nn_Install

    kali_Tools

}

# -d
Dev_Tools(){

    Dev_Base_Install
    echo -e "\033[1;33m\n>> Installing python3 and pip3\n\033[0m"
    Python3_def_Install
    Python2_Install
    echo -e "\033[1;33m\n>> Installing Go\n\033[0m"
    Go_Install
    echo -e "\033[1;33m\n>> Installing Docker and Docker-compose\n\033[0m"
    Docker_Install
    echo -e "\033[1;33m\n>> Installing SDKMAN!\n\033[0m"
    SDKMAN_Install

}

# -f
Fun_Tools(){

    echo -e "\033[1;33m\n>> Installing AdGuardHome DNS\n\033[0m"
    AdGuardHome_Install
    echo -e "\033[1;33m\n>> Installing trash-cli\n\033[0m"
    trash-cli_Install
    echo -e "\033[1;33m\n>> Installing thefuck\n\033[0m"
    thefuck_Install
    echo -e "\033[1;33m\n>> Installing fzf\n\033[0m"
    fzf_Install
    echo -e "\033[1;33m\n>> Installing lux\n\033[0m"
    lux_Install
    echo -e "\033[1;33m\n>> Installing you-get\n\033[0m"
    you-get_Install
    echo -e "\033[1;33m\n>> Installing ffmpeg\n\033[0m"
    ffmpeg_Install
    echo -e "\033[1;33m\n>> Installing aria2\n\033[0m"
    aria2_Install
    # echo -e "\033[1;33m\n>> Installing filebrowser\n\033[0m"
    # filebrowser_Install
    echo -e "\033[1;33m\n>> Installing ttyd\n\033[0m"
    ttyd_Install
    echo -e "\033[1;33m\n>> Installing duf\n\033[0m"
    duf_Install
    echo -e "\033[1;33m\n>> Installing yq\n\033[0m"
    yq_Install

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            echo -e "\033[1;33m\n>> Installing starship\n\033[0m"
            starship_Install
            echo -e "\033[1;33m\n>> Installing procs\n\033[0m"
            procs_Install
            ;;
    esac

    case $Linux_Version in
        *"Kali"*|*"Ubuntu"*|*"Debian"*)
            echo -e "\033[1;33m\n>> Installing ncdu\n\033[0m"
            ncdu_Install
            echo -e "\033[1;33m\n>> Installing exa\n\033[0m"
            exa_Install
            echo -e "\033[1;33m\n>> Installing htop\n\033[0m"
            htop_Install
            echo -e "\033[1;33m\n>> Installing bat\n\033[0m"
            bat_Install
            echo -e "\033[1;33m\n>> Installing fd\n\033[0m"
            fd_Install
            ;;
        *) ;;
    esac

    echo -e "\033[1;33m\n>> Installing ctop\n\033[0m"
    ctop_Install

    # Bash_Insulter
    # vlmcsd_Install

}

# -k
kali_Tools(){

    echo -e "\033[1;33m\n>> Configuring pentest environment\n\033[0m"
    Pentest_Base_Install
    echo -e "\033[1;33m\n>> Downloading AboutSecurity dictionary\n\033[0m"
    Pentest_Dic_Install
    echo -e "\033[1;33m\n>> Installing python modules\n\033[0m"
    Pentest_pip_Install

    case "$1" in
        a)
            kali_Tools_TypeA
            ;;
        b)
            kali_Tools_TypeB
            ;;
        c)
            kali_Tools_TypeC
            ;;
        d)
            kali_Tools_TypeD
            ;;
        e)
            kali_Tools_TypeE
            ;;
        *)
            echo -e "\033[1;33m\n>> Install misc tools\n\033[0m"
            Pentest_Misc_Install
            kali_Tools_TypeA
            kali_Tools_TypeB
            kali_Tools_TypeC
            kali_Tools_TypeD
            ;;
    esac

}

kali_Tools_TypeA(){

    echo -e "\033[1;33m\n>> Installing nmap\n\033[0m"
    Pentest_nmap_Install
    echo -e "\033[1;33m\n>> Installing ffuf\n\033[0m"
    Pentest_ffuf_Install
    echo -e "\033[1;33m\n>> Installing JSFinder\n\033[0m"
    Pentest_JSFinder_Install
    echo -e "\033[1;33m\n>> Installing SecretFinder\n\033[0m"
    Pentest_SecretFinder_Install
    echo -e "\033[1;33m\n>> Installing OneForAll\n\033[0m"
    Pentest_OneForAll_Install
    echo -e "\033[1;33m\n>> Installing masscan\n\033[0m"
    Pentest_masscan_Install
    echo -e "\033[1;33m\n>> Installing rad\n\033[0m"
    Pentest_rad_Install
    echo -e "\033[1;33m\n>> Installing crawlergo\n\033[0m"
    Pentest_crawlergo_Install
    echo -e "\033[1;33m\n>> Installing katana\n\033[0m"
    Pentest_katana_Install
    echo -e "\033[1;33m\n>> Installing Arjun\n\033[0m"
    Pentest_Arjun_Install
    echo -e "\033[1;33m\n>> Installing httpx\n\033[0m"
    Pentest_httpx_Install
    echo -e "\033[1;33m\n>> Installing subfinder\n\033[0m"
    Pentest_subfinder_Install
    echo -e "\033[1;33m\n>> Installing apktool\n\033[0m"
    Pentest_apktool_Install
    echo -e "\033[1;33m\n>> Installing ApkAnalyser\n\033[0m"
    Pentest_ApkAnalyser_Install
    echo -e "\033[1;33m\n>> Installing apkleaks\n\033[0m"
    Pentest_apkleaks_Install
    echo -e "\033[1;33m\n>> Installing Diggy\n\033[0m"
    Pentest_Diggy_Install
    echo -e "\033[1;33m\n>> Installing AppInfoScanner\n\033[0m"
    Pentest_AppInfoScanner_Install
    echo -e "\033[1;33m\n>> Installing Amass\n\033[0m"
    Pentest_Amass_Install
    echo -e "\033[1;33m\n>> Installing dirsearch\n\033[0m"
    Pentest_dirsearch_Install
    echo -e "\033[1;33m\n>> Installing netspy\n\033[0m"
    Pentest_netspy_Install
    echo -e "\033[1;33m\n>> Installing ksubdomain\n\033[0m"
    Pentest_ksubdomain_Install
    echo -e "\033[1;33m\n>> Installing naabu\n\033[0m"
    Pentest_naabu_Install
    echo -e "\033[1;33m\n>> Installing gau\n\033[0m"
    Pentest_gau_Install
    echo -e "\033[1;33m\n>> Installing gobuster\n\033[0m"
    Pentest_gobuster_Install
    echo -e "\033[1;33m\n>> Installing fscan\n\033[0m"
    Pentest_fscan_Install
    echo -e "\033[1;33m\n>> Installing fingerprintx\n\033[0m"
    Pentest_fingerprintx_Install
    echo -e "\033[1;33m\n>> Installing HostCollision\n\033[0m"
    Pentest_HostCollision_Install
    echo -e "\033[1;33m\n>> Installing asnmap\n\033[0m"
    Pentest_asnmap_Install
    echo -e "\033[1;33m\n>> Installing tlsx\n\033[0m"
    Pentest_tlsx_Install

    # Pentest_gospider_Install
    # Pentest_dismap_Install
    # Pentest_htpwdScan_Install
    # Pentest_WebCrack_Install
    # Pentest_csprecon_Install
    # Pentest_zscan_Install

}

kali_Tools_TypeB(){

    echo -e "\033[1;33m\n>> Installing/Update Metasploit\n\033[0m"
    Pentest_Metasploit_Install
    echo -e "\033[1;33m\n>> Installing Sqlmap\n\033[0m"
    Pentest_Sqlmap_Install
    echo -e "\033[1;33m\n>> Installing xray\n\033[0m"
    Pentest_xray_Install
    echo -e "\033[1;33m\n>> Installing Nuclei\n\033[0m"
    Pentest_Nuclei_Install
    Pentest_nuclei-templates_Install
    echo -e "\033[1;33m\n>> Installing w13scan\n\033[0m"
    Pentest_w13scan_Install
    echo -e "\033[1;33m\n>> Installing swagger-exp\n\033[0m"
    Pentest_swagger-exp_Install
    echo -e "\033[1;33m\n>> Installing swagger-hack\n\033[0m"
    Pentest_swagger-hack_Install
    echo -e "\033[1;33m\n>> Installing ysoserial\n\033[0m"
    Pentest_ysoserial_Install
    echo -e "\033[1;33m\n>> Installing ysuserial\n\033[0m"
    Pentest_ysuserial_Install
    echo -e "\033[1;33m\n>> Installing JNDI-Injection-Exploit\n\033[0m"
    Pentest_JNDI-Injection-Exploit_Install
    echo -e "\033[1;33m\n>> Installing marshalsec\n\033[0m"
    Pentest_marshalsec_Install
    echo -e "\033[1;33m\n>> Installing ysomap\n\033[0m"
    Pentest_ysomap_Install
    echo -e "\033[1;33m\n>> Installing SSRFmap\n\033[0m"
    Pentest_SSRFmap_Install
    echo -e "\033[1;33m\n>> Installing testssl.sh\n\033[0m"
    Pentest_testssl_Install
    echo -e "\033[1;33m\n>> Installing dalfox\n\033[0m"
    Pentest_dalfox_Install
    echo -e "\033[1;33m\n>> Installing Gopherus\n\033[0m"
    Pentest_Gopherus_Install
    echo -e "\033[1;33m\n>> Installing CDK\n\033[0m"
    Pentest_CDK_Install
    echo -e "\033[1;33m\n>> Installing cf\n\033[0m"
    Pentest_cf_Install

    # Pentest_pocsuite3_Install
    # Pentest_commix_Install
    # Pentest_tplmap_Install
    # Pentest_OpenRedireX_Install
    # Pentest_CORScanner_Install
    # Pentest_remote-method-guesser_Install
    # Pentest_redis-rogue-server_Install
    # Pentest_redis-rogue-server-win_Install
    # Pentest_redis-rce_Install
    # Pentest_redis_lua_exploit_Install
    # Pentest_shiro_rce_tool_Install
    # Pentest_shiro-exploit_Install
    # Pentest_JNDIExploit_Install
    # Pentest_JNDIExploit_0x727_Install

}

kali_Tools_TypeC(){

    echo -e "\033[1;33m\n>> Installing impacket\n\033[0m"
    Pentest_Impacket_Install
    echo -e "\033[1;33m\n>> Installing Responder\n\033[0m"
    Pentest_Responder_Install
    echo -e "\033[1;33m\n>> Installing krbrelayx\n\033[0m"
    Pentest_krbrelayx_Install
    echo -e "\033[1;33m\n>> Installing bettercap\n\033[0m"
    Pentest_bettercap_Install
    echo -e "\033[1;33m\n>> Installing mitmproxy\n\033[0m"
    Pentest_mitmproxy_Install
    echo -e "\033[1;33m\n>> Installing pypykatz\n\033[0m"
    Pentest_pypykatz_Install
    echo -e "\033[1;33m\n>> Installing CrackMapExec\n\033[0m"
    Pentest_CrackMapExec_Install
    echo -e "\033[1;33m\n>> Installing Neo-reGeorg\n\033[0m"
    Pentest_Neo-reGeorg_Install

}

kali_Tools_TypeD(){

    echo -e "\033[1;33m\n>> Installing hashcat、7z2hashcat\n\033[0m"
    Pentest_hashcat_Install
    echo -e "\033[1;33m\n>> Installing ZoomEye-python\n\033[0m"
    Pentest_ZoomEye_Install
    echo -e "\033[1;33m\n>> Installing jadx\n\033[0m"
    Pentest_jadx_Install
    echo -e "\033[1;33m\n>> Installing ncat\n\033[0m"
    Pentest_ncat_Install
    echo -e "\033[1;33m\n>> Installing mapcidr\n\033[0m"
    Pentest_mapcidr_Install
    echo -e "\033[1;33m\n>> Installing dnsx\n\033[0m"
    Pentest_dnsx_Install
    echo -e "\033[1;33m\n>> Installing uncover\n\033[0m"
    Pentest_uncover_Install
    echo -e "\033[1;33m\n>> Installing nali\n\033[0m"
    Pentest_nali_Install
    echo -e "\033[1;33m\n>> Installing anew\n\033[0m"
    Pentest_anew_Install
    echo -e "\033[1;33m\n>> Installing gron\n\033[0m"
    Pentest_gron_Install
    echo -e "\033[1;33m\n>> Installing Interlace\n\033[0m"
    Pentest_Interlace_Install
    echo -e "\033[1;33m\n>> Installing sttr\n\033[0m"
    Pentest_sttr_Install
    echo -e "\033[1;33m\n>> Installing unfurl\n\033[0m"
    Pentest_unfurl_Install
    echo -e "\033[1;33m\n>> Installing qsreplace\n\033[0m"
    Pentest_qsreplace_Install
    echo -e "\033[1;33m\n>> Installing Platypus\n\033[0m"
    Pentest_Platypus_Install
    echo -e "\033[1;33m\n>> Installing MoreFind\n\033[0m"
    Pentest_MoreFind_Install

    # Pentest_iprange_Install
    # Pentest_jwtcat_Install
    # Pentest_gojwtcrack_Install
    # Pentest_DomainSplit_Install
    # Pentest_proxify_Install

}

kali_Tools_TypeE(){

    echo -e "\033[1;33m\n>> Installing SecLists(~500M),longer time, wait patiently\n\033[0m"
    Pentest_SecLists_Install
    echo -e "\033[1;33m\n>> Installing Girsh\n\033[0m"
    Pentest_Girsh_Install
    echo -e "\033[1;33m\n>> Installing See-SURF\n\033[0m"
    Pentest_See-SURF_Install
    echo -e "\033[1;33m\n>> Installing hakrawler\n\033[0m"
    Pentest_hakrawler_Install
    echo -e "\033[1;33m\n>> Installing jaeles\n\033[0m"
    Pentest_jaeles_Install
    echo -e "\033[1;33m\n>> Installing subjs\n\033[0m"
    Pentest_subjs_Install
    echo -e "\033[1;33m\n>> Installing assetfinder\n\033[0m"
    Pentest_assetfinder_Install

    # Pentest_routersploit_Install
    # Pentest_exploitdb_Install
    # Pentest_RustScan_Install
    # Pentest_WAFW00F_Install
    # Pentest_WebAliveScan_Install
    # Pentest_MassBleed_Install

}

# -b
Base_Install(){

    echo -e "\033[1;33m\n>> Installing basic tools\n\033[0m"
    Base_Tools

}

# -s
Secure(){

    echo -e "\033[1;33m\n>> Installing Fail2Ban\n\033[0m"
    Secure_Fail2Ban_Install
    echo -e "\033[1;33m\n>> Installing rkhunter\n\033[0m"
    Secure_rkhunter_Install
    echo -e "\033[1;33m\n>> Installing anti-portscan\n\033[0m"
    Secure_anti_portscan_Install
    echo -e "\033[1;33m\n>> Installing fapro\n\033[0m"
    Secure_fapro_Install

    case $Linux_architecture_Name in
        *"linux-x86_64"*)
            # echo -e "\033[1;33m\n>> Installing chkrootkit\n\033[0m"
            # Secure_chkrootkit_Install
            echo -e "\033[1;33m\n>> Installing shellpub\n\033[0m"
            Secure_shellpub_Install
            echo -e "\033[1;33m\n>> Installing BruteShark\n\033[0m"
            Secure_BruteShark_Install
            ;;
    esac

}

# -cloud
cloud(){

    echo -e "\033[1;33m\n>> Installing Terraform\n\033[0m"
    Terraform_Install

    echo -e "\033[1;33m\n>> Installing aliyun-cli\n\033[0m"
    aliyun-cli_Install

    echo -e "\033[1;33m\n>> Installing aws-cli\n\033[0m"
    aws-cli_Install

    echo -e "\033[1;33m\n>> Continue installation Serverless Framework? [y/N,Default N] \033[0m" && read -r input
    case $input in
        [yY][eE][sS]|[Yy])
            nn_Check
            echo -e "\033[1;33m\n>> Installing Serverless Framework\n\033[0m"
            Serverless_Framework_Install
            ;;
        *)
            Echo_INFOR "Pass~"
            ;;
    esac

    echo -e "\033[1;33m\n>> Continue installation wrangler? [y/N,Default N] \033[0m" && read -r input
    case $input in
        [yY][eE][sS]|[Yy])
            Rust_Check
            echo -e "\033[1;33m\n>> Installing wrangler\n\033[0m"
            wrangler_Install
            ;;
        *)
            Echo_INFOR "Pass~"
            ;;
    esac

}

# -ssh
SSH(){

    echo -e "\033[1;33m\n>> Configuring SSH\n\033[0m"
    SSH_Tools

}

# -h
Help(){

    echo -e "\033[1;34mBatch installation \033[0m"
    echo -e "  \033[1;34m-b\033[0m \033[0;34m               : install Basic Environment\033[0m          \033[1;32m(gcc、make、git、vim、telnet、jq、unzip ...)\033[0m"
    echo -e "  \033[1;34m-p\033[0m \033[0;34m               : install Proxy Environment\033[0m          \033[1;31m(Warning : Use only when needed)\033[0m"
    echo -e "  \033[1;34m-d\033[0m \033[0;34m               : install Development Environment\033[0m    \033[1;32m(python3、pip3、Go、Docker、Docker-Compose、SDKMAN)\033[0m"
    echo -e "  \033[1;34m-k(a/b/c/d/e)\033[0m\033[0;34m     : install Pentest environment\033[0m        \033[1;32m(hashcat、ffuf、OneForAll、ksubdomain、impacket ...)\033[0m"
    echo -e "  \033[1;34m-s\033[0m \033[0;34m               : install Blue Team Environment\033[0m      \033[1;32m(Fail2Ban、chkrootkit、rkhunter、shellpub)\033[0m"
    echo -e "  \033[1;34m-f\033[0m \033[0;34m               : install Other Tools\033[0m                \033[1;32m(AdguardTeam、trash-cli、fzf)\033[0m"
    echo -e "  \033[1;34m-cloud\033[0m \033[0;34m           : install Cloud Applications\033[0m         \033[1;32m(Terraform、Serverless Framework、wrangler)\033[0m"
    echo -e "  \033[1;34m-all\033[0m \033[0;34m             : fully automated deployment\033[0m"
    echo -e ""
    echo -e "\033[1;34mDevelopment Environment \033[0m"
    echo -e "  \033[1;34m-docker\033[0m \033[0;34m          : install docker\033[0m"
    echo -e "  \033[1;34m-docker-cn\033[0m \033[0;34m       : install docker (aliyun source)\033[0m"
    echo -e "  \033[1;34m-lua\033[0m \033[0;34m             : install lua\033[0m"
    echo -e "  \033[1;34m-nn\033[0m \033[0;34m              : install npm & NodeJs\033[0m"
    echo -e "  \033[1;34m-go\033[0m\033[0;34m               : install golang\033[0m"
    echo -e "  \033[1;34m-oraclejdk(8/11)\033[0m\033[0;34m  : install oraclejdk\033[0m"
    echo -e "  \033[1;34m-openjdk\033[0m \033[0;34m         : install openjdk\033[0m"
    echo -e "  \033[1;34m-py3(7/8/9/10)\033[0m\033[0;34m    : install python3\033[0m                    \033[1;33m(Based on package manager)\033[0m"
    echo -e "  \033[1;34m-py2\033[0m \033[0;34m             : install python2\033[0m                    \033[1;33m(Based on package manager)\033[0m"
    echo -e "  \033[1;34m-pip2-f\033[0m \033[0;34m          : force install pip2\033[0m                 \033[1;33m(It is recommended to run with the -python2 option failing)\033[0m"
    echo -e "  \033[1;34m-perl\033[0m \033[0;34m            : install perl\033[0m"
    echo -e "  \033[1;34m-ruby\033[0m \033[0;34m            : install ruby\033[0m                       \033[1;33m(If that fails, try -ruby-f)\033[0m"
    echo -e "  \033[1;34m-rust\033[0m \033[0;34m            : install rust\033[0m"
    echo -e "  \033[1;34m-code\033[0m \033[0;34m            : install code-server\033[0m"
    echo -e "  \033[1;34m-chromium\033[0m \033[0;34m        : install Chromium\033[0m                   \033[1;33m(Used with rad, crawlergo in the -k option) \033[0m"
    echo -e "  \033[1;34m-phantomjs\033[0m \033[0;34m       : install PhantomJS\033[0m"
    #echo -e "  \033[1;34m-k8s\033[0m \033[0;34m             : install k8s\033[0m"
    echo -e ""
    echo -e "\033[1;34mBlue Team Tools \033[0m"
    echo -e "  \033[1;34m-binwalk\033[0m \033[0;34m         : install binwalk\033[0m"
    echo -e "  \033[1;34m-binwalk-f\033[0m \033[0;34m       : force install binwalk\033[0m              \033[1;33m(It is recommended to run if the -binwalk option fails)\033[0m"
    echo -e "  \033[1;34m-clamav\033[0m \033[0;34m          : install ClamAV\033[0m"
    echo -e "  \033[1;34m-lt\033[0m \033[0;34m              : install LogonTracer\033[0m                \033[1;33m(High hardware configuration requirements)\033[0m"
    echo -e "  \033[1;34m-suricata\033[0m \033[0;34m        : install Suricata\033[0m"
    echo -e "  \033[1;34m-vol\033[0m \033[0;34m             : install volatility\033[0m"
    echo -e "  \033[1;34m-vol3\033[0m \033[0;34m            : install volatility3\033[0m"
    echo -e ""
    echo -e "\033[1;34mRed Team Tools \033[0m"
    echo -e "  \033[1;34m-aircrack\033[0m \033[0;34m        : install aircrack-ng\033[0m"
    echo -e "  \033[1;34m-bypass\033[0m \033[0;34m          : install Bypass\033[0m"
    echo -e "  \033[1;34m-goby\033[0m \033[0;34m            : install Goby\033[0m                       \033[1;33m(Requires GUI environment)\033[0m"
    echo -e "  \033[1;34m-wpscan\033[0m \033[0;34m          : install wpscan\033[0m"
    echo -e "  \033[1;34m-yakit\033[0m \033[0;34m           : install yakit\033[0m"
    echo -e ""
    echo -e "\033[1;34mRed Team Infrastructure \033[0m"
    echo -e "  \033[1;34m-arl\033[0m \033[0;34m             : install ARL (~872 MB)\033[0m              \033[1;33m(https://github.com/TophantTechnology/ARL)\033[0m"
    echo -e "  \033[1;34m-awvs14\033[0m \033[0;34m          : install AWVS14 (~1.04 GB)\033[0m"
    echo -e "  \033[1;34m-cs\033[0m \033[0;34m              : install CobaltStrike 4.3\033[0m"
    echo -e "  \033[1;34m-cs45\033[0m \033[0;34m            : install CobaltStrike 4.5\033[0m"
    echo -e "  \033[1;34m-frp\033[0m \033[0;34m             : install frp\033[0m"
    echo -e "  \033[1;34m-interactsh\033[0m \033[0;34m      : install interactsh\033[0m                 \033[1;33m(https://github.com/projectdiscovery/interactsh)\033[0m"
    echo -e "  \033[1;34m-merlin\033[0m \033[0;34m          : install merlin\033[0m                     \033[1;33m(https://github.com/Ne0nd0g/merlin)\033[0m"
    echo -e "  \033[1;34m-msf\033[0m \033[0;34m             : install Metasploit\033[0m"
    echo -e "  \033[1;34m-mobsf\033[0m \033[0;34m           : install MobSF (~1.54 GB)\033[0m"
    echo -e "  \033[1;34m-nodejsscan\033[0m \033[0;34m      : install nodejsscan (~873 MB)\033[0m"
    echo -e "  \033[1;34m-nps\033[0m \033[0;34m             : install nps\033[0m"
    echo -e "  \033[1;34m-pupy\033[0m \033[0;34m            : install pupy\033[0m\033[0m                       \033[1;33m(https://github.com/n1nj4sec/pupy)\033[0m"
    echo -e "  \033[1;34m-rg\033[0m \033[0;34m              : install RedGuard\033[0m                   \033[1;33m(https://github.com/wikiZ/RedGuard)\033[0m"
    echo -e "  \033[1;34m-sliver\033[0m \033[0;34m          : install sliver-server && client\033[0m\033[0m    \033[1;33m(https://github.com/BishopFox/sliver)\033[0m"
    echo -e "  \033[1;34m-sliver-client\033[0m \033[0;34m   : install sliver-client\033[0m\033[0m"
    echo -e "  \033[1;34m-sps\033[0m \033[0;34m             : install SharPyShell\033[0m\033[0m                \033[1;33m(https://github.com/antonioCoco/SharPyShell)\033[0m"
    echo -e "  \033[1;34m-viper\033[0m \033[0;34m           : install Viper (~2.1 GB)\033[0m\033[0m            \033[1;33m(https://github.com/FunnyWolf/Viper)\033[0m"
    echo -e ""
    echo -e "\033[1;34mVulnerable Environments\033[0m"
    echo -e "  \033[1;34m-metarget\033[0m \033[0;34m        : install metarget\033[0m                   \033[1;33m(https://github.com/Metarget/metarget)\033[0m"
    echo -e "  \033[1;34m-vulhub\033[0m \033[0;34m          : install vulhub (~210 MB)\033[0m           \033[1;33m(https://github.com/vulhub/vulhub)\033[0m"
    echo -e "  \033[1;34m-vulfocus\033[0m \033[0;34m        : install vulfocus (~1.04 GB)\033[0m        \033[1;33m(https://github.com/fofapro/vulfocus)\033[0m"
    echo -e "  \033[1;34m-TerraformGoat\033[0m \033[0;34m   : install TerraformGoat\033[0m              \033[1;33m(https://github.com/HXSecurity/TerraformGoat)\033[0m"
    echo -e ""
    echo -e "\033[1;34mMiscellaneous Services \033[0m"
    echo -e "  \033[1;34m-asciinema\033[0m \033[0;34m       : install asciinema\033[0m"
    echo -e "  \033[1;34m-aa\033[0m \033[0;34m              : install aaPanel\033[0m                    \033[1;33m(https://www.aapanel.com/)\033[0m"
    echo -e "  \033[1;34m-bt\033[0m \033[0;34m              : install 宝塔服务\033[0m"
    echo -e "  \033[1;34m-clash\033[0m \033[0;34m           : install clash\033[0m                      \033[1;33m(https://github.com/juewuy/ShellClash)\033[0m"
    # echo -e "  \033[1;34m-music\033[0m \033[0;34m           : install UnblockNeteaseMusic\033[0m"
    echo -e "  \033[1;34m-nginx\033[0m \033[0;34m           : install nginx\033[0m"
    echo -e "  \033[1;34m-ssh\033[0m \033[0;34m             : install ssh\033[0m                        \033[1;33m(RedHat is available by default, no need to reinstall)\033[0m"
    echo -e "  \033[1;34m-ssr\033[0m \033[0;34m             : install ssr\033[0m"
    echo -e "  \033[1;34m-zsh\033[0m \033[0;34m             : install zsh\033[0m"
    echo -e ""
    echo -e "\033[1;34mOther \033[0m"
    echo -e "  \033[1;34m-clear\033[0m \033[0;34m           : Clean up system usage traces\033[0m"
    echo -e "  \033[1;34m-info\033[0m \033[0;34m            : View system information\033[0m"
    echo -e "  \033[1;34m-optimize\033[0m \033[0;34m        : Improve device options and optimize performance\033[0m"
    echo -e "  \033[1;34m-remove\033[0m \033[0;34m          : Uninstall some vps cloud monitoring\033[0m"
    echo -e "  \033[1;34m-rmlock\033[0m \033[0;34m          : Run the Unlock module\033[0m"
    echo -e "  \033[1;34m-swap\033[0m \033[0;34m            : Configuring swap partitions\033[0m"
    echo -e "  \033[1;34m-update\033[0m \033[0;34m          : Update f8x\033[0m"
    echo -e "  \033[1;34m-upgrade\033[0m \033[0;34m         : Upgrade some tools\033[0m"
    echo -e ""
    echo -e "\033[1;37mAuthor r0fus0d , feel free to submit an issue if you need to add tool support or run into problems\033[0m"
    echo -e "\033[1;37m|- create by ffffffff0x\033[0m"
    echo -e ""

}

# -p
Proxy(){

    echo -e "\033[1;33m\n>> Do you want to update DNS settings? [Y/n,Default Y]\033[0m"
    Change_DNS_IP

    echo -e "\033[1;33m\nPlease enter Source aliyun[a] huawei[h] tuna[t] 默认t\033[0m" && read -r input
    case $input in
        [aA])
            Mirror "aliyun"
            ;;
        [hH])
            Mirror "huawei"
            ;;
        [tT])
            Mirror "tuna"
            ;;
        *)
            Mirror "tuna"
            ;;
    esac

    if [ $Docker_OK != 1 ] 2>> /tmp/f8x_error.log
    then
        echo -e "\033[1;33m\n>> Installing resolvconf\n\033[0m"
        DNS_T00ls
        echo -e "\033[1;33m\n>> Configuring the base compilation environment\n\033[0m"
        Proxychains_Install
    fi

}

# -debug
Debug_Fun(){

    echo -e "none :>"

}

# -mock
Mock_Test(){

    $1

}

# Main
Main(){

    case "$(uname)" in
        *"Darwin"*)
            Running_Mode="Darwin"
            ;;
        *"MINGW64_NT"*)
            echo "Not supported on windows platform"
            exit 1
            ;;
        *)
            Running_Mode="Linux"
            setenforce 0 > /dev/null 2>&1
            ;;
    esac

    if [[ $UID != 0 ]]; then
        Echo_ERROR "Please run with sudo or root privileged account!"
        exit 1
    fi

    printf "\033c"

}

Main
Banner

case $Running_Mode in
    *"Darwin"*)
        Sys_Version_Mac
        ;;
    *"Linux"*)
        Sys_Version
        ;;
    *)
        exit 1
        ;;
esac

Sys_Info
echo -e "\033[1;36m \n-----Start execution----- \033[0m"
echo -e "\033[1;33m\n>> Initializing\n\033[0m"
Base_Dir
Docker_run_Check

for cmd in $@
do
    case $cmd in
        -b | b)
            mac_Check || exit 1
            Base_Install
            ;;
        -p | p)
            mac_Check || exit 1
            Proxy
            ;;
        -d | d)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Dev_Tools
            ;;
        -k | k)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Py_Check
            pip2_Check
            GO_Check
            kali_Tools
            ;;
        -ka | ka)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Py_Check
            kali_Tools "a"
            ;;
        -kb | kb)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Py_Check
            kali_Tools "b"
            ;;
        -kc | kc)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Py_Check
            kali_Tools "c"
            ;;
        -kd | kd)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Py_Check
            kali_Tools "d"
            ;;
        -ke | ke)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Py_Check
            kali_Tools "e"
            ;;
        -s | s)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Secure
            ;;
        -f | f)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            pip3_Check
            Fun_Tools
            ;;
        -h | h)
            printf "\033c"
            Help
            ;;
        -cloud)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            cloud
            ;;
        -all)
            mac_Check || exit 1
            all_Install
            ;;
        -docker)
            mac_Check || exit 1
            Base_Check
            Dev_Base_Install
            Docker_Install
            ;;
        -docker-cn)
            mac_Check || exit 1
            Base_Check
            Dev_Base_Install
            Docker_Install "tuna"
            ;;
        -lua)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            lua_Install
            ;;
        -nn)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            nn_Install
            ;;
        -go)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Go_Option
            ;;
        -jenv)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            jenv_Install
            ;;
        -openjdk)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Openjdk_Install
            ;;
        -oraclejdk)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Oraclejdk_Install
            ;;
        -oraclejdk8)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Oraclejdk_Install "oraclejdk8"
            ;;
        -oraclejdk11)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Oraclejdk_Install "oraclejdk11"
            ;;
        -py3 | py3)
            mac_Check || exit 1
            Python3_Install
            ;;
        -py37 | py37)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Python3_Install "py37"
            ;;
        -py38 | py38)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Python3_Install "py38"
            ;;
        -py39 | py39)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Python3_Install "py39"
            ;;
        -py310 | py310)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Python3_Install "py310"
            ;;
        -py2 | py2)
            mac_Check || exit 1
            Python2_Install
            ;;
        -pip2-f)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            pip2_Install
            ;;
        -perl)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Perl_Install
            ;;
        -ruby)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Ruby_Install
            ;;
        -ruby-f)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Ruby_Install_f
            ;;
        -rust)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Rust_Install
            ;;
        -code)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            code-server_Install
            ;;
        -chromium)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            chromium_Install
            ;;
        -phantomjs)
            mac_Check || exit 1
            linux_arm64_Check || exit 1
            Proxy_Switch
            Base_Check
            phantomjs_Install
            ;;
        -k8s)
            mac_Check || exit 1
            linux_arm64_Check || exit 1
            Proxy_Switch
            Base_Check
            k8s_Install
            ;;
        -binwalk)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            binwalk_Install
            ;;
        -binwalk-f)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            binwalk_force_Install
            ;;
        -clamav)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            clamav_Install
            ;;
        -vol)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            pip2_Check
            Volatility_Install
            ;;
        -vol3)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            pip3_Check
            volatility3_Install
            ;;
        -lt)
            mac_Check || exit 1
            Proxy_Switch
            lt_Install
            ;;
        -aircrack)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            aircrack_Install
            ;;
        -bypass)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Py_Check
            bypass_Install
            ;;
        -cs)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            cs_Install
            ;;
        -cs45)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            cs45_Install
            ;;
        -interactsh)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            interactsh_Install
            ;;
        -merlin)
            mac_Check || exit 1
            linux_arm64_Check || exit 1
            Proxy_Switch
            Base_Check
            merlin_Install
            ;;
        -msf)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Pentest_Metasploit_Install
            ;;
        -sps)
            mac_Check || exit 1
            linux_arm64_Check || exit 1
            Proxy_Switch
            Base_Check
            Pentest_Base_Install
            Py_Check
            SharPyShell_Install
            ;;
        -frp)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            frp_Install
            ;;
        -goby)
            mac_Check || exit 1
            linux_arm64_Check || exit 1
            Proxy_Switch
            Base_Check
            Goby_Install
            ;;
        -nps)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            nps_Install
            ;;
        -rg)
            mac_Check || exit 1
            linux_arm64_Check || exit 1
            Proxy_Switch
            Base_Check
            RedGuard_Install
            ;;
        -sliver)
            mac_Check || exit 1
            linux_arm64_Check || exit 1
            Proxy_Switch
            Base_Check
            sliver-server_Install
            ;;
        -sliver-client)
            mac_Check || exit 1
            linux_arm64_Check || exit 1
            Proxy_Switch
            Base_Check
            sliver-client_Install
            ;;
        -wpscan)
            mac_Check || exit 1
            linux_arm64_Check || exit 1
            Proxy_Switch
            Base_Check
            Ruby_Check
            wpscan_Install
            ;;
        -yakit)
            mac_Check || exit 1
            linux_arm64_Check || exit 1
            Proxy_Switch
            Base_Check
            yakit_Install
            ;;
        -suricata)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            suricata_Install
            ;;
        -arl)
            mac_Check || exit 1
            Proxy_Switch
            Pentest_Base_Install
            arl_Install
            ;;
        -awvs14)
            mac_Check || exit 1
            Proxy_Switch
            awvs14_Install
            ;;
        -awvs15)
            mac_Check || exit 1
            Proxy_Switch
            awvs15_Install
            ;;
        -mobsf)
            mac_Check || exit 1
            Proxy_Switch
            mobsf_Install
            ;;
        -nodejsscan)
            mac_Check || exit 1
            Proxy_Switch
            nodejsscan_Install
            ;;
        -pupy)
            mac_Check || exit 1
            Proxy_Switch
            pupy_Install
            ;;
        -viper)
            mac_Check || exit 1
            Proxy_Switch
            viper_Install
            ;;
        -metarget)
            mac_Check || exit 1
            Proxy_Switch
            metarget_Install
            ;;
        -vulhub)
            mac_Check || exit 1
            Proxy_Switch
            vulhub_Install
            ;;
        -vulfocus)
            mac_Check || exit 1
            Proxy_Switch
            vulfocus_Install
            ;;
        -TerraformGoat)
            mac_Check || exit 1
            Proxy_Switch
            TerraformGoat_Install
            ;;
        -asciinema)
            mac_Check || exit 1
            asciinema_Install
            ;;
        -bt)
            mac_Check || exit 1
            Base_Check
            bt_Install
            ;;
        -aa)
            mac_Check || exit 1
            Base_Check
            aaPanel_Install
            ;;
        -clash)
            mac_Check || exit 1
            Base_Check
            clash_Install
            ;;
        -music)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            music_Install
            ;;
        -nginx)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            nginx_Install
            ;;
        -ssh)
            mac_Check || exit 1
            SSH
            ;;
        -ssr)
            mac_Check || exit 1
            linux_arm64_Check || exit 1
            Base_Check
            ssr_Install
            ;;
        -zsh)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            pip3_Check
            zsh_Install
            ;;
        -clear)
            mac_Check || exit 1
            clear_log
            ;;
        -info)
            # Base_Check
            System_info
            ;;
        -optimize)
            mac_Check || exit 1
            optimize_setting
            ;;
        -remove)
            mac_Check || exit 1
            remove_watcher
            ;;
        -rmlock)
            mac_Check || exit 1
            Rm_Lock

            case $Linux_Version in
                *"Kali"*|*"Ubuntu"*|*"Debian"*)
                    dpkg --configure -a > /dev/null 2>&1
                    ;;
                *) ;;
            esac

            ;;
        -swap)
            mac_Check || exit 1
            swap_setting
            ;;
        -update)
            mac_Check || exit 1
            Proxy_Switch
            if test -e /usr/local/bin/f8x
            then
                rm -f /usr/local/bin/f8x && $Proxy_OK curl -o /usr/local/bin/f8x https://f8x.io && chmod +x /usr/local/bin/f8x && Echo_INFOR "Update successful" || Echo_ERROR "Update failed"
            else
                rm -f f8x && $Proxy_OK curl -o f8x https://f8x.io > /dev/null 2>&1 && Echo_INFOR "Update successful" || Echo_ERROR "Update failed"
            fi
            ;;
        -upgrade)
            mac_Check || exit 1
            Proxy_Switch
            Base_Check
            Py_Check
            GO_Check
            Pentest_Base_Install
            pentest_tool_upgrade
            ;;
        -debug)
            mac_Check || exit 1
            Base_Check
            Pentest_Base_Install
            Proxy_Switch
            Debug_Fun
            ;;
        *)
            echo -e ""
            echo -e "\033[1;34mUse the -h option to view the help documentation\033[0m"
            ;;
    esac

    echo -e "\033[1;36m \n-----End of execution-----\n \033[0m"
done