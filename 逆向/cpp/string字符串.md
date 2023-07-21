之所以抛弃char\*的字符串而选用C++标准程序库中的string类，是因为他和前者比较起来，不必担心

内存是否足够、字符串长度等等，而且作为一个类出现，他集成的操作函数足以完成我们大多数情况

下(甚至是100%)的需要。我们可以用 = 进行赋操作，== 进行比较，+

做串联（是不是很简

单?）。我们尽可以把它看成是C++的基本数据类型。

好了，进入正题........

首先，为了在我们的程序中使用string类型，我们必须包含头文件

\<string\>。如下：

#include \<string\> //注意这里不是string. string.h是C字符串头文件

1．声明一个C++字符串

声明一个字符串变量很简单：

string Str;

这样我们就声明了一个字符串变量，但既然是一个类，就有构造函数析构函数。上面的声明没有传

入参数，所以就直接使用了string的默认的构造函数，这个函数所作的就是把Str初始化为一个空字符

串。String类的构造函数和析构函数如下：

a) strings; //生成一个空字符串s

b) string s(str) //拷贝构函数 生成str的复制品

c) string s(str,stridx

//将字符串str内"始于位置strdx"的部分当作字符串的初值

d) string s(str,strdx,strlen)

//将字符串str内"始stridx且长度顶多strlen"的部分作为字符串的

初值

e) string s(cstr) //将C字符串作为s初值

f) string s(chars,chars_len)

//将C字符串前chars_len个字符作为字串s的初值。

g) string s(num,c) //成一个字符串，包含num个c字符

h) string s(beg,end)

//以区间beg;end(不包含end)内的符作为字符串s的初值

i) s.\~string() //销毁所有字符，释放内存

都很简单，我就不解释了。

2．字符串操作函数

这里是C++字符串的重点，我先把各种操作函数罗列出来，不喜欢把所有函数都看完的人可以在这

里找自己喜欢的函数，再到后面看他的详细解释。

a) =,assign() //赋以新值

b) swap() //交换两个字符串的内容

c) +=,append(),push_back() /在尾部添加字符

d) insert() //插入字符

e) erase() //删除字符

f) clear() //删除全部字符

g) replace() //替换字符

h) + //串联字符串

i) ==,!=,\<,\<=,\>,\>=,compare() //比较字符串

j) size(),length() //返回字符数量



k\) max_size() //返回字符的可能最大个数

l) empt() //判断字符串是否为空

m) capacity() //返回重新分配之前的字符容量

n) reserve() //保留一定量内存以容纳一定数量的字符

o) \[ \], at() //存取单一字符

p) \>\>,getline() //从tream读取某值

q) \<\< //将谋值写入tream

r) copy() //将某值赋值为一个C_string

s) c_str() //将内容以C_string返回

t) data() //将内容以字符数组形式返回

u) substr() //返某个子字符串

v)查找函数

w)begin() end() //提供类似STL的迭代器支持

x) rbegin() rend() //逆向迭代器

y) get_allocator() //返回配置器

下面详细介绍：

2．1 C++字串和C字符串的转换

C

++提供的由C++字符串得到对应的C_string的方法是使data()、c_str()和copy()，其中，

data()以字符数组的形式返回字符内容，但并不添加'\\0'。c_str()返回一个以'\\0'结尾的字符数

组，而copy()则把字符串的内容复制或写入既有的c_string或字符数组内。C++字符串并不以'\\0'结

尾。我的建议是在程序中能使用C++字符串就使用，除非万不得已不选用c_string。由于是简单介

绍，详细介绍掠过谁想进一步了解使用中的注意事项可以给我留言(到我的收件箱)。我详细解释。

2．2 大小和容量函数

一个C++字符串存在三种大小：a)现有的字符数，函数是size()和length()，他们等效。Empty(用

来检查字符串是否为空。b)max_sie()

这个大小是指当前C++字符串最多能包含的字符数，很可能和

机器本身的限制或者字符串所在位置连续内存的大小有关系。我们一般情况下不用关心他，应该大小

足够我们用的。但是不够用的话，会抛出length_error异常c)capacity()重新分配内存之前

