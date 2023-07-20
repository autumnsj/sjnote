using Newtonsoft.Json;\
using Newtonsoft.Json.Converters;\
using Newtonsoft.Json.Linq;\
using System.Collections.Generic;\
using System.Data;\
namespace ZKSOFT.Util.Extensions\
{\
/// \<summary\>\
/// 反序列化\
/// \</summary\>\
/// \<param name=\"type\"\>类型\</param\>\
/// \<param name=\"xml\"\>XML字符串\</param\>\
/// \<returns\>\</returns\>\
public static T XMLDeserialize\<T\>(this string xml)\
{\
try\
{\
using (StringReader sr = new StringReader(xml))\
{\
XmlSerializer xmldes = new XmlSerializer(typeof(T));\
return (T)xmldes.Deserialize(sr);\
}\
}\
catch (Exception e)\
{\
return default(T);\
}\
}\
#endregion\
#region 序列化\
/// \<summary\>\
/// 序列化\
/// \</summary\>\
/// \<param name=\"type\"\>类型\</param\>\
/// \<param name=\"obj\"\>对象\</param\>\
/// \<returns\>\</returns\>\
public static string XMLSerializer(this object obj)\
{\
MemoryStream Stream = new MemoryStream();\
XmlSerializer xml = new XmlSerializer((obj).GetType());\
try\
{\
//序列化对象\
xml.Serialize(Stream, obj);\
}\
catch (InvalidOperationException)

{\
throw;\
}\
Stream.Position = 0;\
StreamReader sr = new StreamReader(Stream);\
string str = sr.ReadToEnd();\
sr.Dispose();\
Stream.Dispose();\
return str;\
}\
/// \<summary\>\
/// Copyright (c) ZKSOFT 2019\
/// 创建人：Cunbo.Rynn\
/// 日 期：2019.08.01\
/// 描 述：扩展.json序列反序列化\
/// \</summary\>\
public static partial class Extensions\
{\
/// \<summary\>\
/// 转成json对象\
/// \</summary\>\
/// \<param name=\"Json\"\>json字串\</param\>\
/// \<returns\>\</returns\>\
public static object ToJson(this string Json)\
{\
return Json == null ? null : JsonConvert.DeserializeObject(Json);\
}\
/// \<summary\>\
/// 转成json字串\
/// \</summary\>\
/// \<param name=\"obj\"\>对象\</param\>\
/// \<returns\>\</returns\>\
public static string ToJson(this object obj)\
{\
if (obj is DataTable)\
{\
System.Collections.ArrayList dic = new System.Collections.ArrayList();\
foreach (DataRow dr in ((DataTable)obj).Rows)\
{

System.Collections.Generic.Dictionary\<string, object\> drow = new\
System.Collections.Generic.Dictionary\<string, object\>();\
foreach (DataColumn dc in ((DataTable)obj).Columns)\
{\
drow.Add(dc.ColumnName, dr\[dc.ColumnName\]);\
}\
dic.Add(drow);\
}\
//序列化\
obj = dic;\
}\
var timeConverter = new IsoDateTimeConverter { DateTimeFormat =
\"yyyy-MM-dd\
HH:mm:ss\" };\
return JsonConvert.SerializeObject(obj, timeConverter);\
}\
/// \<summary\>\
/// 转成json字串\
/// \</summary\>\
/// \<param name=\"obj\"\>对象\</param\>\
/// \<param name=\"datetimeformats\"\>时间格式化\</param\>\
/// \<returns\>\</returns\>\
public static string ToJson(this object obj, string datetimeformats)\
{\
var timeConverter = new IsoDateTimeConverter { DateTimeFormat =
datetimeformats };\
return JsonConvert.SerializeObject(obj, timeConverter);\
}\
/// \<summary\>\
/// 字串反序列化成指定对象实体\
/// \</summary\>\
/// \<typeparam name=\"T\"\>实体类型\</typeparam\>\
/// \<param name=\"Json\"\>字串\</param\>\
/// \<returns\>\</returns\>\
public static T ToObject\<T\>(this string Json)\
{\
return Json == null ? default(T) :
JsonConvert.DeserializeObject\<T\>(Json);\
}\
/// \<summary\>

/// 字串反序列化成指定对象实体(列表)\
/// \</summary\>\
/// \<typeparam name=\"T\"\>实体类型\</typeparam\>\
/// \<param name=\"Json\"\>字串\</param\>\
/// \<returns\>\</returns\>\
public static List\<T\> ToList\<T\>(this string Json)\
{\
return Json == null ? null :
JsonConvert.DeserializeObject\<List\<T\>\>(Json);\
}\
/// \<summary\>\
/// 字串反序列化成DataTable\
/// \</summary\>\
/// \<param name=\"Json\"\>字串\</param\>\
/// \<returns\>\</returns\>\
public static DataTable ToTable(this string Json)\
{\
return Json == null ? null :
JsonConvert.DeserializeObject\<DataTable\>(Json);\
}\
/// \<summary\>\
/// 字串反序列化成linq对象\
/// \</summary\>\
/// \<param name=\"Json\"\>字串\</param\>\
/// \<returns\>\</returns\>\
public static JObject ToJObject(this string Json)\
{\
return Json == null ? JObject.Parse(\"{}\") :
JObject.Parse(Json.Replace(\"&nbsp;\", \"\"));\
}\
}\
}
