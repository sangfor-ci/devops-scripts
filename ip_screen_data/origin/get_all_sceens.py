# coding:utf-8
import socket
import struct


# ch3 = lambda x:sum([256**j*int(i) for j,i in enumerate(x.split('.')[::-1])
def parse_int_ip(int_ip):
    return socket.inet_ntoa(struct.pack('I', socket.htonl(int_ip)))


def check_data():
    with open("d://IP_scene_all_cn.txt", "r", encoding="utf-8") as f:
        t = f.read().split("\n")
        f.close()

    res = []
    for x in t:
        try:
            res.append(x.split("\t")[2])
        except:
            print(x)
    tmp = {}
    for y in res:
        if y in tmp.keys():
            tmp[y] = tmp[y] + 1
        else:
            tmp[y] = 1
    a2 = sorted(tmp.items(),key=lambda x:x[1], reverse=True)
    for x in a2:
        print(x)


if __name__ == '__main__':
    print(parse_int_ip(16666666))



