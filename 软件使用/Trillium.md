# Trillium

#### [Zadam英文版](https://github.com/zadam/trilium/blob/master/README-ZH_CN.md)

- Docker运行服务端

```sh
docker run -d -p 8080:8080 \
    -v ~/Soft/trilium-data:/home/node/trilium-data \
    zadam/trilium:0.57.3
```

<!--
![英文首次启动](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202212/01a8ad7d334db003b2c0b25b480ba16d-023486.png)
-->
![英文截图](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202212/51296e2d4290ae225dd189beeb7ab016-80103d.png)

#### [Nriver汉化版](https://github.com/Nriver/trilium-translation/blob/main/README_CN.md)

- Docker运行服务端
```sh
docker run -d -p 8081:8080 \
    -e TRILIUM_DATA_DIR=/root/trilium-data \
    -v ~/Soft/trilium-data-cn:/root/trilium-data \
    nriver/trilium-cn
```

![中文截图](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202212/52134d4d1151b9ea47aba0c7243299f4-6f3cf9.png)

#### 使用

- [Trilium Web Clipper浏览器插件](https://chrome.google.com/webstore/detail/trilium-web-clipper/dfhgmnfclbebfobmblelddiejjcijbjm?hl=zh-CN)

  用来保存一些网页，避免404，样式效果不太理想，能看。
