#!/usr/bin/python3
import subprocess
import os
import shlex
import os
import configparser
BASE_DIR = os.path.abspath(os.path.dirname(__file__))
DEFAULT_CFG = os.path.join(BASE_DIR, 'cpu_mem_disk.ini')


class ConfigManger:

    def __init__(self, cfg_path=DEFAULT_CFG):
        self.cfg_path = cfg_path
        config = configparser.ConfigParser()
        config.read(cfg_path, encoding="utf-8")
        self.cfg = config

    def get_configs(self):
        __cfg = self.cfg
        return [dict({k: v for k, v in __cfg.items(x)}, name=x) for x in __cfg.sections()]


def get_cfgs():
    # print(DEFAULT_CFG)
    return ConfigManger().get_configs()


default_cmd_lines = {
    "ping4": dict(shell="ping {host} {opts}", kwargs={"host": "127.0.0.1", "opts": ""}, desc="common ping test", name="测试ping"),

}


def intercepter_test(line):
    print("[cmd] " + line)


def pipe_shell(shell_cmd, intercepter_func=intercepter_test):
    cmd = shlex.split(shell_cmd)
    sub_proc = subprocess.Popen(cmd, shell=False, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    try:
        # TODO 之前的经验，防止僵尸进程
        os.waitpid(sub_proc.pid, os.W_OK)
    except:
        pass
    while sub_proc.poll() is None:
        line = sub_proc.stdout.readline()
        line = line.strip()
        if line:
            try:
                intercepter_func(line.decode('gb2312'))
            except:
                intercepter_func(line.decode('utf-8'))
    if sub_proc.returncode == 0:
        return True
    else:
        return False


def exec_cmdb_task(params):
    """
    eg: 使用说明： 使用外部进行脚本形式的调用，不用直接使用主进程。
    :param params:
    :return:
    """
    cmd = shlex.split(params["shell_cmd"])
    return pipe_shell(shell_cmd=cmd, intercepter_func=println)


def println(x):
    print(x)
    return x


if __name__ == '__main__':
    pass


