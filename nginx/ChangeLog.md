## 修订记录

### 2021/7/22
- xmtx 创建证书

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=CN/ST=HB/L=WH/O=TSC/OU=TSC/CN=xx/emailAddress=xmtx" -keyout https.key -out https.pem 
cat https.key https.pem > mitmproxy-ca.pem
openssl dhparam -out mitmproxy-dhparam.pem 1024
openssl pkcs12 -export -out https.p12 -in https.pem -inkey https.key -passout pass:
cp https.p12 mitmproxy-ca.p12
```

### 2021/12/12
- 集成sm2-使用双证书。[参考](https://babassl.readthedocs.io/zh/latest/Tutorial/SM/dual-sm2-gen/)
- [nginx-sm2不适配](https://github.com/BabaSSL/BabaSSL/issues/120)
- [babassl-ntls](https://babassl.readthedocs.io/zh/latest/Tutorial/SM/ntls/)

#### 开始尝试使用 `gmssl` 代替 `babassl`
- gmssl需要使用nginx1.17的版本才可以。[1.17-仓库](https://github.com/2b45/nginx-gm)
- 参考文 [文档](https://www.gmssl.cn/gmssl/index.jsp) 进行修改，现在下班。

#### 验证证书
- [验证公网服务端证书](https://www.tlcp.com.cn/index.jsp) 
```bash

gmssl s_server -port 1443 \
    -key ./conf/sm2Certs/CA.key.pem \
    -cert ./conf/sm2Certs/CA.cert.pem  \
    -dkey ./conf/sm2Certs/SE.key.pem \
    -dcert ./conf/sm2Certs/SE.cert.pem  \
    -CAfile ./conf/sm2Certs/CA.pem
```

## 2021/12/14 
- 回头采用 `babassl`, gmssl只有一种算法能用。
- 