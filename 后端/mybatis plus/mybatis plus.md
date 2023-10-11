Mybatis-plus之查询

1. 构建条件查询
先来看第一种:QueryWrapper

``` java
@SpringBootTest
   class Mybatisplus02DqlApplicationTests {
   
    @Autowired
    private UserDao userDao;
   
    @Test
    void testGetAll(){
        QueryWrapper qw = new QueryWrapper();
        qw.lt("age",18);
        List<User> userList = userDao.selectList(qw);
     System.out.println(userList);
 }
}
```


lt: 小于(<) ,最终的sql语句为

`SELECT id,name,password,age,tel FROM user WHERE (age < ?)`

第一种方式介绍完后，有个小问题就是在写条件的时候，容易出错，比如age写错，就会导致查询不成功

接着来看第二种:QueryWrapper的基础上使用lambda


```java
@SpringBootTest
class Mybatisplus02DqlApplicationTests {
@Autowired
private UserDao userDao;

@Test
void testGetAll(){
    QueryWrapper<User> qw = new QueryWrapper<User>();
    qw.lambda().lt(User::getAge, 10);//添加条件
    List<User> userList = userDao.selectList(qw);
    System.out.println(userList);
}
}
```


User::getAget,为lambda表达式中的，类名::方法名，最终的sql语句为:
`SELECT id,name,password,age,tel FROM user WHERE (age < ?)`
**注意:**构建LambdaQueryWrapper的时候泛型不能省。

此时我们再次编写条件的时候，就不会存在写错名称的情况，但是qw后面多了一层lambda()调用

接着来看第三种:LambdaQueryWrapper


```java
@SpringBootTest
class Mybatisplus02DqlApplicationTests {
@Autowired
private UserDao userDao;

@Test
void testGetAll(){
    LambdaQueryWrapper<User> lqw = new LambdaQueryWrapper<User>();
    lqw.lt(User::getAge, 10);
    List<User> userList = userDao.selectList(lqw);
    System.out.println(userList);
}
}
```

2.多条件构建
1.需求:查询数据库表中，年龄在10岁到30岁之间的用户信息



```java
@SpringBootTest
class Mybatisplus02DqlApplicationTests {
@Autowired
private UserDao userDao;

@Test
void testGetAll(){
    LambdaQueryWrapper<User> lqw = new LambdaQueryWrapper<User>();
    lqw.lt(User::getAge, 30);
    lqw.gt(User::getAge, 10);
    List<User> userList = userDao.selectList(lqw);
    System.out.println(userList);
}
}
```

gt：大于(>),最终的SQL语句为

SELECT id,name,password,age,tel FROM user WHERE (age < ? AND age > ?)
构建多条件的时候，可以支持链式编程

LambdaQueryWrapper<User> lqw = new LambdaQueryWrapper<User>();
lqw.lt(User::getAge, 30).gt(User::getAge, 10);
List<User> userList = userDao.selectList(lqw);
System.out.println(userList);

2.需求:查询数据库表中，年龄小于10或年龄大于30的数据



```java
@SpringBootTest
class Mybatisplus02DqlApplicationTests {
@Autowired
private UserDao userDao;

@Test
void testGetAll(){
    LambdaQueryWrapper<User> lqw = new LambdaQueryWrapper<User>();
    lqw.lt(User::getAge, 10).or().gt(User::getAge, 30);
    List<User> userList = userDao.selectList(lqw);
    System.out.println(userList);
}
}
```

or()就相当于我们sql语句中的or关键字,不加默认是and，最终的sql语句为:

SELECT id,name,password,age,tel FROM user WHERE (age < ? OR age > ?)
3.null判定

```java
@SpringBootTest
class Mybatisplus02DqlApplicationTests {
@Autowired
private UserDao userDao;

@Test
void testGetAll(){
    //模拟页面传递过来的查询数据
    UserQuery uq = new UserQuery();
    uq.setAge(10);
    uq.setAge2(30);
    LambdaQueryWrapper<User> lqw = new LambdaQueryWrapper<User>();
    lqw.lt(null!=uq.getAge2(),User::getAge, uq.getAge2());
    lqw.gt(null!=uq.getAge(),User::getAge, uq.getAge());
    List<User> userList = userDao.selectList(lqw);
    System.out.println(userList);
}
}
```

lt()方法



condition为boolean类型，返回true，则添加条件，返回false则不添加条件

4.查询指定字段
实现步骤?

```java
@SpringBootTest
class Mybatisplus02DqlApplicationTests {
@Autowired
private UserDao userDao;

@Test
void testGetAll(){
    LambdaQueryWrapper<User> lqw = new LambdaQueryWrapper<User>();
    lqw.select(User::getId,User::getName,User::getAge);
    List<User> userList = userDao.selectList(lqw);
    System.out.println(userList);
}
}
```


select(…)方法用来设置查询的字段列，可以设置多个，最终的sql语句为:

SELECT id,name,age FROM user
1
如果使用的不是lambda，就需要手动指定字段



```java
@SpringBootTest
class Mybatisplus02DqlApplicationTests {

@Autowired
private UserDao userDao;

@Test
void testGetAll(){
    QueryWrapper<User> lqw = new QueryWrapper<User>();
    lqw.select("id","name","age","tel");
    List<User> userList = userDao.selectList(lqw);
    System.out.println(userList);
}
}
```

最终的sql语句为:SELECT id,name,age,tel FROM user

