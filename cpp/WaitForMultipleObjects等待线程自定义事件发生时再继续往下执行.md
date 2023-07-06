1 // ConsoleApplication3.cpp : 此文件包含 \"main\"
函数。程序执行将在此处开始并结束。\
2 //\
3\
4 #include \"pch.h\"\
5 #include \<iostream\>\
6\
7\
8\
9 // 运行程序: Ctrl + F5 或调试 \>"开始执行(不调试)"菜单\
10 // 调试程序: F5 或调试 \>"开始调试"菜单\
11\
12 // 入门提示:\
13 // 1. 使用解决方案资源管理器窗口添加/管理文件\
14 // 2. 使用团队资源管理器窗口连接到源代码管理\
15 // 3. 使用输出窗口查看生成输出和其他消息\
16 // 4. 使用错误列表窗口查看错误\
17 // 5.
转到"项目"\>"添加新项"以创建新的代码文件，或转到"项目"\>"添加现有项"以将现有代码文件添加\
到项目\
18 // 6. 将来，若要再次打开此项目，请转到"文件"\>"打开"\>"项目"并选择
.sln 文件\
19 #include \<windows.h\>\
20 #include \<stdio.h\>\
21\
22 HANDLE ghEvents\[2\];\
23\
24 DWORD WINAPI ThreadProc(LPVOID);\
25\
26 int main(void)\
27 {\
28 HANDLE hThread;\
29 DWORD i, dwEvent, dwThreadID;\
30\
31 // Create two event objects\
32\
33 for (i = 0; i \< 2; i++)\
34 {\
35 ghEvents\[i\] = CreateEvent(\
36 NULL, // default security attributes\
37 FALSE, // auto-reset event object

38 FALSE, // initial state is nonsignaled\
39 NULL); // unnamed object\
40\
41 if (ghEvents\[i\] == NULL)\
42 {\
43 printf(\"CreateEvent error: %d\\n\", GetLastError());\
44 ExitProcess(0);\
45 }\
46 }\
47\
48 // Create a thread\
49\
50 hThread = CreateThread(\
51 NULL, // default security attributes\
52 0, // default stack size\
53 (LPTHREAD_START_ROUTINE)ThreadProc,\
54 NULL, // no thread function arguments\
55 0, // default creation flags\
56 &dwThreadID); // receive thread identifier\
57\
58 if (hThread == NULL)\
59 {\
60 printf(\"CreateThread error: %d\\n\", GetLastError());\
61 return 1;\
62 }\
63\
64 // Wait for the thread to signal one of the event objects\
65\
66 dwEvent = WaitForMultipleObjects(\
67 2, // number of objects in array\
68 ghEvents, // array of objects\
69 FALSE, // wait for any object\
70 6000); // five-second wait\
71\
72 // The return value indicates which event is signaled\
73\
74 switch (dwEvent)\
75 {\
76 // ghEvents\[0\] was signaled\
77 case WAIT_OBJECT_0 + 0:

78 // TODO: Perform tasks required by this event\
79 printf(\"First event was signaled.\\n\");\
80 break;\
81\
82 // ghEvents\[1\] was signaled\
83 case WAIT_OBJECT_0 + 1:\
84 // TODO: Perform tasks required by this event\
85 printf(\"Second event was signaled.\\n\");\
86 break;\
87\
88 case WAIT_TIMEOUT:\
89 printf(\"Wait timed out.\\n\");\
90 break;\
91\
92 // Return value is invalid.\
93 default:\
94 printf(\"Wait error: %d\\n\", GetLastError());\
95 ExitProcess(0);\
96 }\
97\
98 // Close event handles\
99\
100 for (i = 0; i \< 2; i++)\
101 CloseHandle(ghEvents\[i\]);\
102\
103 return 0;\
104 }\
105\
106 DWORD WINAPI ThreadProc(LPVOID lpParam)\
107 {\
108\
109 // lpParam not used in this example\
110 UNREFERENCED_PARAMETER(lpParam);\
111\
112 // Set one event to the signaled state\
113 printf(\"ThreadProc\\n \");\
114 Sleep(5000);\
115 if (!SetEvent(ghEvents\[1\]))\
116 {

117 printf(\"SetEvent failed (%d)\\n\", GetLastError());\
118 return 1;\
119 }\
120 return 0;\
121 }
