# NGINX-PLUS

## [ODP分支修改内容](./odp_contirbute.md)

## 文件描述
- [build_modsecurity.sh](./build_modsecurity.sh) `centos7` 下构建的脚本。
- [./conf](./conf) 替换 nginx部署后的 `conf` 文件夹
    - [./conf/modsec](./conf/modsec) 记录的是`modsec`的配置和规则集合
        - [./conf/modsec/modsecurity.conf](./conf/modsec/modsecurity.conf) `modsecurity` 配置文件
        - [./conf/modsec/rules](./conf/modsec/rules) 拷贝的是 `crs-3.0.4`
        - [./conf/modsec/custom](./conf/modsec/custom) 自定义规则集-也就是平台使用的防护策略
    - [./conf/vhosts](./conf/vhosts) 设置的是反向代理的站点文件夹
        - [./conf/vhost/detect.conf](./conf/vhosts/detect.conf) 配置了waf的地方。
            - 这里需要手动修改 `modsecurity_rules_file` 的路径为 `${curdir}/nginx/conf/modsec/main.conf` 绝对路径。
    - [./conf/nginx.conf](./conf/nginx.conf) `nginx`默认启动文件
- [./extra/www](./extra/www) 自定义错误的位置`www`静态文件。
    - 部署时候需要将`www`文件夹放置在`/var`下。
    - 后续如果自动化的化就用`sed+awk`进行替换
- [Dockerfile](./Dockerfile) 测试Docker自动构建是否出错 【测试无错误】
- [supervisor_ngx.conf](./supervisor_ngx.conf) supervisor 强制运行


## 使用须知
- 如果使用已经打包的版本，需要执行加载环境变量 `echo /opt/nginx/lib64 >> /etc/ld.so.conf.d/ngx.conf` 接着`ldconfig`
    - 上面的示例是放置在 `/opt/` 下，实际执行，修改 `<nginxdir> `  `echo <nginxdir>/nginx/lib64 >> /etc/ld.so.conf.d/ngx.conf && ldconfig`

## 编译须知
- 携带了 lua的版本  [build.sh](./build.sh)
- 未携带 lua 的版本 [build_without_lua.sh](./build_without_lua.sh)
- `resty` 是 `ngx-lua` 兼容的插件，需要防止在 prefix的目录，也就是说，安装结束后，将 `conf`, `resty`, `html` 三个目录拷贝到安装目录
- `nginx.sh` 为启停控制脚本; `chmod +x nginx.sh`

## Appimage 版本使用
- 拷贝 `nginx-$arch.AppImage` 到当前目录即可开箱即用。
- arm版本不支持 appimange

## ARM 版本在 centos7 下编译ok; 一摸一样。
- 结果已经上传。
- [arm64不支持](https://github.com/linuxdeploy/linuxdeploy-plugin-appimage/pull/10)
- `ulimit -n 65535` 文件打开书

## FAQ
- 1.  如果是静态的版本就不需要下面的行，如果是动态编译的就需要下面这行。【2021.8 更新为静态，将链接器编译进去】

```
load_module modules/ngx_http_modsecurity_module.so;
# 2020/9/22 xx-zhang 维护 modsec
```

- 2. 编译过程中出现 `$\r`等字符
- `dos2unix build.sh` 或者  `sed -i 's/\r//' build.sh`


- 3. gcc版本升级

使用 `sclo` 即可。arm的路径是 `centos-altarch`