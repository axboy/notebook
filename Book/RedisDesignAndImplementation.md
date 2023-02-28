# 《Redis设计实现》笔记

## 数据结构与对象

### 1.1 SDS

```c
struct sdshdr {
  //已使用长度
  int len;

  //未使用长度
  int free;

  //保存的数据
  char buff[];
}
```

- 空间预分配
  if len <= 1M free = len;
  if len > 1M free = 1M;
- 惰性空间释放
  数据缩短后不释放空间
- 二进制安全
  写入什么，读取就是什么
- 兼容C字符串
  空字符结尾，延用string.h库

### 链表
```c
typedef struct listNode{
  //前置节点
  struct listNode *prev;
  
  //后置节点
  struct listNode *next;
  
  //节点的值
  void* value;
} listNode;

typedef struct list{
  //表头节点
  listNode *head;
  //表尾节点
  listNode *tail;
  //链表所包含的节点数量
  unsigned long len;
  //节点值复制函数
  void* (*dup) (void* ptr);
  //节点值释放函数
  void (*free) (void* ptr);
  //节点值对比函数
  int (*match) (void* ptr, void* key);
} list;
```
- 链表被广泛用于实现Redis的各种功能，比如列表键、发布与订阅、慢查询、监视器等
- Redis的链表实现是双端、无环链表
- void* 指针，可保存各种类型节点值

### 字典

```c
//节点
typedef struct dictEntry{
  //键
  void* key;
  
  //值
  union {
    void* val;
    uint64_tu64;
    int64_ts64;
  } v;
  
  //指向下个哈希表节点，形成链表
  struct dictEntry* next;
} dictEntry;

//哈希表
typedef struct dictht{
  //哈希表数组
  dictEntry** table;
  
  //哈希表大小
  unsigned long size;
  
  //哈希表大小掩码，用于计算索引值，总是等于size-1
  unsigned long sizemask;
  
  //该哈希表已有节点的数量
  unsigned long used;
} dictht;
```

- 字典被广泛用于实现Redis的各种功能，其中包括数据库和哈希键。
- Redis中的字典使用哈希表作为底层实现，每个字典带有两个哈希表，一个平时使用，另一个仅在进行rehash时使用。
- 当字典被用作数据库的底层实现，或者哈希键的底层实现时，Redis使用MurmurHash2算法来计算键的哈希值。
- 哈希表使用链地址法来解决键冲突，被分配到同一个索引上的多个键值对会连接成一个单向链表。
- 在对哈希表进行扩展或者收缩操作时，程序需要将现有哈希表包含的所有键值对rehash到新哈希表里面，并且这个rehash过程并不是一次性地完成的，而是渐进式地完成的，对字典curd时顺带处理一些。

### 跳表

> Redis只在两个地方用到了跳跃表，一个是实现有序集合键，另一个是在集群节点中用作内部数据结构，除此之外，跳跃表在Redis里面没有其他用途。

```c
//跳表节点
typedef struct zskiplistNode {
  //层
  struct zskiplist Level {
    struct zskiplistNode* forward;    //前进指针
    unsigned int span;    //跨度
  } level[];
  
  struct zskiplist Node* backward;  //后退指针
  double score;  //分值
  robj* obj;  //成员对象
} zskiplistNode;

//跳表
typedef struct zskiplist{
  struct zskiplistNode *header, *tail;  //表头节点和表尾节点
  unsigned long length;  //表中节点的数量
  intlevel;  //表中层数最大的节点的层数
} zskiplist;
```

- 跳跃表是有序集合的底层实现之一。
- Redis的跳跃表实现由zskiplist和zskiplistNode两个结构组成，其中zskiplist用于保存跳跃表信息（比如表头节点、表尾节点、长度），而zskiplistNode则用于表示跳跃表节点。
- 每个跳跃表节点的层高都是1至32之间的随机数。
- 在同一个跳跃表中，多个节点可以包含相同的分值，但每个节点的成员对象必须是唯一的。
- 跳跃表中的节点按照分值大小进行排序，当分值相同时，节点按照成员对象的大小进行排序。

### 整数集合

```c
typedef struct intset {
  //编码方式
  uint32_t encoding;
  //集合包含的元素数量
  uint32_t length;
  //保存元素的数组
  int8_t contents[];
} intset;
```

