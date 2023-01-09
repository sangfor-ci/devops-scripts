# 一款轻量的ssh server
> 当然也可以使用 golang 定制自己的 terminal; 




## 搭建 dropbear
```bash title='build_dropbear.sh'
yum -y install gcc gcc-c++ wget curl make libtool 

wget -c -N https://dropbear.nl/mirror/dropbear-2022.83.tar.bz2  && \
    tar xf dropbear-2022.83.tar.bz2 

cd dropbear-2022.83 
./configure --prefix=/opt/dropbear
make 
make install 
 
```