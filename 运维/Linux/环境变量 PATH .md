删除目录\
rmdir\
语法：\
\[root \@test /root \]# rmdir \[-p\] \[目录名称\]\
参数说明：\
-p ：将上层的目录也删除吧！\
范例：\
\[root \@test /root\]# rmdir test\<==删除名称为 test 的目录\
\[root \@test tmp\]# ll\
drwxrwxr-x 3 test test 4096 Feb 6 20:48 test1/\
\[root \@test tmp\]# rmdir test1\
rmdir: \`test1\': Directory not empty\
\[root \@test tmp\]# rmdir -p test1/test2/test3/test4\
\[root \@test tmp\]\$ ll\
说明：\
如果想要建立删除旧有的目录时，就使用 rmdir 吧！例如将刚刚建立的 test
杀掉，使用 rmdir test 即\
可！请注意呦！目录需要一层一层的删除才行！而且被删除的目录里面必定不能还有其它的目录或档\
案！那如果要将所有目录下的东西都杀掉呢？！这个时候就必须使用 rm -rf test
啰！不过，还是使用\
rmdir 比较不危险！不过，你也可以尝试以 -p
的参数加入，来删除上层的目录喔！
