# 

## 一 .ubuntu 20 + docker安装

- 错误示范, 这样安装版本太低(不推荐)

```bash
 apt install docker.io
 docker --version
```

### [Install using the apt repository](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository) 

Before you install Docker Engine for the first time on a new host machine, you need to set up the Docker repository. Afterward, you can install and update Docker from the repository.



#### [Set up the repository](https://docs.docker.com/engine/install/ubuntu/#set-up-the-repository) 

1. Update the `apt` package index and install packages to allow `apt` to use a repository over HTTPS:

   ```bash
   sudo apt-get update
   sudo apt-get install ca-certificates curl gnupg
   ```

2. Add Docker's official GPG key:

   ```bash
   sudo install -m 0755 -d /etc/apt/keyrings
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpgn --dearmor -o /etc/apt/keyrings/docker.gpg
   sudo chmod a+r /etc/apt/keyrings/docker.gpg
   ```

3. Use the following command to set up the repository:

   ```bash
   echo \
     "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
     "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
     sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   ```

   > **Note**
   >
   > If you use an Ubuntu derivative distro, such as Linux Mint, you may need to use `UBUNTU_CODENAME` instead of `VERSION_CODENAME`.

4. Update the `apt` package index:

   ```bash
   sudo apt-get update
   ```



#### [Install Docker Engine](https://docs.docker.com/engine/install/ubuntu/#install-docker-engine) 

1. Install Docker Engine, containerd, and Docker Compose.

Latest Specific version

------

To install the latest version, run:

content_copy

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

------

1. Verify that the Docker Engine installation is successful by running the `hello-world` image.

   ```bash
   sudo docker run hello-world
   ```

## 二. docker-compose 

- 其实上面的docker安装已经带上了compose, 但使用命令不是docker-compose了 而是 docker compose

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

## 四. Ubuntu18.04安装Docker完整教程

1.更新软件源列表

`sudo apt update`
2.安装软件包依赖

`sudo apt install apt-transport-https ca-certificates curl software-properties-common`
3.在系统中添加Docker的官方密钥

`curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`
4.添加Docker源,选择stable长期稳定版

`sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"`
5.再次更新源列表

`sudo apt update`
6.查看可以安装的Docker版本

`sudo apt-cache policy docker-ce`
7.开始安装Docker（ce表示社区版）

`sudo apt install docker-ce`
8.查看是否成功安装Docker，出现下图，说明安装成功

docker
9.查看安装的Docker版本

`docker -v`
10.启动Docker服务

` sudo systemctl start docker`   //wsl 不好使换成service
11.设置开机自启动docker

`sudo systemctl enable docker`
12.查看Docker是否开启，出现绿色圆点表示服务正常开启

`sudo systemctl status docker`



