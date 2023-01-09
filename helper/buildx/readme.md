# 交叉编译手册

## 方案，使用 docker-buildx 技术将节点进行编译打包接着将节点中


## oe2203 操作 buildx 

```bash

https://github.com/multiarch/qemu-user-static/releases/download/v6.2.0/qemu-aarch64-static
{
	"experimental": true
}

```

# 启动创建的容器
```bash

docker buildx create --name builder01
docker buildx use builder01
docker buildx inspect --bootstrap

#Dockerifile 
#FROM --platform=$TARGETPLATFORM
docker buildx build -t actanble/rhel7 --platform linux/amd64,linux/arm64 . --push
```
