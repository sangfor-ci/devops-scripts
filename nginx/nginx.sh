#!/bin/bash
#Build by zt at 20190718
#Changelog
#20200422 remove tls fuctions
#20200922 modify the insert line replace the old line-index
#20200923 add nginx status and modsec-audit log viewer [status/log]
#20201022 test for cis

curdir=$(
  cd $(dirname $0)
  pwd
)/

nginxhome=${curdir}
cd ${nginxhome}
function start() {
  ./sbin/nginx -p ${nginxhome} -c ${nginxhome}conf/nginx-https.conf
}

function stop() {
  ./sbin/nginx -p ${nginxhome} -c ${nginxhome}conf/nginx-https.conf -s stop
}

function restart() {
  stop
  sleep 5
  start
}

function version() {
  ./sbin/nginx -V
}

function status() {
  nginx_thread_num=$(ps -ef | grep nginx | grep -v grep | grep -v $0 | wc -l)
  if [ $nginx_thread_num -gt 2 ];then
      echo 'RUNNING; thread num is '$nginx_thread_num
  else
      echo 'STOPED'
  fi
}

function waf() {
  tail -f ./logs/modsec_audit.log
}

function logcut(){
  # TODO 如果旧日志存储的目录不存在就进行创建
  if [ ! -d ${nginxhome}/logs/old ]; then
     mkdir -p ${nginxhome}/logs/old
  fi

  # TODO 进入日志目录，移动旧日志，刷新进程_重新生成新日志路径（kill HUP）, 压缩旧日志后删除。
  cd  ${nginxhome}/logs && \
  mv modsec_audit.log modsec_audit.log.bak && \
  ps -ef | grep nginx-https | grep -v grep | awk '{print $2}' | xargs kill -HUP && \
  tar czf ${nginxhome}/old/modsec_audit_logs-$(date +%Y%m%d%H).tar.gz modsec_audit.log.bak && \
  rm -rf modsec_audit.log.bak

}

case "$1" in
"start")
  start
  ;;
"restart")
  restart
  ;;
"stop")
  stop
  ;;
"version")
  version
  ;;
"status")
  status
  ;;
"waf")
  waf
  ;;
*)
  echo "usage:(start|stop|restart|status|version|waf)"
  exit
  ;;
esac
