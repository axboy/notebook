# HyperV自定义专用网络

文章摘抄自[爱做梦的鱼](https://www.cnblogs.com/dreamer-fish/p/14137017.html)，转载用于备份

```sh
# 新建内部网络（nat），命名为NAT
New-VMSwitch -SwitchName "NAT" -SwitchType Internal

# 查看NAT网卡的 ifindex
Get-NetAdapter

# 为NAT网卡设置IP为192.168.15.1，最后的123为Get-NetAdapter命令所看到的ifindex
New-NetIPAddress -IPAddress 192.168.15.1 -PrefixLength 24 -InterfaceIndex 123

# 创建192.168.15.0/24网段
New-NetNat -Name NAT -InternalIPInterfaceAddressPrefix 192.168.15.0/24
```
