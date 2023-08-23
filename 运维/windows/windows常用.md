# windows常用
- windows端口映射

```cmd
#添加端口映射
netsh interface portproxy add v4tov4 listenport=30003 connectaddress=127.0.0.1 connectport=1433
#删除端口映射
netsh interface portproxy delete v4tov4 30003
```

- 查看端口站用

- 端口异常提示占用,但实际没占用

  ``` powershell
  net stop winnat
  net start winnat
  ```

  

- scp 复制文件到linux

  ``` bash
  scp -r ruoyi-admin/target/ruoyi-admin.jar root@112.74.170.125:/home/project/auto-amazon/auto-amazon.jar
  ```

  

