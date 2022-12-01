## 安装[NodeJs](https://nodejs.org/dist/)

#### 环境变量
```shell
# 安装版可忽略环境变量配置，建议低于12，若还遇插件安装失败，继续降版本
NODE12_HOME=~/Soft/node-v12.22.9-darwin-x64
NODE_HOME=$NODE12_HOME
export PATH=$PATH:$NODE_HOME/bin
```

#### 使用淘宝镜像
```shell
npm config set registry https://registry.npmmirror.com
```

## [GitBook](https://docs.gitbook.com/)
#### 安装gitbook-cli
```shell
npm i -g gitbook-cli
```

#### 初始化
```shell
# 创建文件夹、初始化gitbook，将会生成README.md、SUMMARY.md两个文件
mkdir notebook
cd notebook
gitbook init
```

#### 创建book.json文件，按需配置插件
```json
{
    "title": "笔记",
    "author": "axboy",
    "language": "zh-hans",
    "gitbook": "3.2.3",
    "plugins": [
        "anchors@^0.7.1",
        "github",
        "copyright",
        "sitemap",
        "sitemap-general",
        "expandable-chapters",
        "chapter-fold",
        "3-ba@^0.9.0",
        "terminal@^0.3.2",
        "code",
        "codeblock-filename",
        "tbfed-pagefooter@^0.0.1"
    ],
    "pluginsConfig": {
        "terminal": {
            "copyButtons": true,
            "fade": false,
            "style": "flat"
        },
        "3-ba": {
            "token": "c12fba205ed0dd9a57927875e506fd96"
        },
        "tbfed-pagefooter": {
            "copyright": "Copyright &copy axboy.cn 2022",
            "modify_label": "该文件修订时间：",
            "modify_format": "YYYY-MM-DD HH:mm:ss"
        },
        "github": {
            "url": "https://github.com/axboy/notebook"
        },
        "sitemap": {
            "hostname": "https://notebook.axboy.cn"
        },
        "sitemap-general": {
            "prefix": "https://notebook.axboy.cn"
        },
        "copyright": {
            "site": "https://notebook.axboy.cn",
            "author": "axboy",
            "website": "笔记",
            "copyProtect": false
        }
    }
}
```

#### 安装book.json中配置的插件
```shell
gitbook install
```

#### 启动
```shell
gitbook serve
```

#### 打包
```
gitbook build
```

#### 由SUMMARY.md生成文件
```
# 先编辑SUMMARY文件，再执行一遍初始化即可
gitboot init
```

## 补充

#### 扫描文件生成SUMMARY.md

由于本人习惯直接创建文件，SUMMARY文件的维护就成了问题，故写此js代码扫描文件以生成SUMMARY文件。
复制package.json, gen-summary.js文件，执行以下命令
```shell
npm install             # 安装nodejs依赖
node gen-summary.js     # 执行gen-summary.js里的命令
```

#### 插件搜索

gitbook官方链接已经失效了，搜索插件到[百度](https://baidu.com)、[npmjs](https://www.npmjs.com/)。

#### _cb.apply is not a function_ 错误

- 错误如下：
```log
/Users/zcw/Soft/node-v12.22.9-darwin-x64/lib/node_modules/gitbook-cli/node_modules/npm/node_modules/graceful-fs/polyfills.js:287
      if (cb) cb.apply(this, arguments)
                 ^
TypeError: cb.apply is not a function
    at /Users/zcw/Soft/node-v12.22.9-darwin-x64/lib/node_modules/gitbook-cli/node_modules/npm/node_modules/graceful-fs/polyfills.js:287:18
    at FSReqCallback.oncomplete (fs.js:169:5)
```

- 处理方案
打开该文件(polyfills.js)，把调用function statFix(orig)的3个地方注释掉即可
```js
//位于60多行
// fs.stat = statFix(fs.stat)
// fs.fstat = statFix(fs.fstat)
// fs.lstat = statFix(fs.lstat)
```

## 参考教程
- [NVM教程](https://www.runoob.com/w3cnote/nvm-manager-node-versions.html)
- [插件推荐1](http://www.lilidong.cn/demo/longyuan-gitbook/useConfig/plugins.html)
- [插件推荐2](https://www.wenjiangs.com/doc/i7jwlc35ye)
