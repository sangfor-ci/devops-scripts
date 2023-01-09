#!/bin/bash

DOCKER_HOST=10.11.6.26 && \
cat > /etc/docker/daemon.json <<- EOF
{
        "experimental": true,
        "registry-mirrors": ["https://j64o0run.mirror.aliyuncs.com"],
        "insecure-registries": ["$DOCKER_HOST"]
}

EOF


# linux 本地信任和保存证书 （可以忽略）
#echo -n | openssl s_client -showcerts -connect 10.7.202.199:443 2>/dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' >> /etc/ssl/certs/ca-certificates.crt
#echo -n | openssl s_client -showcerts -connect 10.7.202.199:443 2>/dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /usr/local/share/ca-certificates/10.7.202.199.crt
# oprkoe/redhat6.5

mkdir -p /etc/systemd/system/docker.service.d
cat > /etc/systemd/system/docker.service.d/http-proxy.conf << EOF

[Service]
Environment="HTTP_PROXY=http://10.7.202.198:9980" "HTTPS_PROXY=http://10.7.202.198:9980"
EOF

systemctl daemon-reload
systemctl restart docker
# sudo apt install -y qemu-user-static binfmt-support
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

# docker load -i buildx.tar
# docker load -i qemu-user-static.tar

docker buildx create --name builder01
docker buildx use builder01
docker buildx inspect --bootstrap

