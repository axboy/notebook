# [VaultWarden](https://github.com/dani-garcia/vaultwarden)

> 一个非官方BitWarden服务端，用于密码管理。

#### Docker run

```sh
# 几乎不更新的东西，指定版本更好，1.26是目前最新的
# 使用的SQLite，要切换MySQL、PG的之类的，请看Wiki
docker run -d --name vaultwarden \
    -v /vw-data/:/data/ \
    -p 8080:80 \
    vaultwarden/server:1.26.0
```

#### nginx config

```plain:conf.d/bitwarden.axboy.cn.conf
# http
server {
    server_name bitwarden.axboy.cn;
    listen 80;
    listen [::]:80;
    deny all;
    #return 302 https://$server_name$request_uri;
}

# https
server {
    server_name bitwarden.axboy.cn;
    listen 443 ssl;
    listen [::]:443 ssl;
    ssl on;

    access_log  /var/log/nginx/bitwarden.axboy.cn.access.log;
    error_log   /var/log/nginx/bitwarden.axboy.cn.error.log;

    # ssl
    ssl_certificate   conf.d/cert/bitwarden.axboy.cn.pem;
    ssl_certificate_key  conf.d/cert/bitwarden.axboy.cn.key;
    ssl_session_timeout 5m;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;

    location / {
        proxy_pass              http://172.17.0.1:8080;
        proxy_headers_hash_max_size 		51200;
        proxy_headers_hash_bucket_size		6400;
        proxy_set_header        Host            $host;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-For $remote_addr;
    }

    #disable sign up
    location /api/accounts/register {
        deny all;
    }
}
```

#### 建议

- 禁用注册

    如果公网可访问，可以从nginx上就把注册接口禁掉。

    也可以配置参数以禁用，更多请看[Wiki](https://github.com/dani-garcia/vaultwarden/wiki)。

    不开放注册的话，建议从nginx禁，省事，要的时候启用或者使用内网访问就好。

- 数据库

    建议使用默认的SQLite，备份文件即可，简单点。

    比如使用MySQL，建表、导表、备份这些懂的话也可以。
