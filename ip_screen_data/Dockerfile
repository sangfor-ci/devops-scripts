FROM python3:3.8-alpine

MAINTAINER actanble <actanble@gmail.com>
USER root

# TODO Set the time and lang
ENV LANG en_US.UTF-8
ENV TZ=Asia/Shanghai

RUN apk update && apk add tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && apk del tzdata \
        rm -rf /opt/builder && \
        rm -rf /root/* && \
        rm -rf /tmp/* && \
        rm -rf /var/cache/apk/*

ADD . /usr/src/app
WORKDIR /usr/src/app

ADD ./requriments.txt /requirements.txt
RUN pip3 install -r /requirements.txt