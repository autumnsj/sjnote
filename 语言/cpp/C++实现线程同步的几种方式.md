C++实现线程同步的几种方式

线程同步是指同一进程中的多个线程互相协调工作从而达到一致性。之所以需要线程同步，是为多个线程同时对一个数据对象进

行修改操作时，可能会对数据造成破坏，下面是个线程同时修改同一数据造成破坏的例子：

#include \<thread> 2 #include \<iostream\> 3 4 void Fun_1(unsigned

int &counter); 5 void

Fun_2(unsigned int &counter);  7 int main() 8 { 9 unsigned int counter

= 0; 10 std::thread

thrd_1(Fun_1, counter); 11 std::thred thrd_2(Fun_2, counter); 12

thrd_1.join(); 13 thrd_2.join();

system(\"pause\"); 15 return 0; 16 } 17 18 void Fun_1(unsigned int

&counter) 19 { 20 while (true)

{ 22 ++counter; 23 if (counter \< 1000) 24 { 25 std::cout \<\<

\"Function 1 counting \" \<\< counter \<\<

\"\...\\n\"; 26 } 27 else 28 { 29 break; 30 } 31 } 32 } 33 34 void

Fun_2(unsigned int &counter) 35 { 36

while (true) 37 { 38 ++counter; 39 if (counter \< 1000) 40 { 41

std::cout \<\< \"Function 2 counting \"

\<\< counter \<\< \"\...\\n\"; 42 } 43 else 44 { 45 break; 46 } 47 } 48

}

运行结果如图所示：

显然输出的结果存在问题，变量并没有按顺序递增，所以线程同步很重要的。在这里记录三种线程同步的方式：

①使用C++标准库的thread、mutex头文件：

#include \<thread\> 2 #include \<mutex\> 3 #include \<iostream\>  5

void Fun_1(); 6 void un_2(); 7 8

unsigned int counter = ; 9 std::mutex mtx; 10 11 int main() 12 { 13

std::thread thrd1(Fun_1); 14

std::thread thrd_2(Fun_2); 15 thrd_.join(); 16 thrd_2.join(); 17

system(\"pause\"); 18 return 0;19

} 20 21 void Fu_1() 22 { 23 while (true) 24 { 25

std::lock_guard\<std::mutex\> mtx_locker(mtx); 26

++counter; 27 if (counter \< 1000) 28 { 29 std::cout \<\< \"Function 1

counting \" \<\< counter \<\<

\"\...\\n\"; 30 } 31 else 32 { 33 break; 34 } 35 } 36 } 37 38 void

Fun_2() 39 { 40 while (true) 41 { 42

std::lock_guard\<std::mutex\> mtx_locker(mtx); 43 ++counter; 44 if

(counter \< 1000) 45 { 46 std::cout

\<\< \"Function 2 counting " \<\< counter \<\< \"\...\\n\"; 47 } 48

else 49 { 50 break; 51 } 52 } 53 }



这段代码与前面一段代码唯一的区别就是在两个线程关联的函数加了一句

std::lock_guar\<std::mutex\>

mtx_locker(mtx);

在C++中，通过构造std::mutex的实例来创建互斥元，可通过调用其成员函数lock()和ulock()来实现加锁和解

锁，然后这是不推荐的做法，因为这要求程序员在离开函数的每条代码路径上都调用unloc()，包括由于异常所导致的在内。作为替

代，标准库提供了std::lock_guard类模板，实现了互斥元的RAII惯用语法（资源获取即初始化）。该对象在构造时锁定所给的互斥

元，析构时解锁该互斥元，从而保证被锁定的互斥元始终被正确解锁。代码运行结果如下图所示，可见得到了正确的结果。

②使用windows API的临界区对象：

//header.h 2 #ifndef CRTC_SEC_H 3 #define RTC_SEC_H 4 5 #include

\"windows.h\"  7 class

RAII_CrtcSec 8 { 9 private: 10 CRITICAL_SECION crtc_sec; 11 public: 12

RAII_CrtcSec() 

::InitializeCriticalSection(&crtc_sec); } 13 \~RAII_CrtcSec() {

::DeleteCriticalSection(&crtc_sc);

} 14 RAII_CrtcSec(const AII_CrtcSec &) = delete; 15 RAII_CrtcSec &

operator=(const RAII_CrtcSec &)

= delete; 16 // 17 void Lock()  ::EnterCriticalSection(&crtc_sec); } 18

void Unlock() {

::LeaveCriticalSection(&crtc_sec); }19 }; 20 21 #endif

//main.cpp 2 #include \<widows.h\> 3 #include \<iostream\> 4 #include

\"header.h\" 5 6 DWORD WINAP

Fun_1(LPVOID p); 7 DWORD WINAPI Fun_2(LVOID p); 8 9 unsigned int

counter = 0; 10 RAII_CrtcSec c;

12 int main() 13 { 14 HANDLE h1,h2; 15 h1 = CreateThread(nullptr, 0,

Fun_1, nullptr, 0, 0); 16

std::cout \<\< \"Thread  started\...\\n\"; 17 h2 =

CreateThread(nulptr, 0, Fun_2, nullptr, 0, 0); 18

std::cout \<\< \"Thread 2 starte\...\\n\"; 19 CloseHandle(h1); 20

ClseHandle(h2); 21 // 22

system(\"pause\"); 23 return 0; 24 } 25 26 DWORD WINAPI Fu_1(LPVOID p)

{ 28 while (true) 29 { 30



cs.Lock(); 31 ++counter; 32 if (couter \< 1000) 33 { 34 std::cout \<\<

\"Thread 1 counting \" \<\<

counter \<\< \"\...\\n\";35 cs.Unlock(); 36 } 37 else 38 { 39

cs.Ulock(); 40 break; 41 } 42 } 43 return

0; 44 } 45 46 DWORD WINAPI Fun_2(LPVOID p) 47 { 48 while (true) 49 { 50

cs.Lock(); 51 ++counter; 52

if (counter \< 1000) 53 { 54 std::cout \<\< \"Thread 2 counting \" \<\<

counter \<\< \"\...\\n\"; 55

cs.Unlock(); 56 } 57 else 58 { 59 cs.Unlock(); 60 break; 61 } 62 } 63

return 0; 64 }

上面的代码使用了windows提供的API中的临界区对象来实现线程同步。临界区是指一个访问共享资源的代码段，临界区对象则是

指当用户使用某个线程访问共享资源时，必须使代码段独占该资源，不允许其他线程访问该资源。在该线程访问完资源后，其他线程才

能对资源进行访问。Windows

API提供了临界区对象的结构体CRITICAL_SECTION，对该对象的使用可总结为如下几步：

1.InitializeCriticalSection(LPCRITICAL_SECTION

lpCriticalSection)，该函数的作用是初始化临界区，唯一的参数是指向结

构体CRITICAL_SECTION的指针变量。

2.EnterCriticalSection(LPCRTICAL_SECTION

lpCriticalSection)，该函数的作用是使调用该函数的线程进入已经初始化的临

界区，并拥有该临界区的所有权。这是一个阻塞函数，如果线程获得临界区的所有权成功，则该函数将返回，调用线程继续执行，否则

该函数将一直等待，这样会造成该函数的调用线程也一直等待。如果不想让调用线程等待（非阻塞），则应该使用

TryEnterCriticalSection(LPCRITICAL_SECTION lpCriticalSection)。

3.LeaveCriticalSection(LPCRITICAL_SECTION

lpCriticalSection)，该函数的作用是使调用该函数的线程离开临界区并释放对

该临界区的所有权，以便让其他线程也获得访问该共享资源的机会。一定要在程序不适用临界区时调用该函数释放临界区所有权，否则

程序将一直等待造成程序假死。

4.DeleteCriticalSection(LPCRITICAL_SECTION

lpCriticalSection)，该函数的作用是删除程序中已经被初始化的临界区。如

果函数调用成功，则程序会将内存中的临界区删除，防止出现内存错误。

该段代码的运行结果如下图所示：

③使用Windows API的事件对象：



//main.cpp 2 #include \<windows.h\> 3 #include \<iostream\> 4 5 DWORD

WINAPI Fun_1(LPVOID p); 6 DWORD

WINAPI Fun_2(LPVOID p); 7 8 HANDLE h_event; 9 unsigned int counter = 0;

11 int main() 12 { 13

h_event = CreateEvent(nullptr, true, false, nullptr); 14

SetEvent(h_event); 15 HANDLE h1 =

CreateThread(nullptr, 0, Fun_1, nullptr, 0, nullptr); 16 std::cout \<\<

\"Thread 1 started\...\\n\"; 17

HANDLE h2 = CreateThread(nullptr, 0, Fun_2, nullptr, 0, nullptr); 18

std::cout \<\< \"Thread 2

started\...\\n\"; 19 CloseHandle(h1); 20 CloseHandle(h2); 21 // 22

system(\"pause\"); 23 return 0; 24 }

26 DWORD WINAPI Fun_1(LPVOID p) 27 { 28 while (true) 29 { 30

WaitForSingleObject(h_event,

INFINITE); 31 ResetEvent(h_event); 32 if (counter \< 1000) 33 { 34

++counter; 35 std::cout \<\<

\"Thread 1 counting \" \<\< counter \<\< \"\...\\n\"; 36

SetEvent(h_event); 37 } 38 else 39 { 40

SetEvent(h_event); 41 break; 42 } 43 } 44 return 0; 45 } 46 47 DWORD

WINAPI Fun_2(LPVOID p) 48 { 49

while (true) 50 { 51 WaitForSingleObject(h_event, INFINITE); 52

ResetEvent(h_event); 53 if (counter

\< 1000) 54 { 55 ++counter; 56 std::cout \<\< \"Thread 2 counting \"

\<\< counter \<\< \"\...\\n\"; 57

SetEvent(h_event); 58 } 59 else 60 { 61 SetEvent(h_event); 62 break; 63

} 64 } 65 return 0; 66 }

事件对象是一种内核对象，用户在程序中使用内核对象的有无信号状态来实现线程的同步。使用事件对象的步骤可概括如下：

1.创建事件对象，函数原型为：

HANDLE WINAPI CreateEvent( 2 \_In_opt\_ LPSECURITY_ATTRIBUTES

lpEventAttributes, 3 \_In\_ BOOL

bManualReset, 4 \_In\_ BOOL bInitialState, 5 \_In_opt\_ LPCTSTR lpName 6

);

如果该函数调用成功，则返回新创建的事件对象，否则返回NULL。函数参数的含义如下：

-lpEventAttributes：表示创建的事件对象的安全属性，若设为NULL则表示该程序使用的是默认安全属性。

-bManualReset：表示所创建的事件对象是人工重置还是自动重置。若设为true，则表示使用人工重置，在调用线程获得事件对象

所有权后用户要显式地调用ResetEvent()将事件对象设置为无信号状态。

-bInitialState：表示事件对象的初始状态。如果为true，则表示该事件对象初始时为有信号状态，则线程可以使用事件对象。

-lpName：表示事件对象的名称，若为NULL，则表示创建的是匿名事件对象。

2.若事件对象初始状态设置为无信号，则需调用SetEvent(HANDLE

hEvent)将其设置为有信号状态。ResetEvent(HANDLE

hEvent)则用于将事件对象设置为无信号状态。

3.线程通过调用WaitForSingleObject()主动请求事件对象，该函数原型如下：

DWORD WINAPI WaitForSingleObject( 2 \_In\_ HANDLE hHandle, 3 \_In\_

DWORD dwMilliseconds 4 );

该函数将在用户指定的事件对象上等待。如果事件对象处于有信号状态，函数将返回。否则函数将一直等待，直到用户所指定的事

件到达。

该代码的运行结果如下图所示：



④使用Windows API的互斥对象：

//main.cpp 2 #include \<windows.h\> 3 #include \<iostream\> 4 5 DWORD

WINAPI Fun_1(LPVOID p); 6 DWORD

WINAPI Fun_2(LPVOID p); 7 8 HANDLE h_mutex; 9 unsigned int counter = 0;

11 int main() 12 { 13

h_mutex = CreateMutex(nullptr, false, nullptr); 14 HANDLE h1 =

CreateThread(nullptr, 0, Fun_1,

nullptr, 0, nullptr); 15 std::cout \<\< \"Thread 1 started\...\\n\"; 16

HANDLE h2 = CreateThread(nullptr,

0, Fun_2, nullptr, 0, nullptr); 17 std::cout \<\< \"Thread 2

started\...\\n\"; 18 CloseHandle(h1); 19

CloseHandle(h2); 20 // 21 //CloseHandle(h_mutex); 22 system(\"pause\");

return 0; 24 } 25 26 DWORD

WINAPI Fun_1(LPVOID p) 27 { 28 while (true) 29 { 30

WaitForSingleObject(h_mutex, INFINITE); 31 if

(counter \< 1000) 32 { 33 ++counter; 34 std::cout \<\< \"Thread 1

counting \" \<\< counter \<\< \"\...\\n\"; 35

ReleaseMutex(h_mutex); 36 } 37 else 38 { 39 ReleaseMutex(h_mutex); 40

break; 41 } 42 } 43 return 0;

} 45 46 DWORD WINAPI Fun_2(LPVOID p) 47 { 48 while (true) 49 { 50

WaitForSingleObject(h_mutex,

INFINITE); 51 if (counter \< 1000) 52 { 53 ++counter; 54 std::cout \<\<

\"Thread 2 counting \" \<\<

counter \<\< \"\...\\n\"; 55 ReleaseMutex(h_mutex); 56 } 57 else 58 { 59

ReleaseMutex(h_mutex); 60 break;

} 62 } 63 return 0; 64 }

互斥对象的使用方法和c++标准库的mutex类似，互斥对象使用完后应记得释放。

