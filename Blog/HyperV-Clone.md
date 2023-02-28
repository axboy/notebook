# HyperV克隆虚拟机

> 近期折腾kubernetes，虚拟机这块有一些坑，写篇文章记录一下。

## 网络

虚拟交换机这块，我更推荐使用外部网络（vmware叫桥接模式，VMnet0），hyper-v需要自己创建外部网络，默认的是NAT。

静态ip，个人都是从路由器配置，虚拟机上dhcp即可。

能从上层解决的问题，就在上层解决，对用户无感。

![network](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202212/281f72f31610083060c286da05b803e3-44ce77.png)

## ~~创建~~

懂的都懂，跳过

## 复制

搭虚拟机集群一般操作，先创建一个虚拟机，启动并把一些软件配置好，关机，准备复制。

- 方案一

复制文件夹，再导入虚拟机。

若创建虚拟机时未指定文件目录，hyperv的文件不集中，不推荐。

- 方案二

选择导出虚拟机，再导入虚拟机。

和方案一的优点在于文件更好管理，操作是一样的。

缺点：导入的虚拟机product_uuid是一样的，搭kubernetes集群时，这里坑了。

- 方案三

仅复制虚拟磁盘，指定复制后的vmdk，重新创建虚拟机。

新创建的虚拟机可以解决product_uuid重复的问题

仔细想想，安装虚拟机，若没有特殊需求，配置就是固定的，选择cpu、内存、硬盘，所以配置信息其实可以不保存，备份磁盘就行了。

## 引用

- [cnblogs-克隆虚拟机](https://www.cnblogs.com/lonquanzj/p/14016610.html)

- [MS-Q&A](https://docs.microsoft.com/en-us/answers/questions/236058/can-we-change-the-vmid-of-an-hyper-v-vm-if-yes-how.html)
