EF获取非跟踪数据之DBSet.AsNoTracking()

标签： EF 实体状态跟踪

2016年12月30日 14:14:25043人阅读 评论(0) 收藏 举报

分类：

EntiryFramework（31）

版权声明：本文为博主原创文章，未经博主允许不得转载。

https://blog.csdn.net/u011127019/article/detals/53942012

一、EF中用户查询非跟踪数据的方式是使用DBSet.AsNoTracking()

1.目前EF版本是6.0，生成的数据库实体模型都是DbSet\<T\类型

2.默认情下对于数据的访问都是启用模型跟踪

\[csharp\] view plain copy

1. ctx.Confguration.AutoDetectChangesEnabled=true

自动调用DbContext.ChngeTracker.DetectChanges的方法：

DbSet.Find DbSet.Local DbSet.Remove DbSet.Add DbSet.Attach

DbContext.SaveChanges DbContext.GetValidationErrors DbContex.Entry

DbChangeTracker.Entries

3.如果对于需要修改的数据可以使用AsNoTracking（）方法

\[csharp\] view plain copy

1. //

2. // 摘要:

3. // 表示针对 DbContext 的 LINQ to Entiies 查询。

4. //

5. / 类型参数:

6. // TResult:

7. // 要查询的实体的类型。

8. \[SuppressMessage(\"Micrsoft.Naming\",

\"CA110:IdentifiersShouldHaveCorrectSuffix\", Justification

= \"Name is intentional\")\]

9. public class DbQuery\<TResult\> : IOrderedQueryable\<TResult\>,

IQueryable\<TResult\>, IEnumerable\<TRe

sult\>, IOrderedQueryable, IQueryable, IEnumerable, \...\...

10. {

11. //

12. // 摘要:

13. // 返回一个新查询，其中返回的实体将不会在

System.Data.Entity.DbContext 中进行缓存。

14. //

15. // 返回结果:

16. // 应用了 NoTracking 的新查询。

17. public virtual DbQuery\<TResult\> AsNoTracking();

4.特别说明：对于使用AsNoTracking（）的数据不能用于修改。

\[csharp\] view plain copy

1. //AsNoTracking 获取到的数据不能用作修改

2. using (MenuModel \_Context = new MenuModel())

3. {

4. Menu.Menu first = \_Context.Menus.AsNoTracking().First();

5. Console.WriteLine(first.MenuName);



6\. first.MenuName = \"abc\";

7. first.Model.ModelName = \"123\";

8. \_Context.SaveChanges();

9. Console.WriteLine(\_Context.Menus.AsNoTracking().First().MenuName);

10. }

更多：

