// ConsoleApplication3.cpp : 此文件包含 \"main\"

函数。程执行将在此处开始并结束。

//

3

4#include \"pch.h\"

#include \<iostream\>

6

7

8

// 运行程序: Ctrl + F5 或调试 \>"开始执行(不调试)"菜单

// 调试程序: F5 或调试 \>"开始调试"菜单

11

12// 入门提示:

13// 1. 使用解决方案资源管理器窗口添加/管理文件

14// 2. 使用团队资源管理器窗口连接到源代码管理

/ 3. 使用输出窗口查看生成输出和其他消息

// 4. 使用错误列表窗口查看错误

// 5.

转到"项目"\>"添加新项"以创建新的代码文件，或转到项目"\>"添加现有项"以将现有代码文件添加

到项目

// 6. 将来，若要再次打开此项目，请转到"文件"\>"打开"\>"项目"并选择

.sln 文件

19#include \<windows.h\>

#nclude \<stdio.h\>

21

HNDLE ghEvents\[2\];

23

DWORD WINAPI ThreadProcLPVOID);

25

int main(void)

{

HANDLE hThread;

DWORD i, dwEvent, dwThreadID;

30

// Create two event objects

32

for (i = 0; i \< 2; i++)

{

ghEvents\[i\] = CreateEvent(

NULL, // defaultsecurity attributes

FALSE, // auto-reset event obect



FALSE, // initial state is nonsignaled

39NULL); // unnamed object

40

if (ghEvents\[i\] == NULL)

42{

printf(\"CreateEvent error: %d\n\", GetLastError());

44ExitProcess(0);

}

}

47

48// Create a thread

49

hThread = reateThread(

ULL, // default security attributes

0,// default stack size

(LPTHREAD_START_ROUTINE)ThreadProc,

ULL, // no thread function arguments

0, // default creation flags

&dwThreadID); // receive threa identifier

57

if (hThrea == NULL)

{

printf(\"CreateThread error: %d\\n\", GetLastError());

return 1;

}

63

// Wait for the thread to signal one of the event objects

65

dwEvent = WaitForMultipleObjects(

2, // number of objects in array

ghEvents, // array of objects

FALSE, // wait for any object

6000); // five-second wait

71

// The return value indicates which event is signaled

73

switch (dwEvent)

{

// ghEvents\[0\] was signaled

case WAIT_OBJECT_0 + 0:



// TODO: Perform tasks required by this event

printf(\"First event was signaled.\\n\");

break;

81

// ghEvents\[1\] was signaled

case WAIT_OBJECT_0 + 1:

// TODO: Perform tasks required by this event

printf(\"Second event was signaled.\\n\");

break;

87

case WAIT_TIMEOUT:

printf(\"Wait timed out.\\n\");

break;

91

// Return value is invalid.

default:

printf(\"Wait error: %d\\n\", GetLastError());

ExitProcess(0);

}

97

// Close event handles

99

100 for (i = 0; i \< 2; i++)

101 CloseHandle(ghEvents\[i\]);

102

103 return 0;

104 }

105

106 DWORD WINAPI ThreadProc(LPVOID lpParam)

107 {

108

109 // lpParam not used in this example

110 UNREFERENCED_PARAMETER(lpParam);

111

112 // Set one event to the signaled state

113 printf(\"ThreadProc\\n \");

114 Sleep(5000);

115 if (!SetEvent(ghEvents\[1\]))

116 {



117 printf(\"SetEvent failed (%d)\\n\", GetLastError());

118 return 1;

119 }

120 return 0;

121 }

