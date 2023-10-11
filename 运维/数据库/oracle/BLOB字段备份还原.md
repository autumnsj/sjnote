BLOB字段备份还原

备份：

使用plsql 查看该字段，另存为文件即可xxx.txt

2.还原

create or replace directory UTL_FILE_DIR as \'C:/qms\';

 select \* from \"\_\_MigrationHistory\"

 DECLARE

 b_file bfile;

 b_lob BLOB;

 BEGIN

 INSERT

 INTO \"\_\_MigrationHistory\"

 (

 \"MigrationId\",

 \"ContextKey\",

 \"Model\",

 \"ProductVersion\"

 )VALUES

 (

 \'202008140745447_add_MODULEID_StringLength\',

 \'QMS\',

 empty_blob(),



 \'6.1.3-40302\'

 )

 RETURN \"\_\_MigrationHistory\".\"Model\"

 INTO b_lob;

 \--将文件转换为bfile

 b_file := bfilename(\'UTL_FILE_DIR\', \'xxx.txt\');

 dbms_lob.open(b_file, dbms_lob.file_readonly);

 \-- 将b_file中的内容转换到b_lob

 dbms_lob.loadfromfile(b_lob,b_file,dbms_lob.getlength(b_file));

 dbms_lob.close(b_file);

 COMMIT;

 END;

