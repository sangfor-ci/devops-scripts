# XC 组件适配和开发

## 免费-Tencent羊毛
- https://github.com/coding/coding-docs

```bash

docker run -itd \
  --restart=always \
  --name=topsa-re \
  -p 57731:22 \
  --env LANG=en_US.UTF-8 \
  --env LANGUAGE=en_US:en  \
  --env LC_ALL=en_US.UTF-8 \
  --user=root --hostname=topsa-re \
  --cpus=2 --cpu-shares=2000 \
  -m 2048m --memory-reservation=1024m \
  -v /etc/localtime:/etc/localtime:ro \
  -v /srv/docker/topsa-re/:/usr/src/app \
  ccr.ccs.tencentyun.com/topsec/ssh-node:oe2203-jdk11

```