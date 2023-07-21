Oracle 11g 静默安装过程（centos7）

原文地址：https://jingyan.baid.com/article/90895e0f29c92164ec6b0bd1.html

本人针对原文尝试并加入自己遇到问题的处理方法而已。

1、开启机器，本次实例分配的ip是：192.168.3.197（Xshell ssh连接）

2、安装unzip 工具、vim辑器（个人习惯，vi也可以）

3、在vi /etc/hosts文件中添加本机IP跟主机名

4、关闭selinux ，编辑vi /etc/selinux/config文件，设SELINUX= enforcing

为

SELINUX=disabled

5、关闭防火墙

（1）查看防火墙状态：systemctl status firewalld

（2）停止防火墙：sysemctl stop firewalld

（3）关闭自启动防火墙服：systemctl disable firewalld

6、安装Oracle 11依赖包



\[root@woitumi-197 \~]# yum -y install gcc make binutils gcc-c++

compat-libstdc++-33

elfutils-libelf-devel elfutils-libelf-devel-static elfutils-libelf-devel

ksh libaio libaio-devel

numactl-devel sysstat unixOBC unixODBC-devel pcre-devel

7、添加oinstall 、dba 组，新建oracl用户并加入oinstall、dba组中；

设置oracle用户登录密码；

查看Oracle用户信息

groupadd oinstall

groupadd dba

useradd -g oinstall -G dba oracle

passwd oracle

8、修改内核参数：编辑 vi /etc/sysctl.conf

添加以下设置：

io-max-nr = 104576

fs.fle-max = 6815744

kenel.shmall = 2097152

kernel.shmmax = 1073741824

kernel.shmmni = 4096



kernel.sem = 250 32000 100 128

net.ipv4.ip_local_port_range = 000 65500

net.core.rmem_default = 262144

net.core.rmem_max = 4194304

net.core.wmem_default = 262144

netcore.wmem_max = 1048576

让参数生效：sysctl --p

9、修改用户的限制文件，编辑 i /etc/security/limits.conf

添加以下配置：

oracle soft nroc 2047

oracle hard nproc 16384

oracle soft nofile 1024

oracle ard nofile 65536

oracle soft stack 10240

10、修改vi /etc/pam.d/login文件，添加：

session required /lib64/security/pam_limit.so

session required pam_limits.so



11、修改vi /etc/profile文件：

\[root@woitumi-197 \~\]# vim /etc/profile

添加：

