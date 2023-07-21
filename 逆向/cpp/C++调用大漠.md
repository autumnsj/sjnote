#include \"iostream\"

#include\<windows.h>

#include\"stdio.\"

#include\"strin.h\"

using std:cout;

using std::endl;

using std::cin;

#mport \"dm.dll\" no_namespace

vid f1()

{

CoInitialze(NULL);

IdmsoftPtr dm(\_\_uuidof(dmsoft));

dm-\>MoveTo(0,0);

CoUninitialize();

}

void main()

{

f1();

char a\[100\]=\"hello\";

cout\<\<a\<\<endl;

cin\>\>a;

}