string所能

包含的最大字符数。这里另一个要指出的是reserve()函数，这个函数为string重新分配内存。重新

分配的大小由其参数决定，默参数为0，这时候会对string进行非强制性缩减。

还有必要再重复一下C++字符串和C字符串转换的问题，许多人会遇到这样的问题，自己做程序要调

用别人的函数、类什么的（比如数据库连接函数Connect(har\*,char\*)），但别人的函数参数用的是

char\*形式的，而我们知道，_str()、data()返回的字符数组由该字符串拥有，所以是一种const

char\*,

要想作为上面提及的函数的参数，还必须拷贝到一char\*,而我们的原则是能不使用C字符串就不使

用。那么，这时候我们的处理方式是：如果此函数对参数(也就是char\*)的内容不修改的话，我们可以

这样Connect((char\*)UserID.c_str(),

(char\*)PassWD.c_str()),但是这时候是存在危险的，因为这样转换

后的字符串其实是可以修改的（有兴趣地可以自己试一试），所以我强调除非函数调用的时候不对参

数进行修改，否则必须拷贝到一个char\*上去。当然，更稳妥的办法是无论什么情况都拷贝到一个



char\*上去。同时我们也祈祷在仍然使用C字符串进行编程的高手们（说他们是高手一点儿也不为

过，也许在我们还穿开裆裤的时候他们就开始编程了，哈哈..）写的函数都比较规范，那样我们就不必

进行强制转换了。

2．3元素存取

我们可以使用下标操作符\[\]和函数at()对元素包的字符进行访问。但是应该注意的是操作符\[\]并不

检查索引是否有效（效索引0\~str.length()），如果索引失效，会引起未定义的行为。而at()会检

查，如果使用 at()的时候索引无效，会抛出ut_of_range异常。

有一个例外不得不，const string

a;的操作符[\]对索引值是a.length()仍然有效，其返回值

是'\\0'。其他的各种情况，.length()索引都是无效的。举例如下：

const string Cstr("onst string");

string Str("string");

Str\[3\]; //ok

Str.at(3); //ok

Str\[100\]; //未定义的行为

Str.at(100); //throw out_of_range

Str\[Str.length()\] //未定义行为

Cstr\[Cstr.length()\] //返回 '\\0'

Str.at(Str.length());//throw out_of_range

Cstr.at(Cstr.length()) ////throw out_of_range

我不赞成类似于下面的引用或指针赋值：

char& r=s\[2\];

char\* p= &s\[3\];

因为一旦发生重新分配，r,p立即失效。避免的方法就是不使用。

2．4比较函数

C

++字符串支持常见的比较操作符（\>,\>=,\<,\<=,==,!=），甚至支持string与C-string的比较(如

str\<"hello")。在使用\>,\>=,\<,\<=这些操作符的时候是根据"当前字符特性"将字符按字典顺序进行

逐一得比较。字典排序靠前的字符小，比较的顺序是从前向后比较，遇到不相等的字符就按这个位置

上的两个字符的比较结果确定两个字符串的大小。同时，string ("aaaa")

\<string(aaaaa)。

另一个功能强大的比较函数是成员函数compare()。他支持多参数处理，支持用索引值和长度定位

子串来进行比较。他返回一个整数来表示比较结果，返回值意义如下：0-相等〉0-大于

\<0-小于。举

例如下：

string s("abcd");

s.compare("abcd"); //返回0

s.compare("dcba"); //返回一个小于0的值

s.compare("ab"); //返回大于0的值

s.compare(s); //相等

s.compare(0,2,s,2,2); //用"ab"和"cd"进行比较小于零



s.compare(1,2,"bcx",2); //用"bc"和"bc"比较。

怎么样？功能够全的吧！什么？还不能满足你的胃口？好吧，那等着，后面有更个性化的比较算法。

先给个提示，使用的是STL的比较算法。什么？对STL一窍不通？靠，你重修吧！

2．5 更改内容

这在字符串的操作中占了很大一部分。

首先讲赋值，第一个赋值方法当然是使用操作符=，新值可以是string(如：s=ns)

