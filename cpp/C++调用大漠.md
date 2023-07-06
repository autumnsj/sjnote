#include \"iostream\"\
#include\<windows.h\>\
#include\"stdio.h\"\
#include\"string.h\"\
using std::cout;\
using std::endl;\
using std::cin;\
#import \"dm.dll\" no_namespace\
void f1()\
{\
CoInitialize(NULL);\
IdmsoftPtr dm(\_\_uuidof(dmsoft));\
dm-\>MoveTo(0,0);\
CoUninitialize();\
}\
void main()\
{\
f1();\
char a\[100\]=\"hello\";\
cout\<\<a\<\<endl;\
cin\>\>a;\
}
