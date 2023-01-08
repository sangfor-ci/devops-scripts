# coding=utf-8
from __future__ import print_function
import os
import sys
import subprocess
from pathlib import Path
import argparse
# from concurrent.futures import ThreadPoolExecutor, ProcessPoolExecutor
import threading
from queue import Queue


def get_options():
    eg = f"使用示例: python {sys.argv[0]} -d ./demo -g tech "
    parser = argparse.ArgumentParser(description=f"Nexus 制品上传工具v1 by xx-zhang \n\t\t{eg}")
    parser.add_argument('-i', '--curl-bin', type=str, help="CURL执行bin路径 intercept", default="curl")
    parser.add_argument('-l', '--nexus-url', type=str, help="Nexus 推送URL",
                        default="https://10.11.6.26/nexus/service/rest/v1/components?repository=filestore-v2")
    parser.add_argument('-g', '--group', type=str, help="需要上传的制品包的组,也是远程仓库的根路径", default="common")
    parser.add_argument('-u', '--auth', type=str, help="Nexus认证信息,例如admin:password", default="admin:string123.")

    parser.add_argument('-d', '--dir', type=str, help="需要上传的相对目录（例如 ./demo）", default="")
    parser.add_argument('-f', '--file', type=str, help="需要上传的文件，例如 ./test/demo.txt", default="")
    return parser.parse_args()


class ThreadWorker(threading.Thread):
    def __init__(self, queue, func, kwargs={}):
        threading.Thread.__init__(self)
        self._queue = queue
        self.func = func
        self.kwargs = kwargs

    def run(self):
        while not self._queue.empty():
            item = self._queue.get()
            try:
                self.func(item, **self.kwargs)
            except Exception as e:
                print(e)


def muti_run(func, kwargs={},  iters: list=range(10), thread_count=10):
    """
    多线程任务脚本。
    例如 print(111,22,333);
    :param func: 单个线程需要执行的方法
    :param kwargs: 线程中函数传递的参数内容（静态的参数内容）;
    :param iters: 动态传递的迭代内容；
    :param thread_count: 线程数
    :return:
    """
    queue = Queue()
    for x in iters:
        queue.put(x)
    threads = [ThreadWorker(queue, func=func, kwargs=kwargs) for i in range(thread_count)]
    for t in threads:
        t.start()
    for t in threads:
        t.join()
    return None


class NexusUploader(object):
    """docstring for iOSBuilder"""

    def __init__(self, opts):
        """

        :rtype: object
        """
        self.options = opts
        self.nexus_url = opts.nexus_url
        self.group = opts.group
        self.dir = opts.dir
        self.file = opts.file
        self.curl_bin = opts.curl_bin
        self.nexus_auth = opts.auth

    def _run_shell(self, cmd_shell):
        process = subprocess.Popen(cmd_shell, shell=True)
        process.wait()
        return_code = process.returncode
        assert return_code == 0

    def _get_dir_file_list(self, dirname=".", results=[]):
        for filename in os.listdir(dirname):
            _file = os.path.join(dirname, filename)
            if os.path.isfile(_file):
                results.append(_file)
            else:
                self._get_dir_file_list(dirname=_file, results=results)
        return results

    def _upload_file(self, filepath=None, artifact="temp"):
        if not filepath:
            filepath = self.file

        filename = os.path.basename(filepath)
        cmd_shell = f"{self.curl_bin} --progress-bar -k -X POST "
        cmd_shell += f"'{self.nexus_url}' "
        cmd_shell += "-H 'accept: application/json' "
        cmd_shell += "-H 'Content-Type: multipart/form-data' "
        cmd_shell += f"-u {self.nexus_auth} "
        cmd_shell += f"-F 'raw.directory={self.group}/{artifact}' "
        cmd_shell += "-F 'raw.asset1=@" + filepath + ";type=application/octet-stream' "
        cmd_shell += "-F 'raw.asset1.filename=" + filename + "' "
        cmd_shell += "| tee /dev/null"
        print("\n")
        print(f"[*] uploading {filepath} {'*'*15 } \n#shell-> {cmd_shell}")
        print("\n")
        self._run_shell(cmd_shell)

    def _upload_dir(self, dirname=None, ):
        """
        尽量上传的是相对路径。 ./dir1/dir2/dir3/file4
        :param dirname:
        :return:
        """
        if not dirname:
            dirname = self.dir
        split_slug = "\\" if sys.platform.lower() == "win32" else "/"
        # TODO 这里可以使用多线程;
        file_sets = self._get_dir_file_list(dirname=dirname)

        def __local_func(x):
            filename_splits = x.split(split_slug)
            artifact = "/".join(filename_splits[1:-1]) if len(filename_splits) > 2 else ""
            self._upload_file(filepath=x, artifact=artifact)
            return None

        muti_run(func=__local_func, iters=file_sets)


if __name__ == '__main__':
    options = get_options()
    builder = NexusUploader(opts=options)

    if builder.file:
        builder._upload_file()

    if builder.dir:
        builder._upload_dir()



