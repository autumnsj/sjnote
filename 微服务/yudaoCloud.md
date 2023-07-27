# 环境搭建

## 1. 安装docker及docker-compose

​	....

## 2. 初始化Docker Swarm



**初始化Docker Swarm**：
在命令行或终端中运行以下命令来初始化Docker Swarm：

```
docker swarm init
```

此命令会将当前主机设置为Swarm管理节点，并生成一个令牌（token）。该令牌用于在其他节点上加入Swarm集群。

**加入其他节点（可选）**：
如果您想要在其他主机上加入Docker Swarm集群，您需要在每个节点上运行`docker swarm join`命令，并提供上一步骤中生成的令牌。例如：

```bash
docker swarm join --token <token> <manager-ip>:2377
```

其中，`<token>`是上一步骤中生成的令牌，`<manager-ip>`是Swarm管理节点（主节点）的IP地址。

**创建Overlay网络（可选）**：
如果您想要使用Overlay网络进行跨主机容器通信，请创建一个Overlay网络。例如：

```bash
docker network create -d overlay one_network
```

## 3.安装MySql5.7 (ubuntu)

 [mysql5.7安装.md](..\运维\Linux\mysql5.7安装.md)

## 4. Nacos 集群部署

