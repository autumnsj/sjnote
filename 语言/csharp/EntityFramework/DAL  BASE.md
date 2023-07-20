/// \<summary\>\
/// Detail: the base operate class on DAL\
/// Create：09/12/2013\
/// Author：Autumn\
///\
/// 1. Autumn 09/15/2013 write note\
/// 2. Jimmy 09/18/2013 count set\
/// \</summary\>\
using log4net;\
using System;\
using System.Collections.Generic;\
using System.Data;\
using System.Data.Entity;\
using System.Data.Entity.Infrastructure;\
using System.Linq;\
using System.Linq.Expressions;\
using System.Text;\
using System.Globalization;\
using System.Threading.Tasks;\
using NN.Info.Model.Models;\
namespace NN.Info.DAL.Common\
{\
public class BaseDal\<T\> where T : class\
{\
private ILog log = LogManager.GetLogger(typeof(BaseDal\<T\>));\
protected NNInfoEntities database = new NNInfoEntities();\
protected DbSet\<T\> dbSet = null;\
public BaseDal()\
{\
dbSet=this.database.Set\<T\>();\
}\
/// \<summary\>\
/// 添加一条记录\
/// \</summary\>

/// \<param name=\"entity\"\>实体\</param\>\
/// \<returns\>是否添加成功\</returns\>\
public virtual bool Add(T entity)\
{\
try\
{\
this.dbSet.Add(entity);\
this.database.SaveChanges();\
}\
catch (Exception e)\
{\
log.Error(e);\
return false;\
}\
return true;\
}\
/// \<summary\>\
/// 添加一条记录返回实体\
/// \</summary\>\
/// \<param name=\"entity\"\>实体\</param\>\
/// \<returns\>是否添加成功\</returns\>\
public virtual T AddAndReturnEntity(T entity)\
{\
try\
{\
T result= this.dbSet.Add(entity);\
this.database.SaveChanges();\
return result;\
}\
catch (Exception e)\
{\
log.Error(e);\
return null;\
}\
}\
/// \<summary\>

/// 添加多条记录\
/// \</summary\>\
/// \<param name=\"entity\"\>实体集\</param\>\
/// \<returns\>是否添加成功\</returns\>\
public virtual bool Add(IEnumerable\<T\> entityList)\
{\
try\
{\
foreach (var entity in entityList)\
{\
this.dbSet.Add(entity);\
}\
this.database.SaveChanges();\
}\
catch (Exception e)\
{\
log.Error(e);\
return false;\
}\
return true;\
}\
/// \<summary\>\
/// 查询\
/// \</summary\>\
/// \<param name=\"where\"\>条件\</param\>\
/// \<returns\>实体集\</returns\>\
public virtual IEnumerable\<T\> GetList(Expression\<Func\<T, bool\>\>
where)\
{\
return this.dbSet.Where(where);\
}\
/// \<summary\>\
/// 查询\
/// \</summary\>\
/// \<param name=\"where\"\>条件\</param\>

/// \<returns\>实体集\</returns\>\
public virtual IEnumerable\<T\> GetList\<TSort\>(Expression\<Func\<T,
bool\>\> where,\
Expression\<Func\<T, TSort\>\> order,bool isAsc=true)\
{\
if (isAsc)\
{\
return this.dbSet.Where(where).OrderBy(order);\
}\
else\
{\
return this.dbSet.Where(where).OrderByDescending(order);\
}\
}\
/// \<summary\>\
/// 最查询结果的第一条记录\
/// \</summary\>\
/// \<param name=\"where\"\>\</param\>\
/// \<returns\>\</returns\>\
public virtual T GetOne(Expression\<Func\<T, bool\>\> where)\
{\
return this.dbSet.Where(where).FirstOrDefault();\
}\
/// \<summary\>\
/// 取得所有实体集合\
/// \</summary\>\
/// \<returns\>\</returns\>\
public virtual IEnumerable\<T\> GetAll()\
{\
return this.dbSet.ToList();\
}\
/// \<summary\>\
/// 跟据主键取记录\
/// \</summary\>\
/// \<param name=\"key\"\>\</param\>\
/// \<returns\>\</returns\>\
public virtual T GetByPrimaryKey(int key)

{\
return this.dbSet.Find(key);\
}\
/// \<summary\>\
/// 删除符合条件的结果。\
/// \</summary\>\
/// \<param name=\"where\"\>条件\</param\>\
/// \<returns\>反回影行数\</returns\>\
public virtual int Remove(Expression\<Func\<T, bool\>\> where)\
{\
int count = 0;\
try\
{\
foreach (T item in this.dbSet.Where\<T\>(where))\
{\
this.dbSet.Remove(item);\
count++;\
}\
this.database.SaveChanges();\
}\
catch (Exception e)\
{\
log.Error(e);\
return -1;\
}\
return count;\
}\
/// \<summary\>\
/// 删除一条记录\
/// \</summary\>\
/// \<param name=\"id\"\>id\</param\>\
/// \<returns\>是否成功\</returns\>\
public virtual bool Remove(int id)\
{

try\
{\
T temp= this.GetByPrimaryKey(id);\
this.dbSet.Remove(temp);\
this.database.SaveChanges();\
}\
catch (Exception e)\
{\
log.Error(e);\
return false;\
}\
return true;\
}\
/// \<summary\>\
/// 获取集合数量\
/// \</summary\>\
/// \<returns\>\</returns\>\
public virtual int Count()\
{\
try\
{\
return this.dbSet.Count();\
}\
catch (Exception ex)\
{\
log.Error(string.Format(CultureInfo.InvariantCulture,
\"获取集合数量异常，{0}\",\
ex.ToString()));\
throw;\
}\
}\
/// \<summary\>\
/// 返回指定序列中满足条件的元素数量。\
/// \</summary\>\
/// \<param name=\"where\"\>条件\</param\>\
/// \<returns\>元素数量\</returns\>\
public virtual int Count(Expression\<Func\<T, bool\>\> where)

{\
try\
{\
return this.dbSet.Count(where);\
}\
catch (Exception e)\
{\
log.Error(e);\
}\
return -1;\
}\
/// \<summary\>\
/// 更新一条记录\
/// \</summary\>\
/// \<param name=\"entity\"\>对象实体\</param\>\
/// \<returns\>是否成功\</returns\>\
public virtual bool Update(T entity)\
{\
try\
{\
this.dbSet.Attach(entity);\
this.database.Entry\<T\>(entity).State = EntityState.Modified;\
database.SaveChanges();\
}\
catch (Exception e)\
{\
log.Error(e);\
return false;\
}\
return true;\
}\
/// \<summary\>\
/// 分页查询\
/// \</summary\>\
/// \<typeparam name=\"TKey\"\>\</typeparam\>\
/// \<param name=\"filter\"\>\</param\>

/// \<param name=\"pageIndex\"\>\</param\>\
/// \<param name=\"pageSize\"\>\</param\>\
/// \<param name=\"sortKeySelector\"\>\</param\>\
/// \<param name=\"isAsc\"\>\</param\>\
/// \<returns\>\</returns\>\
public IEnumerable\<T\> GetList\<TKey\>(Expression\<Func\<T, bool\>\>
filter, int pageIndex,\
int pageSize, Expression\<Func\<T, TKey\>\> sortKeySelector, bool isAsc
= true)\
{\
try\
{\
if (isAsc)\
{\
return this.dbSet\
.Where(filter)\
.OrderBy(sortKeySelector)\
.Skip(pageSize \* (pageIndex - 1))\
.Take(pageSize).AsQueryable();\
}\
else\
{\
return this.dbSet\
.Where(filter)\
.OrderByDescending(sortKeySelector)\
.Skip(pageSize \* (pageIndex - 1))\
.Take(pageSize).AsQueryable();\
}\
}\
catch (Exception e)\
{\
log.Error(e);\
return null;\
}\
}\
public IEnumerable\<T\> Get\<TKey\>(int pageIndex, int pageSize,
Expression\<Func\<T,\
TKey\>\> sortKeySelector, bool isAsc = true)\
{

try\
{\
if (isAsc)\
{\
return this.dbSet\
.OrderBy(sortKeySelector)\
.Skip(pageSize \* (pageIndex - 1))\
.Take(pageSize).AsQueryable();\
}\
else\
{\
return this.dbSet\
.OrderByDescending(sortKeySelector)\
.Skip(pageSize \* (pageIndex - 1))\
.Take(pageSize).AsQueryable();\
}\
}\
catch (Exception e)\
{\
log.Error(e);\
return null;\
}\
}\
/// \<summary\>\
/// 最得最大排序实体\
/// \</summary\>\
/// \<typeparam name=\"Tkey\"\>排序类型\</typeparam\>\
/// \<param name=\"filter\"\>条件\</param\>\
/// \<param name=\"sortKeySelector\"\>排序字段\</param\>\
/// \<returns\>实体\</returns\>\
public virtual T GetMaxSortEntity\<Tkey\>(Expression\<Func\<T, bool\>\>
filter,\
Expression\<Func\<T, Tkey\>\> sortKeySelector)\
{\
return
this.dbSet.Where(filter).OrderByDescending(sortKeySelector).FirstOrDefault();\
}\
/// \<summary\>

/// 最得最小排序实体\
/// \</summary\>\
/// \<typeparam name=\"Tkey\"\>排序类型\</typeparam\>\
/// \<param name=\"filter\"\>条件\</param\>\
/// \<param name=\"sortKeySelector\"\>排序字段\</param\>\
/// \<returns\>实体\</returns\>\
public virtual T GetMinSortEntity\<Tkey\>(Expression\<Func\<T, bool\>\>
filter,\
Expression\<Func\<T, Tkey\>\> sortKeySelector)\
{\
return
this.dbSet.Where(filter).OrderBy(sortKeySelector).FirstOrDefault();\
}\
/// \<summary\>\
/// 批量修改\
/// \</summary\>\
/// \<param name=\"entity\"\>实体集\</param\>\
/// \<returns\>是否成功\</returns\>\
public virtual bool UpdateList(IEnumerable\<T\> entity)\
{\
try\
{\
foreach (var item in entity)\
{\
this.dbSet.Attach(item);\
this.database.Entry\<T\>(item).State = EntityState.Modified;\
}\
database.SaveChanges();\
}\
catch (Exception e)\
{\
log.Error(e);\
return false;\
}\
return true;\
}\
}\
}
