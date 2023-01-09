# coding:utf-8
import os
import sys
import re

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.append(PROJECT_DIR)


from netaddr import IPSet
from thirty.mmdb.mmdb_writer import MMDBWriter
# from thirty.mmdb.mmdb_reader import get_geoip

import socket
import struct


# ch3 = lambda x:sum([256**j*int(i) for j,i in enumerate(x.split('.')[::-1])
def parse_int_ip(int_ip):
    return socket.inet_ntoa(struct.pack('I', socket.htonl(int_ip)))

ORIGIN_TXT_PATH = os.path.join(PROJECT_DIR, "origin", "IP_scene_all_cn.txt")
MMDB_PATH = os.path.join(PROJECT_DIR, "local_screen2021.mmdb")


def ip_sceen_id_data():
    return {
        "数据中心": 1,
        "企业专线": 2,
        "已路由-未使用": 3,
        "专用出口": 4,
        "基础设施": 5,
        "家庭宽带": 6,
        "学校单位": 7,
        "已分配-未路由": 8,
        "CDN": 9,
        "移动网络": 10,
        "组织机构": 11,
        "交换中心": 12,
        "WLAN热点": 13,
        "卫星通信": 14,
        "Anycast": 15,
    }


def get_ipset_range(min_ip, max_ip):
    ipset = []
    for x in range(int(min_ip), int(max_ip)+1):
        ipset.append(parse_int_ip(x))
    return ipset


def test_write(mmdb_path=MMDB_PATH):
    writer = MMDBWriter()
    screen_dict = ip_sceen_id_data()
    with open(ORIGIN_TXT_PATH, "r", encoding="utf-8") as f:
        lines = f.read().split("\n")
        f.close()
    for i in range(len(lines)):
        x = lines[i+1]
        try:
            screen_id = 0
            __data = x.split("\t")
            min_ip, max_ip = __data[0].strip("\""), __data[1].strip("\"")
            screen_data = __data[2].strip("\"")
            try:
                screen_id = screen_dict[screen_data]
            except:
                print("Not IN data")
            writer.insert_network(IPSet(get_ipset_range(min_ip, max_ip)), {'screen': screen_id})
            print(f"loading {i}")
        except Exception as e:
            print(e)
            print(x)
            break

    writer.to_db_file(mmdb_path)


def test_read(mmdb_path=MMDB_PATH):
    import maxminddb
    m = maxminddb.open_database(mmdb_path)
    r = m.get(parse_int_ip(17769720))
    print(r)


if __name__ == '__main__':
    # test_write()
    test_write()




