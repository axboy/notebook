# Nginx

一些个人的[nginx](https://hub.docker.com/_/nginx)配置，本篇完全凭空写的，未重新执行一遍命令，和我的真实配置略有出入。

## docker run nginx

```sh
#准备一个空文件夹
mkdir nginx
cd nginx

# host模式、overlay网络映射端口，为了这一丁点的性能
# 也方便使用非常规端口，用host吧
docker run -d --name nginx \
  --network host \
  -v `pwd`/conf.d:/etc/nginx/conf.d \
  -v `pwd`/logs:/var/log/nginx \
  -v `pwd`/data:/data \
  nginx:1.22
```

## 错误页禁止显示版本号

禁止显示版本号没什么作用，总的来说就是为了安全（正常用户，一般不会访问到错误页面，对不友好的访客，提供的信息少总没错）。

由于没有映射nginx.conf文件，需要从容器拷贝出来修改，不建议进容器安装vim改

1. 把**nginx.conf**从容器内复制出来，
2. 编辑nginx.conf文件,在http块中插入一行：__server_tokens off;__
3. 修改后再复制回去

```sh
docker cp nginx:/etc/nginx/nginx.conf .             #复制出来
vim nginx.conf   #编辑...
docker cp nginx.conf nginx:/etc/nginx/nginx.conf    #复制回容器
rm nginx.conf    #删除本地文件，没什么用了
```

- 完整文件供核对

```plain:nginx.conf
user  nginx;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;
    server_tokens off;   #仅添加这一行，禁用版本显示，其它不变
    include /etc/nginx/conf.d/*.conf;
}
```

## 添加默认配置

默认的配置主要是用来禁止未定义的访问链接(比如ip访问)，减少不必要的麻烦，为了安全，正常用户不会触发该配置。

自定义证书主要用于default配置的443端口，没其它作用，证书信息可以瞎填，不启用https可跳过。

- 生成自定义证书

```sh
mkdir conf.d/cert
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout conf.d/cert/0default.key -out conf.d/cert/0default.crt
```

由于按ascii排序，只要其它配置文件不是瞎起名字，0default.conf就在第一个。

```plain:conf.d/0default.conf
server {
    server_name _;
    listen 80 default_server;
    listen 443 default_server;

    ssl_certificate   conf.d/cert/0default.crt;
    ssl_certificate_key  conf.d/cert/0default.key;

    root /data/tmp;
    access_log  /var/log/nginx/default.access.log;
    error_log   /var/log/nginx/default.error.log;

    deny all;
    #或者重定向到某个页面
    #return 302 https://axboy.dev;
}
```

## 示例配置

我的习惯是完整域名作为文件名，每个子域名1个conf文件，以www.axboy.dev为例。

一堆教程都是nginx.conf一把梭，子域名很少或者配置几乎不会改了，一把梭没关系，否则建议分开。

```plain:conf.d/www.axboy.dev.conf
server {
    server_name axboy.dev www.axboy.dev *.axboy.dev;
    client_max_body_size	10m;
    listen *:80;
    listen *:443 ssl;
    #ssl on;

    # 静态文件夹和域名对应
    root /data/www.axboy.dev/;
    index index.html index.htm;

    # 日志文件名和域名对应
    access_log  /var/log/nginx/www.axboy.dev.access.log;
    error_log   /var/log/nginx/www.axboy.dev.error.log;

    # 证书配置
    ssl_certificate   conf.d/cert/cloudflare.axboy.dev.pem;
    ssl_certificate_key  conf.d/cert/cloudflare.axboy.dev.key;

    location /api {
        proxy_pass              http://172.17.0.1:8080;
        proxy_headers_hash_max_size             51200;
        proxy_headers_hash_bucket_size          6400;
        proxy_set_header        Host            $host;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-For $remote_addr;

        proxy_buffering off;

        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

## 其它

- 所有文件树

下面列出关于本篇的目录结构，供理解。

```sh
#tree -a .
.
├── conf.d
│   ├── 0default.conf
│   ├── www.axboy.dev.conf
│   └── cert
│       ├── 0default.key
│       ├── 0default.crt
│       ├── cloudflare.axboy.dev.key
│       └── cloudflare.axboy.dev.pem
├── data
│   ├── test.axboy.dev
│   └── www.axboy.dev
└── logs
    ├── access.log
    ├── default.access.log
    ├── default.error.log
    ├── error.log
    ├── www.axboy.dev.access.log
    └── www.axboy.dev.error.log
```
