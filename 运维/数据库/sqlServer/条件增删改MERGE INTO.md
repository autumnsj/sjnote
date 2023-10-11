MERGE INTO \[dbo\].\[ZK_SYS_MenuTable\] AS a \--可添加 TOP

限制操作行数:

MERGE TOP(2) a：目标表、b：源表

USING \@lcMenuTable AS b

ON a.TableId = b.TableId

WHEN MATCHED \--当两者的id能配，id=1,2的数据被更新

THEN UPDAT SET a.TableName = b.TableName

WHEN NOT MATCHED \--目标表没有的ID, 在原表中有，则插入相关的数据

THEN INSERT (MenuId,TableId,TableName)

VALUES(@ldMenuId,\'{tempid}\' + CAST(NEWID() AS

VARCHAR(50)),b.TableName)

WHEN NOT MATCHED BY SOURCE AND a.MenuId = \@ldMenuId

\--目标表中存在，源表

不存在，则删除

THEN DELETE;

