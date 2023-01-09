import os
import json
import asyncio
import maxminddb

TSC_IP_DIR = "E:\\tsc-Ipv4Ipv6-S-v2022.11.21.002\\tsc-Ipv4Ipv6-S-v2022.11.21.002"
DESC_PATH = os.path.join(TSC_IP_DIR, "tsc-Ipv4Ipv6-S-v2022.11.21.002.desc") # TODO 老路径，默认的
MMDB_PATH = os.path.join(TSC_IP_DIR, "tsc-Ipv4Ipv6-S-v2022.11.21.002.mmdb")
# NEW_DESC_PATH = os.path.join(TSC_IP_DIR, "tsc-Ipv4Ipv6-S-v2022.11.21.002.bd.desc")
NEW_DESC_PATH = os.path.join(TSC_IP_DIR, "tsc-Ipv4Ipv6-S-v2022.11.21.002.bd2.desc") #TODO 新路径，我们转化的


async def open_mmdb(ip='113.57.106.161', mmdb_path=MMDB_PATH):
    with maxminddb.open_database(mmdb_path) as reader:
        try:
            return reader.get(ip)
        finally:
            reader.close()


def parser_owner(desc_path=DESC_PATH):
    pass

def combine_location_id(location_data):
    __keys = ["state", "country", "province", "city", "district"]
    __values = [8, 8, 8, 16, 8]
    geo_kvs = {__keys[i]: __values[i] for i in range(len(__keys))}
    __location_id = ""
    # print(location_data)
    for key, bs_len in geo_kvs.items():
        if key in location_data.keys():
            __org_id = str(bin(location_data[key]["id"])).split('0b')[1]
            __tmp_id = "0" * (bs_len - len(__org_id)) + __org_id
            __location_id += __tmp_id
        else:
            __location_id += "0" * bs_len
    # print(__location_id)
    return int(__location_id + 16 * "0", 2)


def parser_desc(desc_path=DESC_PATH):
    with open(desc_path, "r", encoding="utf-8") as f:
        all_desc_data = f.read().split("\n")
        geo_str, owner_str = all_desc_data[0], all_desc_data[1]
        geo_dict = json.loads(geo_str)
        location_dataset = []  # TODO 记录 location 所有的信息
        geo_dict_data = geo_dict["data"]
        for i in range(len(geo_dict_data)):
            x = geo_dict_data[i]
            __state = {"id": x["id"], "cName": x["cName"], "eName": x["eName"]}
            location_dataset.append(dict(state=__state, ))
            country_list = x["countryList"]
            for j in range(len(country_list)):
                y = country_list[j]
                __country = {"id": y["id"], "cName": y["cName"], "eName": y["eName"]}
                location_dataset.append(dict(state=__state, country=__country))
                province_list = y["provinceList"]
                for k in range(len(province_list)):
                    z = province_list[k]
                    __province = {"id": z["id"], "cName": z["cName"], "eName": z["eName"]}
                    location_dataset.append(dict(state=__state, country=__country, province=__province))
                    city_list = z["cityList"]
                    for l in range(len(city_list)):
                        a = city_list[l]
                        __city = {"id": a["id"], "cName": a["cName"], "eName": a["eName"]}
                        location_dataset.append(
                            dict(state=__state, country=__country, province=__province, city=__city))
                        for b in a["districtList"]:
                            # print(b["id"])
                            __district = {"id": b["id"], "cName": b["cName"], "eName": b["eName"]}
                            location_dataset.append(
                                dict(state=__state, country=__country, province=__province, city=__city,
                                     district=__district))
        ids = {}
        for x in location_dataset:
            __id = combine_location_id(x)
            ids.setdefault(__id, x)
        f.close()

        owner_ids = {x["id"]: x for x in json.loads(owner_str)["data"]}
        return ids, owner_ids


def push_desc_local(desc_path=NEW_DESC_PATH):
    with open(desc_path, "w+", encoding="utf-8") as f:
        ids, owner_ids = parser_desc(desc_path=DESC_PATH)
        f.write(json.dumps(ids))
        f.write("\n")
        f.write(json.dumps(owner_ids))
        f.close()


def get_desc_local(desc_path=NEW_DESC_PATH):
    with open(desc_path, "r", encoding="utf-8") as f:
        ids, owner_ids = f.read().split("\n")
        f.close()
    ids_dicts = json.loads(ids)
    owner_ids_dicts = json.loads(owner_ids)
    results1 = sorted(ids_dicts.items(), key=lambda x: int(x[0]), reverse=False)
    results2 = sorted(owner_ids_dicts.items(), key=lambda x: int(x[0]), reverse=False)
    return {x[0]: x[1] for x in results1}, {x[0]: x[1] for x in results2}


if os.path.exists(NEW_DESC_PATH):
    LOC_IDS_LOCAL, OWNER_IDS_LOCAL = get_desc_local()
    DESC_LOCATION_ID_LIST = [int(x) for x in LOC_IDS_LOCAL.keys()]
    DESC_OWNER_ID_LIST = [int(x) for x in OWNER_IDS_LOCAL.keys()]
else:
    push_desc_local(desc_path=NEW_DESC_PATH)


def mid_find_data(value=None, data_list=None):
    if data_list is None:
        data_list = DESC_LOCATION_ID_LIST
    key = binay_search(value, data_list, )
    return LOC_IDS_LOCAL[str(data_list[key])]


def binay_search(num, array, start=None, end=None):
    if start is None:
        start = 0
    if end is None:
        end = len(array) - 1
    mid = (end - start) // 2 + start
    if start > end:
        # TODO 没找到也输出就近的这个的前面一个;
        return mid
    elif array[mid] > num:
        return binay_search(num, array, start, mid - 1)
    elif array[mid] < num:
        return binay_search(num, array, mid + 1, end)
    elif array[mid] == num:
        return mid


async def get_geoip2(ip='113.57.106.161'):
    r = await open_mmdb(ip)
    location_id = r["IPLocation"]["locationId"]
    owner_id = r["IPLocation"]["owner"]
    print(owner_id)
    # print(OWNER_IDS_LOCAL.keys())
    # return
    onwer_info = OWNER_IDS_LOCAL[str(owner_id)]

    fuhua = mid_find_data(value=int(location_id))
    output = dict(r["IPLocation"], **fuhua, ip=ip, onwer_info=onwer_info)
    print(json.dumps(output, indent=4, ensure_ascii=False))
    return output


if __name__ == '__main__':
    # mid_find_data()
    # print(binay_search(8, [1, 3, 5, 6, 7, 10, 15, 17, 99, 222]))
    # data = asyncio.run(get_geoip2(ip='192.210.136.18'))

    # TODO 将原来的kv导出到现在的 key-value
    # push_desc_local(desc_path=NEW_DESC_PATH)

    data = asyncio.run(get_geoip2(ip='192.210.136.18'))
