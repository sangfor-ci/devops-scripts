import os
import json
import asyncio
import maxminddb


TSC_IP_DIR = "D:\\data\\TopSec-Ipv4Ipv6-S-v2022.10.19.001\\TopSec-Ipv4Ipv6-S-v2022.10.19.001"
DESC_PATH = os.path.join(TSC_IP_DIR, "TopSec-Ipv4Ipv6-S-v2022.10.19.001.desc")
MMDB_PATH = os.path.join(TSC_IP_DIR, "TopSec-Ipv4Ipv6-S-v2022.10.19.001.mmdb")


async def open_mmdb(ip='113.57.106.161', mmdb_path=MMDB_PATH):
    with maxminddb.open_database(mmdb_path) as reader:
        try:
            return reader.get(ip)
        finally:
            reader.close()


async def get_geoip(ip='113.57.106.161'):
    r = await open_mmdb(ip)
    location_id = r["IPLocation"]["locationId"]
    owner_id = r["IPLocation"]["owner"]
    fuhua = await get_tsc_desc_data(*change_location_id(location_id=location_id, owner_id=owner_id))
    output = dict(r["IPLocation"], **fuhua, ip=ip)
    # print(output)
    return output


async def get_all_desc(desc_path=DESC_PATH):
    with open(desc_path, "r", encoding="utf-8") as f:
        all_desc_data = f.read().split("\n")
        geo_str, owner_str = all_desc_data[0], all_desc_data[1]
        geo_dcit = json.loads(geo_str)
        owner_dict = json.loads(owner_str)
        f.close()
    return geo_dcit, owner_dict


def change_location_id(location_id: int, owner_id: int):
    location_id_str = str(bin(location_id)).split('0b')[1]
    location_id_unit64 = '0' * (64 - len(location_id_str)) + location_id_str
    ids = [int(location_id_unit64[8*i:8*(i+1)], 2) for i in range(3)]  # TODO 州、国家、省
    ids.append(int(location_id_unit64[24:40], 2))  # TODO 城市位
    ids.append(int(location_id_unit64[40:48], 2))  # TODO 区县位
    ids.append(owner_id)  # TODO 运营商
    return ids


async def get_tsc_desc_data(state_id=None, country_id=None, province_id=None, city_id=None, district_id=None, owner_id=None):
    geo_dict, owner_dict = await get_all_desc()
    params = {}
    if state_id:
        state_dict = [x for x in geo_dict["data"] if x["id"] == state_id][0]
        params.setdefault("state", state_dict["cName"])
        if country_id and "countryList" in state_dict.keys():
            country_dict = [x for x in state_dict["countryList"] if x["id"] == country_id][0]
            params.setdefault("country", country_dict["cName"])
            if province_id and "provinceList" in country_dict.keys():
                province_dict = [x for x in country_dict["provinceList"] if x["id"] == province_id][0]
                params.setdefault("province", province_dict["cName"])
                if city_id:
                    city_dict = [x for x in province_dict["cityList"] if x["id"] == city_id][0]
                    params.setdefault("city", city_dict["cName"])
                    if district_id and "districtList" in city_dict.keys():
                        city_dict = [x for x in city_dict["districtList"] if x["id"] == district_id][0]
                        params.setdefault("district", city_dict["cName"])
    if owner_id:
        owner_dict = [x for x in owner_dict["data"] if x["id"] == owner_id][0]
        params.setdefault("owner_info", owner_dict["cName"])
    return params


def aysnc_task(ip):
    return asyncio.run(get_geoip(ip))


def test():
    from datetime import datetime
    import random
    ip_list = []
    for i in range(5):
        ip = ".".join([str(random.randrange(1, 240, 22)) for i in range(4)])
        ip_list.append(ip)
    start_time = datetime.now()

    import asyncio
    loop = asyncio.get_event_loop()
    task = [asyncio.ensure_future(get_geoip(ip)) for ip in ip_list]
    loop.run_until_complete(asyncio.wait(task))

    end_time = datetime.now()
    print(f"Timer {end_time - start_time}")


if __name__ == '__main__':
    """
    重要说明： desc给的只是研究院的id对应关系，产品务必先保存对应的id到缓存中，不可像这个demo一样，每次都从desc读取、
    """

    # result = aysnc_task(ip="185.7.214.104")
    result = aysnc_task(ip="2402:4e00::")
    # import json
    show = json.dumps(result, indent=4, ensure_ascii=False)
    print(show)
