## Docker Swarm

### docker 跨主机访问, 使不同主机的docker容器可以互相访问

使用Docker Swarm非常简单，并且Docker Swarm是Docker引擎的一部分，因此不需要单独安装。只要您已经安装了Docker引擎，就可以开始使用Docker Swarm。下面是使用Docker Swarm的基本步骤：

**初始化Docker Swarm**：
在命令行或终端中运行以下命令来初始化Docker Swarm：

```
docker swarm init
```

此命令会将当前主机设置为Swarm管理节点，并生成一个令牌（token）。该令牌用于在其他节点上加入Swarm集群。

- 如果当时没有记,烤面筋使用命令查看

```
docker swarm join-token manager
```

**加入其他节点（可选）**：
如果您想要在其他主机上加入Docker Swarm集群，您需要在每个节点上运行`docker swarm join`命令，并提供上一步骤中生成的令牌。例如：

```bash
docker swarm join --token <token> <manager-ip>:2377
```

其中，`<token>`是上一步骤中生成的令牌，`<manager-ip>`是Swarm管理节点（主节点）的IP地址。



**创建Overlay网络（可选）**：
如果您想要使用Overlay网络进行跨主机容器通信，请创建一个Overlay网络。例如：

```bash
docker network create -d overlay my_overlay_network
```

**启动服务容器**：
现在，您可以在Swarm集群中启动服务容器。在启动容器时，可以通过`--network`选项将容器连接到Overlay网络，以实现容器之间的跨主机通信。例如：

```
docker service create --name my_service --network my_overlay_network nginx
```

上述命令将在名为"my_overlay_network"的Overlay网络上启动一个名为"my_service"的Nginx服务容器。

**管理Swarm集群**：
您可以使用`docker service`、`docker node`和`docker stack`等命令来管理Swarm集群，包括创建、更新和删除服务，查看节点状态，扩展服务等。

例如，列出Swarm集群上所有的节点：

```bash
docker node ls
```

或者，扩展服务的副本数：

```bash
docker service scale my_service=5
```

这些是使用Docker Swarm的基本步骤。使用Docker Swarm，您可以轻松地部署和管理分布式应用程序，实现容器编排和高可用性。在实际应用中，可以根据具体需求来调整和配置Swarm集群，以满足您的应用程序的要求。

## docker swarm如何在指定的node上运行指定的容器

**描述问题**

比如我们有worker1，worker2，worker3三个docker host另外加一个manager1（它是swarm的master）来管理它们。

如果在manager1上直接docker service create某一个容器的话，比如nginx容器，那么master会来决定挑哪一个node作为nginx容器的运行的host。

如果我要nginx容器只跑在worker1上面的话，应该怎么办呢？

**解决方案**

简单来说就是给每一个node打标签。

```
docker node update --label-add func=nginx worker1
```

上面这句话的意思是master给worker1的docker打上了功能是nginx的标签。func和nginx是你可以自己定的键值对。

然后在运行docker service create 的时候，指定–constraint参数即可

```
docker service create --name my_nginx --constraint 'node.labels.func == nginx' nginx
```

这样nginx的容器就会在worker1上启动，而不会在其他node上启动了。

**补充**

我的好奇心让我使了一个坏。我把worker1打上func=nginx的标签后，在docker service create的constraint参数上故意写成node.labels.func == nginx111。

这个时候用docker service ls和docker service ps nginx都可以看到service已经注册了，但是它的CURRENT STATE显示Pending ， 并且也没有任何分配到node。

我不停止这个service，然后直接把worker2的标签写为nginx111，奇迹般地，在worker2上就自己启动了nginx的容器。master还是很智能的。





## 中间键+ 微服务


```yml
version: "3.8"
services:
  nacos:
    image: nacos/nacos-server
    networks:
      - middleware_network
    deploy:
      placement:
        constraints:
          - node.role == manager
networks:
  middleware_network:

```


```yml
version: "3.8"
services:
  app:
    image: your_app_image
    deploy:
      replicas: 2
      placement:
        constraints:
          - node.labels.worker == true
    networks:
      - middleware_network
networks:
  middleware_network:
    external: true

```

