FROM centos:centos7.9.2009 as build

MAINTAINER actanble <actanble@gmail.com>
USER root

# TODO Set the time and lang
ENV LANG en_US.UTF-8
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
#RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo && \
#    sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo && \
#    curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
RUN yum makecache && yum -y install wget

USER root
ADD . /opt/scripts

WORKDIR /opt/scripts
RUN chmod u+x /opt/scripts/* && sed -i 's/\r//' *.sh

RUN /bin/bash ./all.sh



