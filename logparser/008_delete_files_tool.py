# coding:utf-8
import os
import argparse
# import shutil


def get_options():
    parser = argparse.ArgumentParser(description=f"删除目录下指定后缀的文件")
    parser.add_argument('-p', '--pattern', type=str, help="需要上传的制品包的组,也是远程仓库的根路径", default=".zip")
    parser.add_argument('-d', '--dirname', type=str, help="需要上传的相对目录（例如 ./demo）", default=".")
    return parser.parse_args()


def get_files(dir_name="", results=[]):
    for f in os.listdir(dir_name):
        __filepath = os.path.join(dir_name, f)
        if os.path.isfile(__filepath):
            results.append(__filepath)
        else:
            get_files(dir_name=__filepath, results=results)
    return results


if __name__ == '__main__':
    opts = get_options()
    files = get_files(dir_name=opts.dirname)
    pattern = opts.pattern
    count = 0
    for file in files:
        if not file.endswith(".zip"):
            os.system(f"rm -rf \'{file}\'")
            count += 1
    print(f"删除 {opts.dirname} 目录下非[ {opts.pattern} ]模式的文件结束。共删除[ {count} ]条")