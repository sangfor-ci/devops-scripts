# coding:utf-8
"""
TODO: github api
    github search api: https://docs.github.com/en/rest/reference/search
"""

import os
import sys
import random
# from uuid import uuid4
import json
import requests
from requests.api import request
requests.packages.urllib3.disable_warnings()
from datetime import datetime, timedelta
# from urllib.parse import urlparse, urlencode, urlunparse
# from bs4 import BeautifulSoup
from dateutil.parser import parse

# DJANGO_MODULE_PATH = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))))
# sys.path.append(DJANGO_MODULE_PATH)

import logging
# from lib.web_sdk.logger import Log
# logging = Log(log_flag="github_api")
import emoji


api_data = {
    "search_repo": "https://api.github.com/search/repositories",
    "search_topic": "https://api.github.com/search/topics",
    "show_repo": "https://api.github.com/repos/{owner}/{repo}",
    "show_commits": "https://api.github.com/repos/{owner}/{repo}/commits",
    "show_files": "https://api.github.com/repos/{owner}/{repo}/contents/",
    "get_issues": "https://api.github.com/issues",
    "get_repo_issues": "https://api.github.com/repos/{owner}/{repo}/issues",
    "add_issue": "https://api.github.com/repos/{owner}/{repo}/issues",
    "add_comment": "https://api.github.com/repos/{owner}/{repo}/issues/{number}/comments",
    "show_emojis": "https://api.github.com/emojis"
}


def parse_datetime(datestr):
    # return datetime.strptime(datestr, '%Y-%m-%dT%H:%M:%SZ')
    # return parse(datestr).replace(tzinfo=None)
    return parse(datestr)