、c_string(如：

s="gaint")甚至单一字符（如：s='j'）。还可以使用成员函数assign()，这个成员函数可以使你

更灵活的对字符串赋值。还是举例说明吧：

s.assign(str); //不说

s.assign(str,1,3);//如果str是"iamangel" 就是把"ama"赋给字符串

s.assign(str,2,string::npos);//把字符串str从索引值2开始到结尾赋给s

s.assign("gaint"); //不说

s.assign("nico",5);//把'n' 'I' 'c' 'o' '\\0'赋给字符串

s.assign(5,'x');//把五个x赋给字符串

把字符串清空的方法有三个：s="";s.clear();s.erase();(我越来越觉得举例比说话让别人容易懂！)。

string提供了很多函数用于插入（insert）、删除（erase）、替换（replace）、增加字符。

先说增加字符（这里说的增加是在尾巴上），函数有

+=、append()、push_back()。举例如下：

s+=str;//加个字符串

s+="my name is jiayp";//加个C字符串

s+='a';//加个字符

s.append(str);

s.append(str,1,3);//不解释了同前面的函数参数assign的解释

s.append(str,2,string::npos)//不解释了

s.append("my name is jiayp");

s.append("nico",5);

s.append(5,'x');

s.push_back('a');//这个函数只能增加单个字符对STL熟悉的理解起来很简单

也许你需要在string中间的某个位置插入字符串，这时候你可以用insert()函数，这个函数需要你指定

一个安插位置的索引，被插入的字符串将放在这个索引的后面。

s.insert(0,"my name");

s.insert(1,str);

这种形式的insert()函数不支持传入单个字符，这时的单个字符必须写成字符串形式(让人恶心)。既然

你觉得恶心，那就不得不继续读下面一段话：为了插入单个字符，insert()函数提供了两个对插入单个

字符操作的重载函数：insert(size_type index,size_type num,chart

c)和insert(iterator

pos,size_type num,chart

c)。其中size_type是无符号整数，iterator是char\*,所以，你这么调用

insert函数是不行的：insert(0,1,

'j');这时候第一个参数将转换成哪一个呢？所以你必须这么写：



insert((string::size_type)0,1,'j')！第二种形式指出了使用迭代器安插字符的形式，在后面会提及。

顺便提一下，string有很多操作是使用STL的迭代器的，他也尽量做得和STL靠近。

删除函数erase()的形式也有好几种（真烦！），替换函数replace()也有好几个。举例吧：

string s="il8n";

s.replace(1,2,"nternationalizatio");//从索引1开始的2个替换成后面的C_string

s.erase(13);//从索引13开始往后全删除

s.erase(7,5);//从索引7开始往后删5个

2．6提取子串和字符串连接

题取子串的函数是：substr(),形式如下：

s.substr();//返回s的全部内容

s.substr(11);//从索引11往后的子串

s.substr(5,6);//从索引5开始6个字符

把两个字符串结合起来的函数是+。（谁不明白请致电120）

2．7输入输出操作

1．\>\> 从输入流读取一个string。

2．\<\< 把一个string写入输出流。

另一个函数就是getline(),他从输入流读取一行内容，直到遇到分行符或到了文件尾。

2．8搜索与查找

查找函数很多，功能也很强大，包括了：

find()

rfind()

find_first_of()

find_last_of()

find_first_not_of()

find_last_not_of()

这些函数返回符合搜索条件的字符区间内的第一个字符的索引，没找到目标就返回npos。所有的函数

的参数说明如下：

第一个参数是被搜寻的对象。第二个参数（可有可无）指出string内的搜寻起点索引，第三个参数（可

有可无）指出搜寻的字符个数。比较简单，不多说不理解的可以向我提出，我再仔细的解答。当然，

更加强大的STL搜寻在后面会有提及。

最后再说说npos的含义，string::npos的类型是string::size_type,所以，一旦需要把一个索引与npos

相比，这个索引值必须是string::size)type类型的，更多的情况下，我们可以直接把函数和npos进行比

较（如：if(s.find("jia")== string::npos)）。

