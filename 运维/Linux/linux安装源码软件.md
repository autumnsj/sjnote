在linux下的很多软件都是通过源码包方式发布的，这样做对于最终用户而言，虽然相对于二进制软件\

包，配置和编译起来繁琐点，但是它的可移植性却好得多，针对不同的体系结构，软件开发者往往仅\

需发布同一份源码包，不同的最终用户经过编译就可以正确运行，这也是非常符合c语言的设计哲学的,\

一次编写，到处编译么，而常见的二进制包，比如rpm和deb，软件开发者必须为每种特定的平台定制\

好专门的软件包，这个通过rpm文件的后缀名就可以初见端倪，比如ppc,sparc,i386之类，在这里不做\

过多的陈述，其实源码安装软件远没有很多朋友想象的那么复杂,下面我在这里尽可能详细的做一些陈\

述，如有谬误，欢迎朋友们拍砖!\

安装的具体步骤：\

1. \$ tar zxvf XXXX.tar.gz (or tar jxvf XXXX.tar.bz2)\
   
2. \$ cd XXXX\
   
3. \$ ./configure\
   
4. \$ make\
   
5. \# make install\
   
复制代码\

1. \$ make clean\
   
复制代码\

安装完成后用来清理临时文件\

1. \# make uninstall\
   
复制代码\

用来卸载软件\

解压:\

最常见源码包的就两种(XXXX.tar.gz or

XXXX.tar.bz2),其实这些源码包都是由2个工具压缩而成\

的，tar.gz结尾的文件用到的工具是tar和gunzip,而tar.bz2结尾的文件所使用的工具是tar和bzip2,之所\

以这样做是因为，tar仅仅能够打包多个文件但是没有压缩的功能，而gz和bz2却刚好相反，仅能够压\

缩单个文件，这样我们常见的源码包实际上是通过tar先将不同的源文件打包，然后再通过gunzip或者\

bzip2压缩后发布的，当然这两个步骤可以通过一条命令实现:\

1. \$ tar zcvf XXXX.tar.gz XXXX(or tar jcvf XXXX.tar.bz2 XXXX)\
   
复制代码\

解压的相关命令如下:\

1. \$ tar zxvf XXXX.tar.gz\
   
2. \$ tar jxvf XXXX.tar.bz2\
   
复制代码\

./configure:

解压完成就正式开始安装了(补充一点，开始configure之前，如有必要，请使用patch工具为源\

码打上相应的补丁),首先跳转到源码的解压目录，众所周知，开始configure前还是应该仔细阅读源码\

目录下的README或者INSTALL文件,好多安装中的注意事项在这里都有所罗列,configure实际上是一\

个脚本文件，在当前目录中键入\"./configure\",shell就会运行当前目录下的configure脚本，有一点必\

须说明，在整个configure过程，其实编译尚未进行，configure仅仅是做编译相关的准备工作，它主\

要对您当前的工作平台做一些依赖性检查，比如编译器是否安装，连接器是否存在，如果在检测的过\

程没有任何错误，你很幸运，configure脚本会在当前目录下生成下一步编译链接所要用到的另一个文\

件Makefile，当然configure支持及其丰富的命令行参数，可以键入\"./configre

\--help\"获取具体的信\

息，最常用的恐怕就是:\

1. \$ ./configure \--prefix=/opt/XXX\
   
复制代码\

它用来设置软件的安装目录.\

make:\

如果configure过程正确完成，那么在源码目录，会生成相应的Makefile文件，Makefile文件简\

单来说包括的是一组文件依赖关系以及编译链接的相关步骤，事实上真正的编译链接工作也不是make\

所做的，make只是一个通用的工具，一般情况下，make会根据Makefile中的规则调用合适的编译器\

编译所有与当前软件相依赖的源码，生成所有相关的目标文件，最后再使用链接器生成最终的可执行\

程序:\

1. \$ make\
   
复制代码\

make install:\

当上面两个步骤正确完成，代表着编译链接过程已经完全结束，最后要做的就是将可执行程序安\

装到正确的位置，在这个步骤，普通用户可能没有相关目录的操作权限，临时切换到root是一个不错\

的选择，\"install\"只是Makefile文件中的一个标号,\"make

install\"代表着make工具执行Makefile文件\

中\"install\"标号下的所有相关操作，如果在configure阶段没有使用\"\--prefix=/opt/XXX\"指定应用程序\

的安装目录，那么应用程序一般会被默认安装到/usr/local/bin，如果/usr/local/bin已经存在于您的\

PATH中，那么安装已经基本结束:\

1. #make install\
   
复制代码\

make clean:\

make uninstall:\

这两个步骤只是安装的后续操作，有一点必须注意，\"clean\"和\"uninstall\"也是Makefile文件中相\

应的两个标号，执行这两个步骤的时候Makefile文件必要保留，\"make

clean\"用来清除编译连接过程\

中的一些临时文件，\"make uninstall\"是卸载相关应用程序，与make

install类似，make uninstall也

需要切换到root执行，不过\"uninstall\"标号在好多Makefile中都被省略掉了，朋友们完全可以自己在\

