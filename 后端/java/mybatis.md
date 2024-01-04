## 批量更新

```java
public int updateSysTaskBatch(@Param("sysTask") SysTask sysTask, @Param("list") List<SysTask> list);
```

``` xml
   <update id="updateSysTaskBatch" >
        update sys_task
        <trim prefix="SET" suffixOverrides=",">
            <if test="sysTask.userId != null  ">user_id = #{sysTask.userId},</if>
            <if test="sysTask.taskType != null  ">task_type = #{sysTask.taskType},</if>
            <if test="sysTask.taskName != null">task_name = #{sysTask.taskName},</if>
            <if test="sysTask.taskParams != null">task_params = #{sysTask.taskParams},</if>
            <if test="sysTask.consumer != null">consumer = #{sysTask.consumer},</if>
            <if test="sysTask.status != null">status = #{sysTask.status},</if>
            <if test="sysTask.priority != null">priority = #{sysTask.priority},</if>
            <if test="sysTask.finishTime != null">finish_time = #{sysTask.finishTime},</if>
            <if test="sysTask.result != null">result = #{sysTask.result},</if>
            <if test="sysTask.updateBy != null">update_by = #{sysTask.updateBy},</if>
            <if test="sysTask.updateTime != null">update_time = #{sysTask.updateTime},</if>
            <if test="sysTask.createBy != null">create_by = #{sysTask.createBy},</if>
            <if test="sysTask.createTime != null">create_time = #{sysTask.createTime},</if>
            <if test="sysTask.exceptionMsg != null">exception_msg = #{sysTask.exceptionMsg},</if>
            <if test="sysTask.exceptionTime != null">exception_time = #{sysTask.exceptionTime},</if>
            <if test="sysTask.startTime != null">start_time = #{sysTask.startTime},</if>
            <if test="sysTask.sourceId != null">source_id = #{sysTask.sourceId},</if>
            <if test="sysTask.snapshots != null">snapshots = #{sysTask.snapshots},</if>
        </trim>
        <where>
            task_id in
            <foreach item="item" collection="list" open="(" separator="," close=")">
                #{item.taskId}
            </foreach>
        </where>
    </update>
```





## Mybatis获取插入记录的自增长字段值

方法一 . 在Mapper.[xml](https://so.csdn.net/so/search?q=xml&spm=1001.2101.3001.7020)文件中添加属性 “useGeneratedKeys” 和 “keyProperty” ,其中keyProperty是Java对象（即对应实体类）的属性名

```xml
<insert id="insert" parameterType="com.lv.bean.User" useGeneratedKeys="true" keyProperty="id">
    insert into user(name,age)values(#{name},#{age})
</insert>
```

方法二. 

order="AFTER"  表示在插入之后执行

``` xml
<insert id="insert" parameterType="com.lv.bean.User" >
    <selectKey resultType="int" order="AFTER" keyProperty="id">
     select LAST_INSERT_ID()
    </selectKey>
    insert into user(name,age)values(#{name},#{age})
</insert>
```

