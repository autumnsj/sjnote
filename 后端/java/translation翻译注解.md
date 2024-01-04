# Translation注解实现自动给字段赋值

- 实体类上使用

```java
    /**
     * 创建人账号
     */
    @Translation(type = TransConstant.USER_ID_TO_NAME, mapper = "createBy")
    private String createByName;
```

- 实现类

```java
/**
 * 翻译接口 (实现类需标注 {@link TranslationType} 注解标明翻译类型)
 *
 * @author Lion Li
 */
public interface TranslationInterface<T> {

    /**
     * 翻译
     *
     * @param key   需要被翻译的键(不为空)
     * @param other 其他参数
     * @return 返回键对应的值
     */
    T translation(Object key, String other);
}
  

/**
   * 用户名翻译实现
   *
   * @author Lion Li
   */
  @AllArgsConstructor
  @TranslationType(type = TransConstant.USER_ID_TO_NAME)
  public class UserNameTranslationImpl implements TranslationInterface<String> {
  
      private final UserService userService;
  
      @Override
      public String translation(Object key, String other) {
          if (key instanceof Long id) {
              return userService.selectUserNameById(id);
          }
          return null;
      }
  }
  
```

-  注解

```java
@Inherited
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.FIELD, ElementType.METHOD})
@Documented
@JacksonAnnotationsInside
@JsonSerialize(using = TranslationHandler.class)
public @interface Translation {

    /**
     * 类型 (需与实现类上的 {@link TranslationType} 注解type对应)
     * <p>
     * 默认取当前字段的值 如果设置了 @{@link Translation#mapper()} 则取映射字段的值
     */
    String type();

    /**
     * 映射字段 (如果不为空则取此字段的值)
     */
    String mapper() default "";

    /**
     * 其他条件 例如: 字典type(sys_user_sex)
     */
    String other() default "";

}

```

