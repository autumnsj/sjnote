在VC中混合编译C++与汇编文件

标签： 汇编 c++ 语言 header command build

2010-10-2819:47 4522人阅读 评论(4) 收藏 举报

分类：

General（3）

版权声明：本文为博主原创文章，未经博主允许不得转载。

在VC中使用汇编语言，可以使用内联汇编，也可以编写独立的汇编语言文件放进工程中编译。由于

VC在编译x64目标平台的程序时，不支持内联汇编，因此下面介绍编写独立的汇编语言文件，并加入

VC的工程中进行编译的方。

我们将编写一个小程序，来说明如何进行C语言与汇编语的混合编译。

程序功能很简单：生成a和b两个随机数，并显示a与b的和。其中，a与b求和的操作编写成一个函

数，并用汇编语言实这个函数。

使用VC2010创建一个Win32

Application的工，并在工程中加入3个文件：main.c、add.asm、

add.h，其中，main.c中包含程序的主函数，dd.asm包含加法函数的实现，add.h包含加法函数的定

义。

main.c的内容如下：

\[cpp\] view plain copy

1. #include \<windows.h\>

2. #include \"add.h\"

3.

4. in

5. WIAPI

6. WiMain( HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR

lpCmdine, int nCmdShow )

7. {

8. int a = ;

9. int b = 0;

TCHAR szBuffer\[32\];

11

12. srand(GetTickount());

a = rand()%100;

14.b = rand()%100;

15.

16.wsprintf( szBuffer, TEXT(\"%d + %d = %d\"), a, b, Add_asm(a,b) );

17.

18. if ( sizof(void \*) == 8 )

19. {

MessageBox( NULL, szBuffer, TEXT(\"计算结果 - 64位\"), MB_OK );

}



22\ else if ( sizeof(void \*) == 4 )

23.{

24.MessageBox( NULL, szBuffer, TEXT(\"计算结果 - 32位\"), MB_OK );

25.}

26. else

27. {

28. MessaeBox( NULL, szBuffer, TEXT(\"计算结果\"), MB_OK );

29. }

30.

31. return 0;

32.}

addh的内容如下：

\[cp\] view plain copy

1. ifndef \_ADD_HEADER\_

2. #define \_ADD_HEADER\_

3.

4. #include \<windows.h\>

5.

6. #if defined(\_\_cplusplus)

7. extern \"C\" {

8. #endif

9.

10. DWORD \_\_stdcall Add_asm( DWORD a, DWORD b );

11.

12. #if defined(\_\_cplusplus)

13. }

14. #endi

15.

16. #endif /\* \_ADD_HEADER\_ \*/

add.asm的内容如下：

\[cpp\] view plain copy

1. ifdef X86

2. .386

3. .model stdcall,flat

4. endif

5.

6. option casemap:none

7.

8. public Add_asm

9.

10. .const

11.

12. .code

13.

14. ifdef X86

15.

16. Add_asm proc a:dword,b:dword

17.

18. mov eax, a



19\. add eax, b

20. ret

21.

22. endif

23.

24. ifdef X64

25.

26. Add_asm proc

27. mov rax, rcx

28. add rax, rdx

29. ret

30.

31. endif

32.

33. Add_asm endp

34.

35. end

36.

建立好3个文件之后，我们还需要做如下2个工作：

1. 在Build-\>Configuration Manager中，添加一个x64平台

2.

右键点击add.asm，在弹出菜单中选择Properties，选择X86+Debug的配置，我们需要修改

Custom Build Step-\>General中的两项：

在Command Line中填写ml.exe /c /D\"X86\" /D\"DEBUG\"

/Fo\"\$(IntDir)/\$(InputName).obj\"

\$(InputFileName)

在Outputs中填写\$(IntDir)/\$(InputName).obj

ml.exe是VC提供的x86汇编器，x64汇编器为ml64.exe

/D用来定义宏，对于X64+Release的配置，可以修改为/D\"X64\" /D\"RELEASE\"

这样，一个可以编译的工程就配置好了。运行一下试试？

补充：

幸运的是，我们不需要对每个asm文件都进行上面2的步骤，因为第一次配置后，VC会生成一个编

译规则文件，以后添加asm文件的时候，选择使用这个规则即可

再补充：

刚刚发现VC2008里面，asm文件是自动使用MASM编译的，不过有点问题，于是还是改成使用

Custom Build，由于代码和工程是分别存放的，于是Command

Line变成了这个样子：

cd \$(InputDir)

ml64.exe /c /D\"ARCH_X64\" /D\"CV_DEBUG\"

/Fo\"\$(ProjectDir)\$(IntDir)/\$(InputName).obj\"

\$(InputFileName)



cd \$(ProjectDir)

真难看......

另外记得把asm的头文件设置为Exclude from build=YES

上文有错误，项目为准

C++汇编，混合... .zip

48.24KB

