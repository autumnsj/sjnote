- 使用**binlog**进行数据恢复

``` shell
mysqldump -uroot -p --master-data=2 --single-transaction -A > /tmp/all.sql
```

当使用MySQL的`mysqldump`工具进行备份时，`--master-data`选项用于在导出的备份文件中包含二进制日志坐标，这对于进行按时间点的恢复或设置复制很有用。

`--master-data`选项可以采用不同的值来控制输出中包含的信息级别。在这种情况下，`--master-data=2`表示二进制日志坐标将作为注释写入备份文件中。二进制日志坐标包含了备份时二进制日志文件的名称和文件内的位置。

当你希望使用备份文件中包含的二进制日志坐标来执行按时间点的恢复时，通常会使用`--master-data=2`选项。这个信息能够帮助你确定备份时的二进制日志的确切位置，从而可以通过复制或手动应用二进制日志将数据库恢复到特定的时间点。

例如，当你执行以下命令时：

```shell
mysqldump -uroot -p --master-data=2 --single-transaction -A > /tmp/all.sql
```

将会生成一个名为`/tmp/all.sql`的备份文件，其中包含了重新创建所有数据库的SQL语句(`-A`选项)，同时在文件中作为注释包含了二进制日志坐标(`--master-data=2`)。

- 从binlog 

  ```
   mysqlbinlog /tmp/mysql-bin.000005 --start-position=1673097--stop-position=1673374-vv > /tmp/mysql.binlog
  ```

  

