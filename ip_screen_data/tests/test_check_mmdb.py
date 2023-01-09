# coding:utf-8
import ipaddress
import random
import maxminddb


MMDB_PATH = "d://home//local_screen2021.mmdb"


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


def test_read(mmdb_path=MMDB_PATH):
    screen__dict = ip_sceen_id_data()
    id_dict = {v: k for k, v in screen__dict.items()}

    m = maxminddb.open_database(mmdb_path)

    TEST_MAX_NUM = 100000
    all_index = 0
    not_in_num = 0
    while True:
        if all_index > TEST_MAX_NUM:
            break
        fake_ip = ".".join([str(random.randint(0, 255)) for i in range(4)])
        if ipaddress.IPv4Address(fake_ip).is_private:
            continue
        r = m.get(fake_ip)
        if r:
            print(f"{fake_ip}\t\t\t{id_dict[r['screen']]}")
        else:
            not_in_num += 1
            print(f"{fake_ip}\t\t\t[未收录]")
        all_index += 1

    print(f"{not_in_num}/{all_index} 不在其中！")


def dump_dsec():
    screen__dict = ip_sceen_id_data()
    id_dict = {v: k for k, v in screen__dict.items()}

    import json
    with open("d://test.json", "w", encoding="utf-8") as f:
        f.write(json.dumps({"data": id_dict}, ensure_ascii=False))
        f.close()
    print("------------------------")


if __name__ == '__main__':
    test_read()

