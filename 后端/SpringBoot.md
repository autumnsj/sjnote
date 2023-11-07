#  Spring boot 常用

## 1.Spring Boot 中的缓存注解

在 Spring Boot 中，缓存是一个非常重要的话题。当我们需要频繁读取一些数据时，为了提高性能，可以将这些数据缓存起来，避免每次都从数据库中读取。为了实现缓存，Spring Boot 提供了一些缓存注解，可以方便地实现缓存功能。



缓存注解是什么？
Spring Boot 提供了四个缓存注解，分别是：

@Cacheable
@CachePut
@CacheEvict
@Caching
这些注解可以用来标记一个方法需要被缓存，或者缓存需要被更新或删除。

缓存注解的原理
在 Spring Boot 中，缓存的实现是通过缓存管理器来实现的。缓存管理器负责缓存的创建、读取、更新和删除等操作。Spring Boot 提供了多种缓存管理器的实现，例如 Ehcache、Redis、Caffeine 等。

当一个方法被标记为缓存方法时，Spring Boot 会先查找是否存在缓存，如果存在，则直接从缓存中读取数据。如果缓存中不存在，则执行方法并将结果缓存到缓存中。

当一个方法被标记为更新或删除缓存时，Spring Boot 会根据注解中的参数来更新或删除缓存。例如，@CachePut 注解会将方法的结果缓存起来，而 @CacheEvict 注解会删除缓存。

如何使用缓存注解？

### 开启功能

要使用缓存注解功能, 需要在启动类中添加@EnableCaching注解, 表示开启

```java
@EnableCaching
```





在 Spring Boot 中，可以通过在方法上添加缓存注解来开启缓存功能。下面介绍四个常用的缓存注解。

```java
@Cacheable
@Cacheable 注解可以标记一个方法需要被缓存。在注解中，可以指定缓存的名称和缓存的键。例如：

@Cacheable(value = "users", key = "#id")
public User getUserById(Long id) {
    // 从数据库中读取用户信息
}
```


在上面的例子中，缓存的名称是 users，缓存的键是方法的参数 id。当方法被执行时，Spring Boot 会先查找缓存，如果缓存中存在相应的数据，则直接从缓存中读取，否则执行方法并将结果缓存到缓存中。

```java
@CachePut
@CachePut 注解可以标记一个方法需要更新缓存。在注解中，可以指定缓存的名称和缓存的键。例如：

@CachePut(value = "users", key = "#user.id")
public User updateUser(User user) {
    // 更新数据库中的用户信息
}
```


在上面的例子中，缓存的名称是 users，缓存的键是方法返回值 user.id。当方法被执行时，Spring Boot 会更新缓存中的数据。

```java
@CacheEvict
@CacheEvict 注解可以标记一个方法需要删除缓存。在注解中，可以指定缓存的名称和缓存的键。例如：

@CacheEvict(value = "users", key = "#id")
public void deleteUserById(Long id) {
    // 删除数据库中的用户信息
}
```


在上面的例子中，缓存的名称是 users，缓存的键是方法的参数 id。当方法被执行时，Spring Boot 会删除缓存中对应的数据。

``` java
@Caching
@Caching 注解可以将多个缓存注解组合在一起使用。例如：

@Caching(
    cacheable = @Cacheable(value = "users", key = "#id"),
    put = @CachePut(value = "users", key = "#result.id"),
    evict = @CacheEvict(value = "allUsers", allEntries = true)
)
public User getUserById(Long id) {
    // 从数据库中读取用户信息
}
```


在上面的例子中，@Caching 注解包含了三个缓存注解：@Cacheable、@CachePut 和 @CacheEvict。当方法被执行时，Spring Boot 会先查找缓存，如果缓存中存在相应的数据，则直接从缓存中读取；如果缓存中不存在，则执行方法并将结果缓存到缓存中；同时更新 users 缓存中的数据，并删除 allUsers 缓存中的所有数据。

缓存注解的配置
在 Spring Boot 中，可以通过配置文件来配置缓存的属性。下面是一个使用 Redis 作为缓存管理器的配置文件示例：

```yaml
spring:
  cache:
    type: redis
    redis:
      host: localhost
      port: 6379
      password: password
      time-to-live: 30000
```

在上面的例子中，使用 Redis 作为缓存管理器，设置 Redis 的主机地址、端口号、密码和超时时间。可以根据实际情况进行配置。

代码示例
下面是一个使用缓存注解的代码示例。在这个例子中，我们定义了一个 UserService 类，其中包含一个 getUserById() 方法和一个 updateUser() 方法。在方法上添加了缓存注解，可以方便地实现缓存功能。



```java
@Service
public class UserService {
@Autowired
private UserRepository userRepository;

@Cacheable(value = "users", key = "#id")
public User getUserById(Long id) {
    return userRepository.findById(id).orElse(null);
}

@CachePut(value = "users", key = "#user.id")
public User updateUser(User user) {
    userRepository.save(user);
    return user;
}
}
```


在上面的例子中，getUserById() 方法被标记为 @Cacheable 注解，缓存的名称是 users，缓存的键是方法的参数 id；updateUser() 方法被标记为 @CachePut 注解，缓存的名称是 users，缓存的键是方法返回值 user.id。当方法被执行时，Spring Boot 会先查找缓存，如果缓存中存在相应的数据，则直接从缓存中读取，否则执行方法并将结果缓存到缓存中。

总结
在 Spring Boot 中，缓存是非常重要的。通过使用缓存注解，可以方便地实现缓存功能，提高程序的性能。在代码中，我们可以通过使用 @Cacheable、@CachePut、@CacheEvict 和 @Caching 注解来开启缓存功能，也可以通过配置文件来配置缓存属性。
