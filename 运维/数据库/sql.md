\--EXEC 输出变量值

DECLARE \@RowCount int

DECLARE \@sqlstr nvarchr(4000)

DCLARE \@tableName nvarchar(100)

\--表名，应用可能有更复杂的参数需要连接

SET \@tableName=\TEST\'

3

ST \@sqlstr=\'SELECT \@iRowCount=COUNT(\*) FROM \'+ \@tableName

EXEC sp_executesql \@sqlstr,N\'@iRowCount int output\',@RowCount

output

SELECT \@RoCount

wit temp as(select \* from AA)select \* from temp

分割字串，处理JSON，行转列

CREATE function \[dbo\].[SplitString\]

(

\@Input nvarchar(max), \--input string to b separated

\@Separator nvarchar(max)=\',\', \--a string that delimit the

substrings in the inut

string

\@RemoveEmptyEntries bit=1 \--the return value does not include array

elementsthat

contai an empty string

)

returns \@TABLE table



\[Id\] int identity(1,1),

\[Vale\] nvarchar(max)

)

as

13begin

14declare \@Index int, \@Entry nvarchar(max)

set \@Index= charindex(@Separator,@Input)



16

while (@Index\>0)

begin

set \@Entry=ltrim(rtrim(substring(@Input, 1, \@Index-1)))

20

if (@RemoveEmptyEntries=0) or (@RemoveEmptyEntries=1 and

\@Entry\<\>\'\')

begin

insert into \@TABLE(\[Value\]) Values(@Entry)

end

25

set \@Input = substring(@Input, \@Index+datalength(@Separator)/2,

len(@Input))

set \@Index = charindex(@Separator, \@Input)

end

29

set \@Entry=ltrim(rtrim(@Input))

if (@RemoveEmptyEntries=0) or (@RemoveEmptyEntries=1 and

\@Entry\<\>\'\')

begin

insert into \@TABLE(\[Value\]) Values(@Entry)

end

35

return

end

38

39

40

declare \@args varchar(1000)

SET \@args=

\'E9#192.168.1.251#007#zksoft@1#E:\\ZKSoftERP_E9\\ZKSOFT.E9.WinformUI\\bin\\Debug\\temp\\Repor

tFiles\\#{\"生产型号\":\"2A02E00000033A0\",\"客户型号\":\"369877\",\"材料代码\":\"2222\",\"数

量\":\"23\",\"单位\":\"Set\",\"周期\":\"4\",\"打印人\":\"4\",\"表面工艺\":\"E\",\"版本号\":\"123\",\"钻孔编

码\":\"5\",\"G番号\":\"12\",\"激光码\":\"4\",\"重量\":\"123\",\"零件编码\":\"312\",\"零件名称\":\"231\",\"图

号\":\"23\",\"总页数\":\"44\",\"日期\":\"2021-04-22\",\"保质期\":\"12\",\"标签数\":\"1\",\"无卤\":\"无卤\",\"生产

批次\":\"WO22104070030000001\",\"重打流水号\":\"123\",\"RL\":\"412\",\"标签类型\":\"外标签\"}\'

SET \@args=(SELECT Value from \[dbo\].\[SplitString\](@args,

\'#\', 1) WHERE ID=6)

declare \@sql nvarchar(2000)

SELECT \@sql= \'select p.\* from parseJSON(\'\'\'+@args+\'\'\')

PIVOT(MAX(stringvalue) FOR name

IN(\'+STUFF((SELECT \',\'+cast(name as nvarchar(20))

FROM parseJSON(@args) for xml path(\'\')),1,1,\'\')+\')) p\';

exec sp_executesql \@sql

