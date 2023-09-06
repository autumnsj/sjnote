一、原理说明及服务器规划
overlay网络是什么？

overlay就是覆盖的意思，指的就是在物理网络层上再搭建一层网络，基于VXLAN技术封装实现Docker原生网络，可以被称为逻辑网。2台服务器能够通过逻辑网通信的前提是，它们之间的物理网络也是能够通信的，因为overlay网络之建立在物理网络基础之上的。

分布式协调服务的作用？
实现docker跨主机网络通信，我们需要搭建一个分布式协调服务，服务选型可以是consul、etcd、zookpper，这里我们使用consul。

分布式协调服务在这里的作用参考上图：

三个服务器分别启动docker引擎，在启动引擎的时候向docker注册自己的服务地址。
在server1新建了一个overlay network，docker daemon会将network相关的信息注册到consul。consul将network信息同步到server2、server3。
当server3新启动了一个容器x，docker daemon会将容器x的网络配置注册及服务地址配置到consul，并将变更信息通知到其他服务器上的docker daemon
当server2上的一个容器想访问server3上面的容器x，因为其已经通过consul获得了server3容器网络信息，从而能够通过overlay网络访问到server3的容器x。
二、安装Consul集群
consul集群角色规划

## 环境

| 主机    | IP            |
| ------- | ------------- |
| docker1 | 192.168.10.80 |
| docker2 | 192.168.10.81 |
| docker3 | 192.168.10.82 |

正常情况下，consul需要从官网下载(wget https://releases.hashicorp.com/consul/1.16.1/consul_1.16.1_linux_386.zip),由于众所周知的原因下载比较慢，我把这个包传到了CSDN 。下载之后解压就一个consul文件，分别放到三台CentOS的/usr/bin目录下即可。并且在三台服务器上分别执行

```bash
wget https://releases.hashicorp.com/consul/1.16.1/consul_1.16.1_linux_386.zip
wget https://releases.hashicorp.com/consul/1.10.3/consul_1.10.3_linux_amd64.zip
unzip consul_1.10.3_linux_amd64.zip
mv consul /usr/bin
```




在三台服务器上分别启动一个consul Server服务

```bash
##登录zimug1主机，以server形式运行
nohup consul agent -server -bootstrap-expect 2 -data-dir /root/data/consul -node=docker1 -bind=192.168.10.80 -ui -client 0.0.0.0 &
##登录zimug2主机，以server形式运行
nohup consul agent -server -bootstrap-expect 2 -data-dir /root/data/consul -node=docker2 -bind=192.168.10.81 -ui -client 0.0.0.0 & 
##登录zimug3主机，以server形式运行
nohup consul agent -server -bootstrap-expect 2 -data-dir /root/data/consul -node=docker3 -bind=192.168.10.82 -ui -client 0.0.0.0 &
```

consul参数说明:
-server： 以server身份启动。
-bootstrap-expect：集群要求的最少server数量，当低于这个数量，集群即失效。
-data-dir：data存放的目录，更多信息请参阅consul数据同步机制
-node：节点id，在同一集群不能重复。
-bind：监听的ip地址。
-client：客户端的ip地址(0.0.0.0表示不限制)

至此consul server的三个节点就全都启动完成了，但它们现在是独立的。在docker1、docker3的服务器上执行下列命令，将zimug2、zimug3的consul服务join到zimug1的consul服务上，这样它们三个组成一个集群。

```bash
consul join 192.168.10.80
```



完成后通过consul members发现集群现在有三个节点。

```bash
consul members
```

Node     Address             Status  Type    Build   Protocol  DC   Partition  Segment
docker1  192.168.10.80:8301  alive   server  1.16.1  2         dc1  default    <all>
docker2  192.168.10.81:8301  alive   server  1.16.1  2         dc1  default    <all>
docker3  192.168.10.82:8301  alive   server  1.16.1  2         dc1  default    <all>
通过浏览器访问 http://192.168.10.80:8500 可以查看到如下的consul图形界面。

三、修改docker环境

在三台服务器上修改如下配置文件

```bash
vim /usr/lib/systemd/system/docker.service
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock \  #添个杠换行
#docker1 #添加的部份
--cluster-store=consul://192.168.10.80:8500 --cluster-advertise=ens33:2375
#docker2 #添加的部份
--cluster-store=consul://192.168.10.81:8500 --cluster-advertise=ens33:2375
#docker3  #添加的部份
--cluster-store=consul://192.168.10.82:8500 --cluster-advertise=ens33:2375
```


上面配置的含义是通过当前宿主机的ens33:2375(docker守护进程服务)，与consul集群中的192.168.1.111:8500的节点进行通信(注册)。其中ens33是当前主机的网卡接口名称，通过ip addr命令即可查看(根据操作系统不同，有的叫做ens33、eth0等)。

# 加载配置文件# 重启docker
```
systemctl daemon-reload && systemctl restart docker
```

全都完成之后访问http://192.168.1.80:8500/ui/dc1/kv/docker/nodes/ 会发现三个docker注册节点。

四、创建docker network并启动容器
创建一个overlay类型的网络叫做prod_net

```bash
docker network create -d overlay prod_net
```

你会发现我们在docker1主机上执行命令，prod_net网络被同步到dokcer2、docker3上面。这就是分布式协调服务consul起到了作用。

