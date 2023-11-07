## redis操作

```shell
#docker运行redis
docker run --name redis --restart=always -d -p 6379:6379 redis
```

``` shell
#docker运行redis并设置密码
docker run --name redis --restart=always -d -p 6379:6379 -e REDIS_PASSWORD=12345600 redis
```



