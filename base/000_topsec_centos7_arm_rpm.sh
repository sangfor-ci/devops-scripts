#!//bin/bash

BCI_HOST='10.7.202.199'
MIRROR_HOST='10.2.136.110'

rm -rf /etc/yum.repos.d/*

# shellcheck disable=SC2076
if [[ ! `cat /etc/hosts` =~ 'mirror.topsec.com.cn' ]]; then
   echo '10.2.136.110  mirror.topsec.com.cn' >> /etc/hosts
fi

# releasever=7.9.2009
releasever=7
#basearch=x86_64
basearch=aarch64

echo "Writing Centos Base Repo..."
cat > /etc/yum.repos.d/Centos7-Base.repo <<- EOF
# CentOS-Base.repo
#
# The mirror system uses the connecting IP address of the client and the
# update status of each mirror to pick mirrors that are updated to and
# geographically close to the client.  You should use this for CentOS updates
# unless you are manually picking other mirrors.
#
# If the mirrorlist= does not work for you, as a fall back you can try the
# remarked out baseurl= line instead.
#
#

# http://10.2.136.110/centos-altarch/7.9.2009/os/aarch64/

[base]
name=CentOS-$releasever - Base
baseurl=http://mirror.topsec.com.cn/centos-altarch/$releasever/os/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os
enabled=1
gpgcheck=0
gpgkey=http://mirror.topsec.com.cn/centos-altarch/7/os/aarch64/RPM-GPG-KEY-CentOS-7

#released updates
[updates]
name=CentOS-$releasever - Updates
baseurl=http://mirror.topsec.com.cn/centos-altarch/$releasever/updates/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates
enabled=1
gpgcheck=0
gpgkey=http://mirror.topsec.com.cn/centos-altarch/7/os/aarch64/RPM-GPG-KEY-CentOS-7



#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras
baseurl=http://mirror.topsec.com.cn/centos-altarch/$releasever/extras/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras
enabled=1
gpgcheck=0
gpgkey=http://mirror.topsec.com.cn/centos-altarch/$releasever/os/aarch64/RPM-GPG-KEY-CentOS-7



#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-$releasever - Plus
baseurl=http://mirror.topsec.com.cn/centos-altarch/$releasever/centosplus/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus
gpgcheck=0
enabled=0
gpgkey=http://mirror.topsec.com.cn/centos-altarch/7/os/aarch64/RPM-GPG-KEY-CentOS-7


EOF

echo "Writing Centos Epel Repo..."
cat  > /etc/yum.repos.d/epel7.repo <<- EOF
[epel]
name=Extra Packages for Enterprise Linux 7 - $basearch
baseurl=http://mirror.topsec.com.cn/epel/7/$basearch
#mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch
failovermethod=priority
enabled=1
gpgcheck=1
gpgkey=http://mirror.topsec.com.cn/epel/RPM-GPG-KEY-EPEL-7


[epel-debuginfo]
name=Extra Packages for Enterprise Linux 7 - $basearch - Debug
baseurl=http://mirror.topsec.com.cn/epel/7/$basearch/debug
#mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-debug-7&arch=$basearch
failovermethod=priority
enabled=0
gpgkey=http://mirror.topsec.com.cn/epel/RPM-GPG-KEY-EPEL-7

gpgcheck=1

[epel-source]
name=Extra Packages for Enterprise Linux 7 - $basearch - Source
baseurl=http://mirror.topsec.com.cn/epel/7/SRPMS
#mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-source-7&arch=$basearch
failovermethod=priority
enabled=0
gpgkey=http://mirror.topsec.com.cn/epel/RPM-GPG-KEY-EPEL-7
gpgcheck=1


EOF

cat <<- EOF  > /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo

[centos-sclo-rh]
name=CentOS-7 - SCLo rh
baseurl=http://mirror.topsec.com.cn/centos-altarch/$releasever/sclo/$basearch/rh/
gpgcheck=0
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo

[centos-sclo-sclo]
name=CentOS-7 - SCLo sclo
baseurl=http://mirror.topsec.com.cn/centos-altarch/$releasever/sclo/$basearch/sclo/
gpgcheck=0
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo

EOF

echo "Writing Centos Docker Repo..."
cat <<- EOF  > /etc/yum.repos.d/docker-ce.repo
[docker-ce-stable]
name=Docker CE Stable - $basearch
baseurl=http://mirror.topsec.com.cn/docker-ce/linux/centos/$releasever/$basearch/stable
enabled=1
gpgcheck=1
gpgkey=http://mirror.topsec.com.cn/docker-ce/linux/centos/gpg

[docker-ce-stable-debuginfo]
name=Docker CE Stable - Debuginfo $basearch
baseurl=http://mirror.topsec.com.cn/docker-ce/linux/centos/$releasever/debug-$basearch/stable
enabled=0
gpgcheck=1
gpgkey=http://mirror.topsec.com.cn/docker-ce/linux/centos/gpg

[docker-ce-stable-source]
name=Docker CE Stable - Sources
baseurl=http://mirror.topsec.com.cn/docker-ce/linux/centos/$releasever/source/stable
enabled=0
gpgcheck=1
gpgkey=http://mirror.topsec.com.cn/docker-ce/linux/centos/gpg

[docker-ce-test]
name=Docker CE Test - $basearch
baseurl=http://mirror.topsec.com.cn/docker-ce/linux/centos/$releasever/$basearch/test
enabled=0
gpgcheck=1
gpgkey=http://mirror.topsec.com.cn/docker-ce/linux/centos/gpg

[docker-ce-test-debuginfo]
name=Docker CE Test - Debuginfo $basearch
baseurl=http://mirror.topsec.com.cn/docker-ce/linux/centos/$releasever/debug-$basearch/test
enabled=0
gpgcheck=1
gpgkey=http://mirror.topsec.com.cn/docker-ce/linux/centos/gpg

[docker-ce-test-source]
name=Docker CE Test - Sources
baseurl=http://mirror.topsec.com.cn/docker-ce/linux/centos/$releasever/source/test
enabled=0
gpgcheck=1
gpgkey=http://mirror.topsec.com.cn/docker-ce/linux/centos/gpg

[docker-ce-nightly]
name=Docker CE Nightly - $basearch
baseurl=http://mirror.topsec.com.cn/docker-ce/linux/centos/$releasever/$basearch/nightly
enabled=0
gpgcheck=1
gpgkey=http://mirror.topsec.com.cn/docker-ce/linux/centos/gpg

[docker-ce-nightly-debuginfo]
name=Docker CE Nightly - Debuginfo $basearch
baseurl=http://mirror.topsec.com.cn/docker-ce/linux/centos/$releasever/debug-$basearch/nightly
enabled=0
gpgcheck=1
gpgkey=http://mirror.topsec.com.cn/docker-ce/linux/centos/gpg

[docker-ce-nightly-source]
name=Docker CE Nightly - Sources
baseurl=http://mirror.topsec.com.cn/docker-ce/linux/centos/$releasever/source/nightly
enabled=0
gpgcheck=1
gpgkey=http://mirror.topsec.com.cn/docker-ce/linux/centos/gpg


EOF

yum makecache