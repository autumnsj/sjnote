# jar包部署

## 1.systemd 服务方式部署

- 编写systemd服务文件

```shell
vim wl123.service
```

```ini
[Unit]
Description=wl123
Requires=mysql.service redis.service
After=network.target mysql.service redis.service

[Service]
#EnvironmentFile=/etc/environment
WorkingDirectory=/home/project/wl123
ExecStart=/usr/lib/jvm/java-17-oracle/bin/java -jar -Xms512m -Xmx512m -Dspring.profiles.active=prod  /home/project/wl123/wl123.jar

[Install]
WantedBy=multi-user.target

```

- 复制到systemd服务目录

```shell
 cp wl123.service /etc/systemd/system
 systemctl enable wl123.service
 systemctl start wl123
```
