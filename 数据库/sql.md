\--EXEC 输出变量值\
DECLARE \@RowCount int\
DECLARE \@sqlstr nvarchar(4000)\
DECLARE \@tableName nvarchar(100)\
1 \--表名，应用可能有更复杂的参数需要连接\
2 SET \@tableName=\'TEST\'\
3\
4 SET \@sqlstr=\'SELECT \@iRowCount=COUNT(\*) FROM \'+ \@tableName\
5 EXEC sp_executesql \@sqlstr,N\'@iRowCount int output\',@RowCount
output\
6 SELECT \@RowCount\
with temp as(select \* from AA)select \* from temp\
分割字符串，处理JSON，行转列\
1 CREATE function \[dbo\].\[SplitString\]\
2 (\
3 \@Input nvarchar(max), \--input string to be separated\
4 \@Separator nvarchar(max)=\',\', \--a string that delimit the
substrings in the input\
string\
5 \@RemoveEmptyEntries bit=1 \--the return value does not include array
elements that\
contain an empty string\
6 )\
7 returns \@TABLE table\
8 (\
9 \[Id\] int identity(1,1),\
10 \[Value\] nvarchar(max)\
11 )\
12 as\
13 begin\
14 declare \@Index int, \@Entry nvarchar(max)\
15 set \@Index = charindex(@Separator,@Input)

16\
17 while (@Index\>0)\
18 begin\
19 set \@Entry=ltrim(rtrim(substring(@Input, 1, \@Index-1)))\
20\
21 if (@RemoveEmptyEntries=0) or (@RemoveEmptyEntries=1 and
\@Entry\<\>\'\')\
22 begin\
23 insert into \@TABLE(\[Value\]) Values(@Entry)\
24 end\
25\
26 set \@Input = substring(@Input, \@Index+datalength(@Separator)/2,
len(@Input))\
27 set \@Index = charindex(@Separator, \@Input)\
28 end\
29\
30 set \@Entry=ltrim(rtrim(@Input))\
31 if (@RemoveEmptyEntries=0) or (@RemoveEmptyEntries=1 and
\@Entry\<\>\'\')\
32 begin\
33 insert into \@TABLE(\[Value\]) Values(@Entry)\
34 end\
35\
36 return\
37 end\
38\
39\
40\
41 declare \@args varchar(1000)\
42 SET \@args=\
\'E9#192.168.1.251#007#zksoft@1#E:\\ZKSoftERP_E9\\ZKSOFT.E9.WinformUI\\bin\\Debug\\temp\\Repor\
tFiles\\#{\"生产型号\":\"2A02E00000033A0\",\"客户型号\":\"369877\",\"材料代码\":\"2222\",\"数\
量\":\"23\",\"单位\":\"Set\",\"周期\":\"4\",\"打印人\":\"4\",\"表面工艺\":\"E\",\"版本号\":\"123\",\"钻孔编\
码\":\"5\",\"G番号\":\"12\",\"激光码\":\"4\",\"重量\":\"123\",\"零件编码\":\"312\",\"零件名称\":\"231\",\"图\
号\":\"23\",\"总页数\":\"44\",\"日期\":\"2021-04-22\",\"保质期\":\"12\",\"标签数\":\"1\",\"无卤\":\"无卤\",\"生产\
批次\":\"WO22104070030000001\",\"重打流水号\":\"123\",\"RL\":\"412\",\"标签类型\":\"外标签\"}\'\
43 SET \@args=(SELECT Value from \[dbo\].\[SplitString\](@args,
\'#\', 1) WHERE ID=6)\
44 declare \@sql nvarchar(2000)\
45 SELECT \@sql= \'select p.\* from parseJSON(\'\'\'+@args+\'\'\')
PIVOT(MAX(stringvalue) FOR name\
IN(\'+STUFF((SELECT \',\'+cast(name as nvarchar(20))\
46 FROM parseJSON(@args) for xml path(\'\')),1,1,\'\')+\')) p\';\
47 exec sp_executesql \@sql
