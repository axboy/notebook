# [zerotier](https://www.zerotier.com/)

> 一个虚拟网络，我当做SD-WAN使用

## Linux

```sh
# 下载安装，加入网络
curl -s https://install.zerotier.com/ | sudo bash
zerotier-cli join {NETWORK_ID}
```

- 开启局域网路由转发

```sh
echo 1 > /proc/sys/net/ipv4/ip_forward

# {eth1}需替换为zerotier对应的虚拟网卡
iptables -I FORWARD -i {eth1} -j ACCEPT
iptables -I FORWARD -o {eth1} -j ACCEPT
iptables -t nat -A POSTROUTING -o {eth1} -j MASQUERADE
```

## Moon

- 服务端执行(安全组需开放9993端口)

```sh
# 生成moon.json
cd /var/lib/zerotier-one
sudo zerotier-idtool initmoon identity.public > moon.json

# 编辑moon.json，设置ip
"stableEndpoints": [ "23.23.23.23/9993" ]

# 生成签名文件
sudo zerotier-idtool genmoon moon.json 
mkdir moons.d
mv ./*.moon ./moons.d/

# 重启
systemctl restart zerotier-one
```

- 设备端执行

```sh
# 加入moon
zerotier-cli orbit {MOON_ID} {MOON_ID}

# 校验
zerotier-cli listpeers
```

## 客户端路由管理

- linux

```sh
# 添加路由
sudo ip route add 172.21.0.0/16 via 192.168.0.106
sudo ip route add 172.22.0.0/16 via 192.168.0.105

# 删除路由
sudo ip route del 172.17.0.0/16
```
- win

```cmd
# 添加路由，9000为跃点数，这是很低的值
route add 192.168.0.0 mask 255.255.255.0 -p 192.168.192.3 METRIC 9000

# 删除
route delete 192.168.0.0 

# 打印
route PRINT
```

## 参考

- [知乎-基于Zerotier的虚拟局域网](https://zhuanlan.zhihu.com/p/383471270)
