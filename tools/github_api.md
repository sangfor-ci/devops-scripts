


# github create repo 
```bash

curl \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer <TOKEN>"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/orgs/<org_name>/repos \
  -d '{"name":"helloworld-repo","description":"This is a repository for ci-release by xx","homepage":"https://github.com","private":false,"has_issues":true,"has_projects":true,"has_wiki":true}'

```


# 上传文件 
```bash

filepath=./test.sh && \
upload_dir=$(date +%Y%m%d_%H%m%S) && \
base64_file="$(cat ${filepath} | base64)" && \
user_repo=ci-repo/helloworld-repo && \
curl  \
  -X PUT \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer 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"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/${user_repo}/contents/${upload_dir}/"$(basename "filepath") \
  -d @- << CURL_DATA
'{"message":"upload file","committer":{"name":'"${user_repo%/*}"',"email":"ci@example.com"},"content":'"${base64_file}"'}'
CURL_DATA
         
filepath=./t10.tar.gz && \
upload_dir=$(date +%Y%m%d_%H%m%S) && \
base64_file="$(cat ${filepath} | base64)" && \
user_repo=ci-repo/helloworld-repo && \
echo f121321 << CURL_DATA
'{"message":"upload file","committer":{"name":'"${user_repo%/*}"',"email":"ci@example.com"},"content":'${base64_file}'}'
CURL_DATA
#python -c "import sys, json; print json.load()"


filepath=./test.sh && \
upload_dir=$(date +%Y%m%d_%H%m%S) && \
base64_file="$(cat ${filepath} | base64)" && \
user_repo=ci-repo/helloworld-repo && \
curl  \
  -X PUT \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer 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"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/${user_repo}/contents/${upload_dir}/"$(basename "filepath") \
  -d @- << CURL_DATA
{"message":"upload file","committer":{"name":"${user_repo%/*}","email":"ci@example.com"},"content":"${base64_file}"}
CURL_DATA
```