- 整数集合是集合键的底层实现之一。
- 整数集合的底层实现为数组，这个数组以有序、无重复的方式保存集合元素，在有需要时，程序会根据新添加元素的类型，改变这个数组的类型。
- 升级操作为整数集合带来了操作上的灵活性，并且尽可能地节约了内存。
- 整数集合只支持升级操作，不支持降级操作。

### 压缩列表
>压缩列表（ziplist）是列表键和哈希键的底层实现之一。

```c
//todo
```

- 压缩列表是一种为节约内存而开发的顺序型数据结构。
- 压缩列表被用作列表键和哈希键的底层实现之一。
- 压缩列表可以包含多个节点，每个节点可以保存一个字节数组或者整数值。
- 添加新节点到压缩列表，或者从压缩列表中删除节点，可能会引发连锁更新操作，但这种操作出现的几率并不高。

### 对象

```c
typedef struct redisObject {
  unsiged type:4;        //类型，type {key} 查看
  unsiged encoding:4;    //编码，OBJECT ENCODING {key} 查看
  void *ptr;             //指向底层数据结构的指针
  
  //...
}
```

- 字符串对象(string)
  int、raw、embstr

- 列表对象(list)
  ziplist、linkedlist

- 哈希对象(hash)
  ziplist、hashtable

- 集合对象(set)
  intset、hashtable

- 有序集合(zset)
  ziplist、skiplist

![obj](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202210/f57d9edc4e2817ded7bc44ada5c58d35-a2f318.png)

## 单机数据库的实现

```c
struct redisServer {
  //...省略一些
  redisDb *db;    //一个数组，保存服务器所有数据库
  list *clients;  //一个链表，所有连接的客户端
  redisClient *lua_client;   //lua伪客户端
  int dbnum;      //数据库数量
}

typedef struct redisClient {
  //...省略一些
  int flags;      //状态标记，一堆值
  sds querybuf;   //输入缓冲区
  int fd;         //正在使用的套接字描述符,-1表示伪客户端，来自aof或lua脚本
  redisDb *db;    //客户端正在使用的数据库
} redisClient;

typedef struct redisDb {
  //...省略一些
  dict *dict;    //数据库键空间，保存着数据库中所有的键值对
  dict *expires; //过期字典，保存键的过期时间
}
```

### 过期键删除策略
一般来说，有如下3种策略，redis使用的是惰性删除+定期删除。

- 定时删除
  在设置键的过期时间的同时，创建一个定时器（timer），让定时器在键的过期时间来临时，立即执行对键的删除操作。

- 惰性删除
  放任键过期不管，但是每次从键空间中获取键时，都检查取得的键是否过期，如果过期的话，就删除该键；如果没有过期，就返回该键。

- 定期删除
  每隔一段时间，程序就对数据库进行一次检查，删除里面的过期键。至于要删除多少过期键，以及要检查多少个数据库，则由算法决定。

![rdb](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202209/afd0e2923302130d8c99dd297dd33435-2c4520.png)
![aof](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202209/51b8144372077b2ce9413596827e410c-7aa1b6.png)
![master-slave](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202209/710fc053b45f1e68fc87998e3eb5afa1-18f9e7.png)

### RDB持久化
![server start](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202209/985792254f90dc94927311a48bae1b38-21a968.png)

```sh
# 可使用od命令分析rdb文件
od -c dump.rdb
```

### AOF持久化
![aof](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202209/50c9dffbfad9e2623c1708984dcd8993-cc9f8c.png)

### 客户端
![clients](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202209/018cff45fbd37683748f725985af495e-18dbb8.png)

### 服务器
![server](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202209/388cb82ca1bd371d34b8bb6b1d5aa80e-14b067.png)

## 多机数据库的实现

### [复制](http://redis.io/topics/replication)

```sh
info replication
slaveof no one
slaveof 192.168.1.30 6379
```

![rep](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202209/c90bd44e782ba9b3afc5adc3585b52ea-013394.png)

### 哨兵
![sentinel](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202209/e22be50e7efcfe97b28f36521169d73c-989996.png)

### 集群
没用过，粗略看了一遍，没细看

```sh
CLUSTER INFO
CLUSTER NODES
CLUSTER MEET <IP> <PORT>
CLUSTER ADDSLOTS 0 1 2 3 4 ... 5000
```

![cluster](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202209/62b5167d47257c8e992627b5e9f23f01-30211c.png)

## 独立功能的实现

### 发布订阅
![sub](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202209/ab1cf31985b37dca7f3c644339ebacfe-4fd38c.png)

### xxx

## 其它

### 参考
- [图书配套网站](http://redisbook.com/)