class GithubApi:

    def __init__(self, proxies=None):
        # self.proxies = proxies if proxies else {'http': 'http://localhost:1181', 'https': 'http://localhost:1181'}
        self.proxies = proxies
        self.headers = {
            "User-Agent": self.random_ua(),
            "Authorization": "token {token}".format(token=self.get_random_token())
        }

    @staticmethod
    def random_ua():
        user_agents = [
            'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/14.0.835.163 '
            'Safari/535.1',
            'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20100101 Firefox/6.0',
            'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/534.50 (KHTML, like Gecko) Version/5.1 Safari/534.50',
            'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0; .NET CLR 2.0.50727; '
            'SLCC2; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.3; .NET4.0C; Tablet '
            'PC 2.0; .NET4.0E)',
            'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; GTB7.0)',
            'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.41 Safari/535.1 '
            'QQBrowser/6.9.11079.201',
            'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)',
            'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; WOW64; Trident/5.0; SLCC2; .NET CLR 2.0.50727; '
            '.NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.3; .NET4.0C; .NET4.0E) '
            'QQBrowser/6.9.11079.201',
        ]

        return random.choice(user_agents)

    @staticmethod
    def get_random_token():
        from data.btm.gitrepo.repo_info import repo_github_api_des_tokens
        from lib.ops_sdk.des import des_descrypt
        tokens_des_data = des_descrypt(repo_github_api_des_tokens)
        data = json.loads(tokens_des_data)
        return random.choice([v for _, v in data.items()])

    def request(self, url, method="get", **kwargs):
        response = request(
            method=method,
            url=url,
            headers=self.headers,
            proxies=self.proxies,
            allow_redirects=True,
            verify=False,
            timeout=20,
            **kwargs)
        try:
            response_data = response.json()
        except :
            response_data = response.content
        if response.status_code > 340:
            raise AttributeError(response)
        if type(response_data) == dict:
            if "errors" in response_data.keys():
                raise AttributeError(response)
        return response_data

    @staticmethod
    def parse_repo_info(data):

        return dict(
            node_id=data["node_id"],
            repo_id=data["id"],
            full_name=data["full_name"],
            html_url=data["html_url"],
            stars=data["stargazers_count"], # 后面补充加上了这个；
            # 2022/4/22 修改
            description=emoji.demojize(data["description"].__str__()),
            created_at=parse_datetime(data["created_at"]),
            updated_at=parse_datetime(data["updated_at"]),
            pushed_at=parse_datetime(data["pushed_at"]),
            homepage=data["homepage"].__str__() if "homepage" in data.keys() else " ",
            # forks_count = data["forks_count"],
            archived=data["archived"],
            topics=str(data["topics"]),
            watchers=data["watchers"],
            forks=data["forks"],
            size=data["size"],
            open_issues=data["open_issues"],
            score=data["score"],
        )

    @staticmethod
    def parse_repo_commit(data):
        return dict(
            sha=data["sha"],
            url=data["url"],
            html_url=data["html_url"],
            message=data["commit"]["message"].__str__(),
            commit_date=parse_datetime(data["commit"]["committer"]["date"]),
            parents_sha=",".join([x["sha"] for x in data["parents"]]),
        )

    def search_repo(self, keyword, cond=None, per_page=50, sort=None, page_num=1, stars_limit=300, ):
        """

        :param keyword:
        :param per_page:
        :param sort:
        :param page_num:
        :param stars_limit:
        :return:
        """
        # https://docs.github.com/en/rest/reference/search#search-repositories
        # time_limit = (datetime.now() - timedelta(100)).date().__str__()
        # push_time_limit = (datetime.now() - timedelta(200)).date().__str__()
        if not cond:
            cond = f" stars:>={stars_limit}"
        params = {
            "q": keyword + cond, # updated:>2021-12-20
            "per_page": per_page,
            "page": page_num
        }
        if sort:
            params = dict(params, sort=sort, order="desc")
        data = self.request(method="get", url=api_data["search_repo"], params=params)
        if data:
            return data
        return {}

    def get_search_all(self, keyword, per_page=50, sort=None, page_num=1, stars_limit=300,):
        data = self.search_repo(keyword, per_page=per_page, sort=sort, page_num=page_num, stars_limit=stars_limit, )
        # print(data)
        results = []
        if data and "items" in data.keys():
            # TODO 预备增加 keyword 到表单种。
            results.extend([self.parse_repo_info(x) for x in data["items"]])
            if not data["incomplete_results"]:
                total_counts = data["total_count"]
                page_count = int(total_counts / per_page) + 1
                for pager in range(page_count - 1):
                    # TODO 这里是不是超过10页就不下载了。 害怕接口访问过多被拦截了，
                    if pager > 10:
                        break
                    data = self.search_repo(keyword, per_page=per_page, sort=sort, page_num=pager + 2, stars_limit=stars_limit, )
                    results.extend([self.parse_repo_info(x) for x in data["items"]])
        return results

    def add_comment(self, owner="2b45", repo="tsc_dev", issue_num=1, comment="test"):
        url = f"https://api.github.com/repos/{owner}/{repo}/issues/{issue_num}/comments"
        data = self.request(method="post", url=url, json={"body": comment},)
        if data:
            logging.info(f"提交 [{owner}/{repo}] issue {issue_num}Comment OK...")
            return data
        return None

    def create_issue(self, owner="apache", repo="logging-log4j2", title="test", content="rt"):
        url = api_data["add_issue"].format(owner=owner, repo=repo)
        post_params = {
            "title": title,
            "body": content
        }
        data = self.request(method="post", url=url, json=post_params)
        if data:
            logging.info(f"提交  [{owner}/{repo}] issue OK...")
            return url
        return None

    def get_repo_commits(self, repo_full_name: str):
        owner, repo = repo_full_name.split("/")
        data = self.request(method="get", url=f"https://api.github.com/repos/{owner}/{repo}/commits",)
        if len(data) > 0:
            result = [dict(self.parse_repo_commit(x),
                           repo_full_name=repo_full_name,
                           repo_url=f"https://github.com/{owner}/{repo}.git") for x in data]
            return result
        return None


def demo1():
    # test()
    # GithubApi().search_repo(keyword="Java")
    import time
    for i in range(20):
        GithubApi().add_comment(comment="1111" * i)
        time.sleep(2)


if __name__ == '__main__':
    # datas = GithubApi().get_search_all(keyword="CVE")
    # for x in datas:
    #     print(x["full_name"])

    # for i in range(5):
    #     GithubApi().post_issue(owner="way2king", repo="ts_dev")

    datas = GithubApi().get_repo_commits(repo_full_name="xx-scan/xx-scan")
    for x in datas:
        print(x)
