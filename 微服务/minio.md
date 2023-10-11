

# MinIo部署

## docker运行 服务端口9090 , 控制台9000

``` shell
docker run --name minio -p 9000:9000 -p 9090:9090 -d --restart=always -e "MINIO_ROOT_USER=admin" -e "MINIO_ROOT_PASSWORD=admin123"  minio/minio server /data --console-address ":9000" -address ":9090"

```
``` shell
#docker options
-v C:\minio\data:/data -v C:\minio\config:/root/
```