if \[ \$USER = \"oracle\" \] then

if [ \$SHELL = \"/bin/ksh\" \]; then

ulimit -p 16384

ulimit -n 65536

else

ulimit -u 16384 -n 65536

fi

fi



12、创建安装目录、修改文件权限

\[root@woitumi-197 \~\]# mkdir -p /u01/app/oracle/product/11.2.0

\[root@woitumi-197 \~\]# mkdir/u01/app/oracle/oradata

\[root@woitumi-17 \~\]# mkdir /u01/app/oracle/inventory

\[root@oitumi-197 \~\]# mkdir /u01/app/oracle/fast_recovery_area

\[root@woitumi-19 \~\]# chown -R oracle:oinstall /u01/app/oracle

\[root@oitumi-197 \~\]# chmod -R 775 /u01/app/oracle

13、上传oracle软件包 /tmp目录下（xftp上传）

14、解压oracle软件包：

\[root@woitumi-197 tmp\]# uzip linux.x64_11gR2_database_1of2.zip &&

unzip

linux.x64_11gR2_databae_2of2.zip

15、切换到oracle用户，设置oracle用户环境变量

\[root@woitumi-197 database\]# su - oracle

\[oracle@woitui-197 \~\]\$ vim .bash_profile

添加：

ORACLE_BASE=/u01/app/oracle



ORACLE_HOME=\$ORACLE_BASE/product/11.2.0

ORACLE_SID=orcl

ORACLE_UNQNAME=orcl （启动EM需要这个）

PATH=\$PATH:\$ORACLE_HOME/bin

export ORACLE_BASE ORACLE_OME ORACLE_SID ORACLE_UNQNAME PATH

16、编辑静默安装响应文件

（1）切换到rot 用户进入oracle安装包解压后的目录

/tm/database/response/下备份

db_install.rsp文件。

（2）编辑/tmp/database/response/db_install.rsp文件

\[root@woitumi-197 resonse\]# vim db_install.rsp

修改以下参数：

oracle.install.option=INSTALL_D_SWONLY

ORACLE_HOSTNAME=woitumi-197

UNIX_GROUP_NAME=oinstall

INVENTRY_LOCATION=/u01/app/oracle/inventory

SELECTED_LANGUAGESen,zh_CN

ORACLE_HOME/u01/app/oracle/product/11.2.0

ORACLE_BASE=/u01/app/oracle

oracle.install.db.InstallEdition=EE

oracle.install.db.DBA_ROUP=dba

oracle.install.db.OPER_GROUP=dba



DECLINE_SECURITY_UPDATES=true

17、根据响应文件安装oracle 11g

\[oracle@woitumi-197 database\]\$ ./runInstaller -slent -ignorePrereq

-ignoreSysPrereqs

-responseFile /tmp/database/response/db_insall.rsp

开始Oracle在后台静默安装。安装过程中，如果提示\[WARNING]不必理会，此时安装程序仍在后台

进行，如果出现[FATAL\]，则安装程序已经停止了。

出现以上界面，说明安装程序已在后台运行，此时再打开另外一个终端选项卡，输入提示会话日志

目录：

\[roo@woitumi-197 \~\]# tail --f

/u01/ap/oracle/inventory/logs/installActions2017-06-

09_03-00-09PM.log

看到日志文件会持续输出安装信息没有输入异常信息，则表明安装过程正常

待看到下图红色框部分，则表明安装已经完成



18、按照提示切换root用户运行脚本

\[oracle@woitumi-197 database\]\$ su

\[root@woitumi-197 database\]# sh

/u01/app/oracle/inventory/orainstRoot.sh

\[root@woitumi-197 database\]# sh

/u01/app/oracle/product/11.2.0/root.sh

19、用oracle用户登录配置监听（不能用Xshell等远程执行此步骤）

\[oracle@woitumi-197 \~\]\$ netca -silent -responseFile

/tmp/database/response/netca.rsp

出现下图情况时，则需要配置DISPLAY变量，配完之后重新netca：

\[oracle@woitumi-197 \~\]\$ export DISPLAY=localhost:0.0



有时候会出现"libXext.so.6: cannot open shared object file:"的错误

请在root执行 yum install libXext\*

成功运行后，会在/u01/app/oracle/product/11.2.0/network/admin/

中生成listener.ora和

sqlnet.ora两个文件。

查看监听端口：

\[root@woitumi-197 admin\]# netstat -tnulp \| grep 1521

20、建立新库，同时建立对应的实例

切换到root用户，编辑vi /tmp/database/response/dbca.rsp

修改以下参数：

GDBNAME = \"orcl\"

SID = \"orcl\"

SYSPASSWORD = \"oracle\"

SYSTEMPASSWORD = \"oracle\"

SYSMANPASSWORD = \"oracle\"

DBSNMPPASSWORD = \"oracle\"

DATAFILEDESTINATION =/u01/app/oracle/oradata

RECOVERYAREADESTINATION=/u01/app/oracle/fast_recovery_area

CHARACTERSET = \"ZHS16GBK\"

TOTALMEMORY = \"1638\"

21、进行静默配置

root@woitumi-197 oracle\]# su - oracle

\[oracle@woitumi-197 \~\]\$ dbca -silent -responseFile

/tmp/database/response/dbca.rsp



22、完成建库后进行实例检查

\[oracle@woitumi-197 \~\]\$ ps -ef \| grep ora\_ \| grep -v grep

23、查看监听状态

\[oracle@woitumi-197 \~\]\$ lsnrctl status



24、登录查看实例状态

\[oracle@woitumi-197 dbs\]\$ sqlplus / as sysdba

启动数据库：SQL\> startup

看到以下信息，，表明数据库实例已经启动成功，至此，oracle

11g静默安装完成结束。

如果SQL\> startup之后报LRM-00109错

则需要cd

/u01/app/oracle/admin/orcl/pfile到目录下，把init.ora.59201719540文件cp

到/u01/app/oracle/product/11.2.0/dbs/initorcl.ora

解决方法参考：http://yesican.blog.51cto.com/700694/471052

若遇到SQL\> startup之后报LRM-01102错

可以尝试重启机器得到解决，重启后还是一样则可以参考：

http://blog.csdn.net/lzwgood/article/details/26368323



或者借助搜索引擎搜索。

25、启动EM

oracle用户下输入 emctl start dbconsole

报错：

OC4J Configuration issue.

/u01\...dbhome_1/oc4j/j2ee/OC4J_DBConsole_orcl-db-01_orcl

not found.

解决办法：

oracle用户下输入 emca -config dbcontrol db -repos recreate;

26、Oracle创建用户、角色、授权、建表

一、创建用户

oracle内部有两个建好的用户：system和sys。用户可直接登录到system用户以创建其他用户，因为

system具有创建别 的用户的 权限。

在安装oracle时，用户或系统管理员首先可以为自己建立一个用

户。

语法\[创建用户\]： create user 用户名 identified by 口令\[即密码\]；

例子： create user test identified by test;

语法\[更改用户\]: alter user 用户名 identified by 口令\[改变的口令\];

例子： alter user test identified by 123456;

二、删除用户

语法：drop user 用户名;

例子：drop user test;

若用户拥有对象，则不能直接删除，否则将返回一个错误值。指定关键字cascade,可删除用户所有的

对象，然后再删除用户。

语法： drop user 用户名 cascade;

例子： drop user test cascade;

三、授权角色

oracle为兼容以前版本，提供三种标准角色（role）:connect/resource和dba.

（1）讲解三种标准角色：

1》. connect role(连接角色)

\--临时用户，特指不需要建表的用户，通常只赋予他们connect role.

\--connect是使用oracle简单权限，这种权限只对其他用户的表有访问权限，包括

select/insert/update和delete等。

\--拥有connect role

的用户还能够创建表、视图、序列（sequence）、簇（cluster）、同义词

(synonym)、回话（session）和其他 数据的链（link）

2》. resource role(资源角色)

\--更可靠和正式的数据库用户可以授予resource role。



\--resource提供给用户另外的权限以创建他们自己的表、序列、过程(procedure)、触发器

(trigger)、索引(index)和簇(cluster)。

3》. dba role(数据库管理员角色)

\--dba role拥有所有的系统权限

\--包括无限制的空间限额和给其他用户授予各种权限的能力。system由dba用户拥有

（2）授权命令

语法： grant connect, resource to 用户名;

例子： grant connect, resource to test;

（3）撤销权限

语法： revoke connect, resource from 用户名;

列子： revoke connect, resource from test;

四、创建/授权/删除角色

除了前面讲到的三种系统角色\-\-\--connect、resource和dba，用户还可以在oracle创建自己的role。

用户创建的role可以由表或系统权限或两者的组合构成。为了创建role，用户必须具有create

role系

统权限。

1》创建角色

语法： create role 角色名;

例子： create role testRole;

2》授权角色

语法： grant select on class to 角色名;

列子： grant select on class to testRole;

注：现在，拥有testRole角色的所有用户都具有对class表的select查询权限

3》删除角色

语法： drop role 角色名;

例子： drop role testRole;

注：与testRole角色相关的权限将从数据库全部删除

