设置软件成服务

chkconf g(check config)

i

功能说明：检查，设置系统的各种服务。

语 法：chkconfig \[\--add\]\[\--del\]\[\--list\]\[系统服务\] 或

chkconfig \[\--level \<等级代号\>\]\[系统服

务\]\[on/off/reset\]

补充说明：这是Red

Hat公司遵循GPL规则所开发的程序，它可查询操作系统在每一个执行等级中会

执行哪些系统服务，其中包括各类常驻服务。

参 数：

\--add

增加所指定的系统服务，让chkconfig指令得以管理它，并同时在系统启动的叙述文件内

增加相关数据。

\--del

删除所指定的系统服务，不再由chkconfig指令管理，并同时在系统启动的叙述文件内删

除相关数据。

\--level\<等级代号\> 指定读系统服务要在哪一个执行等级中开启或关毕

