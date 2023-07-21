#include \<windows.h\> #include \<iostream\> //#include

\"..\\\\DLLDmo1\\\\MyCode.h\" using namespace std; #pragma

comment(li,

\"..\\\debug\\\\DLLDemo1.lib\") extern \"C\" \_declspec(dllimport) int

Add(int a,

int b); in main(int argc, char \*argv\[\]) { cout\<\<Add(2, 3)\<\<endl;

return

0; }

动态加载调用，无需lib

typedef BOOL (\_\_stdcall \*autumn)(const char \* ,const char \*

);定义函数指针类型

HINSTANCE

hinstLib=LoadLibrary(\"F:\\\\work\\\\VCMiniProject\\\\SZ\\\\DLL\\\\Debug\\\\SZ.DLL\");

//autumn procAddress2 =

(autumn)GetProcAddress(hinstLib,\"FindWindow\");//直接用函数名字

//autumn procAddress2 =

(autumn)GetProcAddress(hinstLib,MAKEINTRESOURCE(1));//或者用

序号

procAddress2(\"fuck11\",NULL);

