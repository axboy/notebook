# [Kiwix](https://wiki.kiwix.org/wiki/Main_Page/zh-cn)

> 离线维基浏览器，对时刻都有网的人，好像没什么用。

#### [Docker run kiwix](https://github.com/kiwix/kiwix-tools/tree/master/docker/server)

```sh
docker run -d --name kiwix \
    -p 8080:8080 \
    -v `pwd`/kiwix-data:/data \
    kiwix/kiwix-serve:3.4.0
    '*.zim'
```

#### 相关链接
- [官网](https://wiki.kiwix.org/wiki/Main_Page/zh-cn)
- [离线文件下载](https://download.kiwix.org/zim)