5. 聚合查询
需求:聚合函数查询，完成count、max、min、avg、sum的使用

count:总记录数

max:最大值

min:最小值

avg:平均值

sum:求和



```java
@SpringBootTest
class Mybatisplus02DqlApplicationTests {

@Autowired
private UserDao userDao;

@Test
void testGetAll(){
    QueryWrapper<User> lqw = new QueryWrapper<User>();
    //lqw.select("count(*) as count");
    //SELECT count(*) as count FROM user
    //lqw.select("max(age) as maxAge");
    //SELECT max(age) as maxAge FROM user
    //lqw.select("min(age) as minAge");
    //SELECT min(age) as minAge FROM user
    //lqw.select("sum(age) as sumAge");
    //SELECT sum(age) as sumAge FROM user
    lqw.select("avg(age) as avgAge");
    //SELECT avg(age) as avgAge FROM user
    List<Map<String, Object>> userList = userDao.selectMaps(lqw);
    System.out.println(userList);
}
}
```

6.分组查询
需求:分组查询，完成 group by的查询使用

```java
@SpringBootTest
class Mybatisplus02DqlApplicationTests {
@Autowired
private UserDao userDao;

@Test
void testGetAll(){
    QueryWrapper<User> lqw = new QueryWrapper<User>();
    lqw.select("count(*) as count,tel");
    lqw.groupBy("tel");
    List<Map<String, Object>> list = userDao.selectMaps(lqw);
    System.out.println(list);
}
}
```

groupBy为分组，最终的sql语句为

SELECT count(*) as count,tel FROM user GROUP BY tel
注意:

聚合与分组查询，无法使用lambda表达式来完成
MP只是对MyBatis的增强，如果MP实现不了，我们可以直接在DAO接口中使用MyBatis的方式实现
7.查询条件
前面我们只使用了lt()和gt(),除了这两个方法外，MP还封装了很多条件对应的方法，这一节我们重点把MP提供的查询条件方法进行学习下。

MP的查询条件有很多:

范围匹配（> 、 = 、between）
模糊匹配（like）
空判定（null）
包含性匹配（in）
分组（group）
排序（order）
……
1.等值查询

需求:根据用户名和密码查询用户信息

```java
@SpringBootTest
class Mybatisplus02DqlApplicationTests {
@Autowired
private UserDao userDao;

@Test
void testGetAll(){
    LambdaQueryWrapper<User> lqw = new LambdaQueryWrapper<User>();
    lqw.eq(User::getName, "Jerry").eq(User::getPassword, "jerry");
    User loginUser = userDao.selectOne(lqw);
    System.out.println(loginUser);
}
}
```

eq()： 相当于 =,对应的sql语句为

SELECT id,name,password,age,tel FROM user WHERE (name = ? AND password = ?)
selectList：查询结果为多个或者单个

selectOne:查询结果为单个

2.范围查询

需求:对年龄进行范围查询，使用lt()、le()、gt()、ge()、between()进行范围查询

```java
@SpringBootTest
class Mybatisplus02DqlApplicationTests {
@Autowired
private UserDao userDao;

@Test
void testGetAll(){
    LambdaQueryWrapper<User> lqw = new LambdaQueryWrapper<User>();
    lqw.between(User::getAge, 10, 30);
    //SELECT id,name,password,age,tel FROM user WHERE (age BETWEEN ? AND ?)
    List<User> userList = userDao.selectList(lqw);
    System.out.println(userList);
}
}
```


gt():大于(>)
ge():大于等于(>=)
lt():小于(<)
le():小于等于(<=)
between():between ? and ?
模糊查询
需求:查询表中name属性的值以J开头的用户信息,使用like进行模糊查询



```java
@SpringBootTest
class Mybatisplus02DqlApplicationTests {
@Autowired
private UserDao userDao;

@Test
void testGetAll(){
    LambdaQueryWrapper<User> lqw = new LambdaQueryWrapper<User>();
    lqw.likeLeft(User::getName, "J");
    //SELECT id,name,password,age,tel FROM user WHERE (name LIKE ?)
    List<User> userList = userDao.selectList(lqw);
    System.out.println(userList);
}
}
```

like():前后加百分号,如 %J%
likeLeft():前面加百分号,如 %J
likeRight():后面加百分号,如 J%
4 排序查询

需求:查询所有数据，然后按照id降序



```java
@SpringBootTest
class Mybatisplus02DqlApplicationTests {

@Autowired
private UserDao userDao;

@Test
void testGetAll(){
    LambdaQueryWrapper<User> lwq = new LambdaQueryWrapper<>();
    /**
     * condition ：条件，返回boolean，
     		当condition为true，进行排序，如果为false，则不排序
     * isAsc:是否为升序，true为升序，false为降序
     * columns：需要操作的列
     */
    lwq.orderBy(true,false, User::getId);

    userDao.selectList(lw
}
}
```

orderBy排序
condition:条件，true则添加排序，false则不添加排序
isAsc:是否为升序，true升序，false降序
columns:排序字段，可以有多个
orderByAsc/Desc(单个column):按照指定字段进行升序/降序
orderByAsc/Desc(多个column):按照多个字段进行升序/降序
orderByAsc/Desc
condition:条件，true添加排序，false不添加排序
多个columns：按照多个字段进行排序
————————————————
版权声明：本文为CSDN博主「不爱编程的程序员小白一枚」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/m0_46492137/article/details/131274596
