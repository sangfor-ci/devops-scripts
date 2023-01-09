#!/usr/bin/python
# -*- coding: UTF-8 -*-
from ftplib import FTP
import os
import sys
import time
import socket
import argparse


def logging(x):
    return FtpHandle().debug_print(x)


class FtpHandle:

    def __init__(self, host="127.0.0.1", port=21):
        """ 初始化 FTP 客户端
        参数:
                 host:ip地址
                 port:端口号
        """
        # print("__init__()---> host = %s ,port = %s" % (host, port))

        self.host = host
        self.port = port
        self.ftp = FTP()
        # 重新设置下编码方式
        self.ftp.encoding = 'gbk'
        self.log_file = open('ftp_task', "a")
        self.file_list = []

    def login(self, username, password):
        """ 初始化 FTP 客户端
            参数:
                  username: 用户名
                    password: 密码
            """
        try:
            timeout = 60
            socket.setdefaulttimeout(timeout)
            # 0主动模式 1 #被动模式
            self.ftp.set_pasv(1)
            # 打开调试级别2，显示详细信息
            self.ftp.set_debuglevel(2)

            self.debug_print('开始尝试连接到 %s : %s' % (self.host , self.port))
            self.ftp.connect(self.host, self.port)
            self.debug_print('成功连接到 %s' % self.host)

            self.debug_print('开始尝试登录到 %s' % self.host)
            self.ftp.login(username, password)
            self.debug_print('成功登录到 %s' % self.host)

            self.debug_print(self.ftp.welcome)
        except Exception as err:
            self.deal_error("FTP 连接或登录失败 ，错误描述为：%s" % err)
            pass

    def is_same_size(self, local_file, remote_file):
        """判断远程文件和本地文件大小是否一致
           参数:
             local_file: 本地文件
             remote_file: 远程文件
        """
        try:
            remote_file_size = self.ftp.size(remote_file)
        except Exception as err:
            # self.debug_print("is_same_size() 错误描述为：%s" % err)
            remote_file_size = -1

        try:
            local_file_size = os.path.getsize(local_file)
        except Exception as err:
            # self.debug_print("is_same_size() 错误描述为：%s" % err)
            local_file_size = -1

        self.debug_print('local_file_size:%d  , remote_file_size:%d' % (local_file_size, remote_file_size))
        if remote_file_size == local_file_size:
            return 1
        else:
            return 0

    def upload_file(self, local_file, remote_file):
        """从本地上传文件到ftp
           参数:
             local_path: 本地文件
             remote_path: 远程文件
        """
        if not os.path.isfile(local_file):
            self.debug_print('%s 不存在' % local_file)
            return

        if self.is_same_size(local_file, remote_file):
            self.debug_print('跳过相等的文件: %s' % local_file)
            return

        buf_size = 1024
        file_handler = open(local_file, 'rb')
        self.ftp.storbinary('STOR %s' % remote_file, file_handler, buf_size)
        file_handler.close()
        self.debug_print('上传: %s' % local_file + "成功!")

    def close(self):
        """ 退出ftp
        """
        self.debug_print("close()---> FTP退出")
        self.ftp.quit()
        self.log_file.close()

    def debug_print(self, s):
        """ 打印日志
        """
        self.write_log(s)

    def deal_error(self, e):
        """ 处理错误异常
            参数：
                e：异常
        """
        log_str = '发生错误: %s' % e
        self.write_log(log_str)
        sys.exit()

    def write_log(self, log_str):
        """ 记录日志
            参数：
                log_str：日志
        """
        time_now = time.localtime()
        date_now = time.strftime('%Y-%m-%d %H:%M:%S', time_now)
        format_log_str = "%s ---> %s \n " % (date_now, log_str)
        print(format_log_str)
        self.log_file.write(format_log_str)


def upload_file_ftp(cur_path, remote_path, ftp_host="10.7.217.164", ftp_port=21, ftp_user="ceshi", ftp_pass="Talent123", ):
    """
    本地文件上传到远程文件
    :param cur_path:
    :param remote_path:
    :param ftp_host:
    :param ftp_user:
    :param ftp_pass:
    :return:
    """
    ftp_handler = FtpHandle(host=ftp_host, port=ftp_port)
    # my_ftp.set_pasv(False)
    ftp_handler.login(ftp_user, ftp_pass)
    # 上传单个文件
    ftp_handler.upload_file(os.path.abspath(cur_path), remote_path)
    ftp_handler.close()


def get_options():
    parser = argparse.ArgumentParser(description=f"ftp文件传输; python3 {sys.argv[0]} -l ./test.txt -r /E:/DATAS/大数据产品技术中心/demo.txt")
    parser.add_argument('-s', '--ftp-host', type=str, help="FTP SERVER 的地址", default="10.7.217.164")
    parser.add_argument('-p', '--ftp-port', type=int, help="FTP服务端的端口, 默认21", default=21)
    parser.add_argument('-u', '--ftp-user', type=str, help="FTP连接用户", default="ceshi")
    parser.add_argument('-k', '--ftp-pass', type=str, help="FTP连接密码", default="Talent123")
    parser.add_argument('-l', '--local-path', type=str, help="FTP本地路径", default="./demo.txt")
    parser.add_argument('-r', '--remote-path', type=str, help="FTP远程存储路径", default="/E:/DATAS/大数据产品技术中心/demo_file")
    return parser.parse_args()


def main():
    opts = get_options()
    upload_file_ftp(
        ftp_host=opts.ftp_host,
        ftp_user=opts.ftp_user,
        ftp_pass=opts.ftp_pass,
        cur_path=opts.local_path,
        remote_path=opts.remote_path
    )


if __name__ == "__main__":
    main()
