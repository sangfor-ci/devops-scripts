#!/bin/bash
# ref: https://cigdemkadakoglu.medium.com/file-upload-download-with-a-nexus-repository-rest-api-f760441bc01c
# ref2: https://stackoverflow.com/questions/4029532/upload-artifacts-to-nexus-without-maven

# TODO upload a file
curl -X 'POST' \
  'http://121.4.28.196:8081/service/rest/v1/components?repository=filestore2' \
  -H 'accept: application/json' \
  -H 'Content-Type: multipart/form-data' \
  -H 'Authorization: Basic YWRtaW46c3RyaW5nMTIzLg=='  \
  -F 'raw.directory=backup' \
  -F 'raw.asset1=@docker-compose.yaml'  \
  -F 'raw.asset1.filename=docker-compose.yaml' -v
l;type=application/v
# TODO 浏览器视角，可以直接查看的。
# http://121.4.28.196:8081/repository/filestore2/backup/docker-compose.yaml
# TODO upload a file with application content-type desc

curl -X 'POST' \
  'http://121.4.28.196:8081/service/rest/v1/components?repository=filestore2' \
  -H 'accept: application/json' \
  -H 'Content-Type: multipart/form-data' \
  -H 'Authorization: Basic YWRtaW46c3RyaW5nMTIzLg=='  \
  -F 'raw.directory=backup' \
  -F 'raw.asset1=@docker-compose.yaml;type=application/octet-stream'  \
  -F 'raw.asset1.filename=docker-compose.yaml' -v


## TODO 这个可能更简单。。。。
version=1.2.3
artifact="myartifact"
repoId=yourrepository
groupId=org.myorg
REPO_URL=http://localhost:8081/nexus

curl -u nexususername:nexuspassword \
  --upload-file filename.tgz \
  $REPO_URL/content/repositories/$repoId/$groupId/$artifact/$version/$artifact-$version.tgz


# TODO 可以使用 mvn 工具，也可以使用 nexus-cli, 也可以使用 curl 等
mvn deploy:deploy-file \
    -Durl=$REPO_URL \
    -DrepositoryId=$REPO_ID \
    -DgroupId=org.myorg \
    -DartifactId=myproj \
    -Dversion=1.2.3  \
    -Dpackaging=zip \
    -Dfile=myproj.zip