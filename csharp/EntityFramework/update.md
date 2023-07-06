这个问题\
update出错- -\
说的主键重复..\
- -\
项载燕 9:57:34\
==哦看看描述\
神迹 9:57:49\
不重复还叫update么..我也是醉了.\
神迹 9:59:00\
这里出错\
项载燕 9:59:52\
你不查询下再更新吗\
神迹 10:00:13\
没有,直接更新..

项载燕 10:01:01\
你先查询对应的实体，然后重新赋值那个查询出来的实体，然后再更新看看\
因为那个input没有ef的跟踪状态\
项载燕 10:02:13\
而且那个updateasync 不懂有没有在更新的时候帮你执行添加踪状态\
神迹 10:02:53\
他写的例子是不用的.\
我试试.\
先.\
项载燕 10:03:15\
你先试试我说的看看\
那个方法有应该有类似这种的吧\
神迹 10:03:48\
可以.\
项载燕 10:03:48\
DbEntityEntry\<TEntity\> entry = dbContext.Entry(entity);\
if (entry.State == EntityState.Detached)\
{\
dbSet.Attach(entity);\
entry.State = EntityState.Modified;\
}\
update的时候\
可以是什么可以\
神迹 10:04:16\
是OK了.
