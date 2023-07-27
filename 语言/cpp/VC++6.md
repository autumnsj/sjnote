VC++6.0中编写Unicode编码的应用程序

听语音

浏览：2554

\

更新：211-04-09 19:44

2

3

4

分步阅读

VC++

6.0支持Unicode编程，但默认的是ANSI，所以开发人员只需要稍微改变一下编写代码的习

惯便可以轻松编写支持NICODE的应用程序。

步骤/方法

使VC++ 6.0进行Unicode编程主要做以下几项工作：

为工程添加UNICODE和_UNICODE预处理选项。

具体步骤：打开\[工程\]-\>\[设置..\]对话框，如图1所示，在C/C++标签对话框的"预处理程序定

义"中去除_MBCS，加上_UNICODE,UNICODE。（注意中间用逗号隔开）改动后如图2：

图一图二



3\.

在没有定义UNICODE和_UNICODE时，所有函数和类型都默认使用ANSI的版本；在定义了

UNICODE和_UNICODE之后，所有的MFC类和Windows API都变成了宽字节版本了。

设置程序入口点

因为MFC应用程序有针对Unicode专用的程序入口点，我们要设置entry

point。否则就会出现连

接错误。

5

设置entry

point的方法是：打开\[工程\]-\>\[设置...\]对话框，在Link页的Output类别的Entry

Point

里填上wWinMainCRTStartup。

图三

