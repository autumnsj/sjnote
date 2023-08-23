## 一 .docker安装

```bash
 apt install docker.io
 docker --version
```



## 二. docker-compose安装

``` bash
 apt install docker-compose
 docker-compose --version
```



## 三. 常用命令

```bash
# 构建镜像
docker build -t isa:1.0 .
#运行容器
docker run -d --name=isa100 -e clientId=100 --restart=always isa:1.0
#查看容器日志
docker logs isa102 --tail 100  -f
#导出镜像
docker save -o isa1.0.tar isa:1.0
#加载镜像
docker load isa1.0.tar
#更新容易自动启动
docker update --restart always isa100
#更新容易自动启动
docker exec -i -t  isa100 /bin/bash
```



### 四. 批量运行容器的shell 

```bash
#!/bin/bash
if [ "$1" == "run" ]; then
    if [ "$#" -lt 4 ]; then
        echo "Usage: runpy.sh run <image_name> <start_client_id> <end_client_id>"
        exit 1
    fi

    image_name="$2"
    start_client_id="$3"
    end_client_id="$4"

    for ((i=start_client_id; i<=end_client_id; i++)); do
        container_name="isa$i"
        client_id="$i"
        docker run -d --name="$container_name" -e clientId="$client_id" --restart=always "$image_name"
    done

elif [ "$1" == "rm" ]; then
    if [ "$#" -lt 3 ]; then
        echo "Usage: runpy.sh rm <start_client_id> <end_client_id>"
        exit 1
    fi

    start_client_id="$2"
    end_client_id="$3"

    for ((i=start_client_id; i<=end_client_id; i++)); do
        container_name="isa$i"
        docker rm -f "$container_name"
    done

else
    echo "Usage: runpy.sh <command> [<arguments>]"
    echo "Available commands: run, rm"
    exit 1

fi


```