# [PicGo](https://picgo.github.io/PicGo-Doc/)

> 一个用于快速上传图片并获取图片 URL 链接的工具

本文仅记录我的配置，不对其它方案介绍，简单使用，其它强大的功能我不需要。

这里我使用的OSX 10.15.7，PicGo2.3.0。

目前最新稳定版是2.3.1，但最新稳定版存在一个问题，微信截图，不能直接传，需要先保存文件再传。

#### [OSS](https://help.aliyun.com/product/31815.html)配置

![阿里云OSS](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202212/5bc3d4384d77eabe09d5b35b5d1beaf7-395155.png)

#### [重命名插件](https://www.npmjs.com/package/picgo-plugin-rename-file)

```
插件名：rename-file
版本：1.0.4
配置：{y}{m}/{hash}-{rand:6}
```

![plugin-main](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202212/43dc8cc01e85bda9b3fc9182d3e896bd-3c32db.png)

![rename-config](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202212/26ad8d629aac2d475dc8f3cbf8ae438e-61ed72.png)

- 配置说明

```text
{y} 年，4位
{m} 月，2位
{d} 日期，2位
{h} 小时，2位
{i} 分钟，2位
{s} 秒，2位
{ms} 毫秒，3位(v1.0.4)
{timestamp} 时间戳(秒)，10位(v1.0.4)
{hash}，文件的md5值，32位
{origin}，文件原名（会去掉后缀）
{rand:<count>}, 随机数，<count>表示个数，默认为6个，示例：{rand：32}、{rand}
{localFolder:<count>}, <count>表示层级 ，默认为1，示例：{localFolder:6}、{localFolder}
```