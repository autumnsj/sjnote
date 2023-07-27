CString,string,char\*之间的转换（转）

这三种类型各有各的优点，比如CString比较灵活，是基于MFC常用的类型，安全性也最高，但可移植性最差。string使

用STL时必不可少的类型，所以是做工程时必须熟练掌握的；cha\*是从学习C语言开始就已经和我们形影不离的了，有许多

API都是以char\*作为参数输入的。所以熟练掌握三者之间的转换十分必要。

以下我用简单的图示指出三者之间的关系，并以标号对应转换的方法。

string to CString

CString.format(\"%s",string.c_str());

CString to string

string str(CString.GetBuffer(sr.GetLength()));

string to char\*

char \*p=string.c_str();

char \* to string

strig str(char\*);

CString to char \*

strcpy(char,CString,sizeof(char));

char \* to CString

CString.format(\"s\",char\*);

CString的format方法是非常好用的。string的_str()也是非常常用的，但要注意和char

\*转换时，要把char定义成为

const char\*，这样是最安全。

以上函数UNICODE编码也没问题：unicode下照用，加个_T()宏就了,像这样子_T(\"%s\")

补充：

CString 可能是 CStringW/CStringA，在与 string 转换时，如果是

CStringW，还涉及编码转换问题。下面以 CStringA

来说明。

string to CString

CString.format(\"%s\",string.c_str());

CStringA = string.c_str() 就可以了



CString to string

string str(CString.GetBuffer(str.GetLength()));

GetBuffer 有参数的话，可能导致内部的分配空间动作，要进行后续

ReleaseBuffer 操作。

string = CStringA

string = CStringA.GetBuffer();

string to char \*

char \*p=string.c_str();

char \* to string

string str(char\*);

CString to char \*

strcpy(char \*,CString,sizeof(char));

按照 3 风格，这里应该 char \* = CStringA; 或者 char \*p =

CStringA.GetBuffer();

char \* to CString

CStringA = char \* 就可以了

