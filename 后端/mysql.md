# mysql 常用语句

```mysql
//查找某这段是否包含XXX ,  字段内容是逗号分割的   
SELECT * FROM your_table WHERE FIND_IN_SET('yourValue', column_name) > 0; 
//创建数据库
CREATE DATABASE mydatabase CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

```



### MYSQL 事务处理主要有两种方法：

1、用 BEGIN, ROLLBACK, COMMIT 来实现

- **BEGIN 或 START TRANSACTION**：开用于开始一个事务。
- **ROLLBACK** 事务回滚，取消之前的更改。
- **COMMIT**：事务确认，提交事务，使更改永久生效。

2、直接用 SET 来改变 MySQL 的自动提交模式:

- **SET AUTOCOMMIT=0** 禁止自动提交
- **SET AUTOCOMMIT=1** 开启自动提交

**BEGIN 或 START TRANSACTION** -- 用于开始一个事务：

```
BEGIN; -- 或者使用 START TRANSACTION;
```

**COMMIT** -- 用于提交事务，将所有的修改永久保存到数据库：

```
COMMIT;
```

**ROLLBACK** -- 用于回滚事务，撤销自上次提交以来所做的所有更改：

```
ROLLBACK;
```

**SAVEPOINT** -- 用于在事务中设置保存点，以便稍后能够回滚到该点：

```
SAVEPOINT savepoint_name;
```

**ROLLBACK TO SAVEPOINT** -- 用于回滚到之前设置的保存点：

```
ROLLBACK TO SAVEPOINT savepoint_name;
```

下面是一个简单的 MySQL 事务的例子：

## 实例

```mysql
-- 开始事务
START TRANSACTION;

-- 执行一些SQL语句
UPDATE accounts SET balance = balance - 100 WHERE user_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE user_id = 2;

-- 判断是否要提交还是回滚
IF (条件) THEN
    COMMIT; -- 提交事务
ELSE
    ROLLBACK; -- 回滚事务
END IF;
```

