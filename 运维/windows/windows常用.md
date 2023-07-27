# windows常用
- windows端口映射

```powershell
netsh interface portproxy add v4tov4 listenport=30003

connectaddress=127.0.0.1

connectport=1433

netsh interface portproxy delete v4tov4 listenport=1521

netsh interface portproxy show v4tov4 listenport=1521
```

- 查看端口站用

- 端口异常提示占用,但实际没占用

  ``` powershell
  net stop winnat
  net start winnat
  ```

  



