FROM ubuntu:22.04
MAINTAINER xx-zhang <actanble@gmail.com>

ENV ARMBIAN_RELEASE="jammy"
ENV TZ=Asia/Shanghai
RUN rm -rf /etc/apt/sources.list.d/* /usr/share/dotnet /usr/local/lib/android /opt/ghc 2>/dev/null

RUN sed -i 's/security.ubuntu.com/mirrors.cn99.com/g' /etc/apt/sources.list
RUN sed -i 's/archive.ubuntu.com/mirrors.cn99.com/g' /etc/apt/sources.list

#############
ADD 01_scripts_part1_apt.sh /part01.sh
RUN sed -i 's/\r//' /part01.sh && bash  /part01.sh
#############

RUN apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*