相应的Makefile文件一探究竟.\

Why?\

在这里我尝试着解释一下上面这些步骤存在的理由，从C语言的角度来说，一个程序从源码到正\

确生成相关的可执行文件，下面这些部分必不可少:源文件，编译器，汇编器，连接器，依赖库，通过\

上面几个步骤，朋友们应该已经知道，真正执行编译链接操作的步骤只有一个(make)，那其他步骤存\

在的理由何在？\

有一点是肯定的，我在自己的电脑上使用C语言写一些自娱自乐的小程序，也没有用\

到\"configure or make

install\"之类的命令，顶多自己写个Makefile管理源文件的依赖关系，可是软件\

开发者不同，他必须考虑到软件的可移植性，他开发的软件不能仅仅就在他自己的pc上跑吧？不同的\

平台可能连硬件体系结构都不同，这样就导致了Makefile的不可移植性，为了解决这个问题，开发者\

通常使用autoconf之类的工具生成相应的configure脚本，而configure脚本就是用来屏蔽相应的平台\

差异，从而正确生成Makefile文件，然后make再根据configure的劳动成果(Makefile)完成编译链接\

工作.\

至于\"install or clean or

uninstall\",也只是对应着Makefile文件中不同的规则，关于Makefile的\

详细信息，朋友们可以自行查阅相关的文档.\

一个例子\

下面是我在自己的pc机上源码安装tar工具的过程，权当做是上面这些步骤的一个具体事例吧:\

1. \[root@localhost \~\]# head -n 1 /etc/issue\
   
2. CentOS release 5.4 (Final)\
   
3. \[root@localhost \~\]# uname -sr\
   
4. Linux 2.6.18-164.el5\
   
5. \[root@localhost \~\]# gcc \--version\
   
6. gcc (GCC) 4.1.2 20080704 (Red Hat 4.1.2-46)\
   
7. Copyright (C) 2006 Free Software Foundation, Inc.\
   
复制代码\

这个是我的系统信息。\

1. \[root@localhost tools\]# pwd\
   
2. /root/tools\
   
3. \[root@localhost tools\]# ls\
   
4. tar-1.23.tar.bz2\
   
5. \[root@localhost tools\]# tar jxvf tar-1.23.tar.bz2\
   
6. \...\...\
   
7. \[root@localhost tools\]# ls\
   
8. tar-1.23 tar-1.23.tar.bz2
   
9\. \[root@localhost tools\]# cd tar-1.23\

10. \[root@localhost tar-1.23\]# ls\
   
11. ABOUT-NLS build-aux configure gnu Makefile.am po src\
   
12. acinclude.m4 ChangeLog configure.ac INSTALL Makefile.in README
   
tests\

13. aclocal.m4 ChangeLog.1 COPYING lib Make.rules rmt THANKS\
   
14. AUTHORS config.h.in doc m4 NEWS scripts TODO\
   
复制代码\

解压原文件包，可以发现其中包括了configure脚本和README文件。\

1. \[root@localhost tar-1.23\]# mkdir -v \~/tar\
   
2. mkdir: 已创建目录 "/root/tar"\
   
3. \[root@localhost tar-1.23\]# ./configure \--prefix=/root/tar\
   
4. \...\...\
   
5. \[root@localhost tar-1.23\]# echo \$?\
   
6. 0\
   
复制代码\

建立软件安装目录，并configure,检查configure返回结果，为0代表运行成功.\

1. \[root@localhost tar-1.23\]# ls -F\
   
2. ABOUT-NLS ChangeLog.1 configure.ac m4/ po/ tests/\
   
3. acinclude.m4 config.h COPYING Makefile README THANKS\
   
4. aclocal.m4 config.h.in doc/ Makefile.am rmt/ TODO\
   
5. AUTHORS config.log gnu/ Makefile.in scripts/\
   
6. build-aux/ config.status\* INSTALL Make.rules src/\
   
7. ChangeLog configure\* lib/ NEWS stamp-h1\
   
复制代码\

可以看到Makefile文件已经被成功建立.\

1. \[root@localhost tar-1.23\]# less Makefile \| grep install:\
   
2. \|\| { echo \"ERROR: files left after uninstall:\" ; \\\
   
3. install: install-recursive\
   
4. uninstall: uninstall-recursive\
   
复制代码\

在建立的Makefile中存在install和uninstall标号\

1. \[root@localhost tar-1.23\]#make\
   
2. \...\...\
   
3. \[root@localhost tar-1.23\]#echo &?\
   
4. 0\
   
复制代码\

make成功

1\. \[root@localhost tar-1.23\]#make install\

2. \...\...\
   
3. \[root@localhost tar-1.23\]# ls /root/tar\
   
4. bin libexec sbin share\
   
5. \[root@localhost tar\]# cd /root/tar/bin\
   
6. \[root@localhost bin\]# ls\
   
7. tar\
   
8. \[root@localhost bin\]# ./tar \--help\
   
9. \...\...\
   
10. \[root@localhost tar-1.23\]#echo &?\
   
11. 0\
   
复制代码\

安装并简单测试成功

