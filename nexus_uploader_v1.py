# coding=utf-8
from __future__ import print_function
import os
import sys
import subprocess
import argparse
import asyncio


def get_options():
    eg = f"使用示例: python {sys.argv[0]} -d ./demo -g tech "
    parser = argparse.ArgumentParser(description=f"Nexus 制品上传工具v1 by xx-zhang \n\t\t{eg}")
    parser.add_argument('-i', '--curl-bin', type=str, help="CURL执行bin路径 intercept", default="curl")
    parser.add_argument('-u', '--nexus-url', type=str, help="Nexus 推送URL",
                        default="https://10.11.6.26/nexus/service/rest/v1/components?repository=filestore-v2")
    parser.add_argument('-g', '--group', type=str, help="需要上传的制品包的组,也是远程仓库的根路径", default="common")

    parser.add_argument('-d', '--dir', type=str, help="需要上传的相对目录（例如 ./demo）", default="")
    parser.add_argument('-f', '--file', type=str, help="需要上传的文件，例如 ./test/demo.txt", default="")
    return parser.parse_args()


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
        self.nexus_auth = "admin:string123."

    async def _run_shell(self, cmd_shell):
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

    async def _upload_file(self, filepath=None, artifact="temp"):
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
        await self._run_shell(cmd_shell)

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

        async def __local_func(x):
            filename_splits = x.split(split_slug)
            artifact = "/".join(filename_splits[1:-1]) if len(filename_splits) > 2 else ""
            await self._upload_file(filepath=x, artifact=artifact)
            return None

        loop = asyncio.get_event_loop()
        task = [asyncio.ensure_future(__local_func(filepath)) for filepath in file_sets]
        loop.run_until_complete(asyncio.wait(task))


if __name__ == '__main__':
    options = get_options()
    builder = NexusUploader(opts=options)

    if builder.file:
        __func = builder._upload_file()
        asyncio.run(__func)

    if builder.dir:
        builder._upload_dir()
