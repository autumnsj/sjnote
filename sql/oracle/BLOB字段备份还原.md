BLOB字段备份还原\
备份：\
使用plsql 查看该字段，另存为文件即可xxx.txt\
2.还原\
1 create or replace directory UTL_FILE_DIR as \'C:/qms\';\
2 select \* from \"\_\_MigrationHistory\"\
3 DECLARE\
4 b_file bfile;\
5 b_lob BLOB;\
6 BEGIN\
7 INSERT\
8 INTO \"\_\_MigrationHistory\"\
9 (\
10 \"MigrationId\",\
11 \"ContextKey\",\
12 \"Model\",\
13 \"ProductVersion\"\
14 )VALUES\
15 (\
16 \'202008140745447_add_MODULEID_StringLength\',\
17 \'QMS\',\
18 empty_blob(),

19 \'6.1.3-40302\'\
20 )\
21 RETURN \"\_\_MigrationHistory\".\"Model\"\
22 INTO b_lob;\
23 \--将文件转换为bfile\
24 b_file := bfilename(\'UTL_FILE_DIR\', \'xxx.txt\');\
25 dbms_lob.open(b_file, dbms_lob.file_readonly);\
26 \-- 将b_file中的内容转换到b_lob\
27 dbms_lob.loadfromfile(b_lob,b_file,dbms_lob.getlength(b_file));\
28 dbms_lob.close(b_file);\
29 COMMIT;\
30 END;
