1

【原创】对64位下\*P的学习(不用过PG

zfdyq 2015-3-29 37658

举报

前不久研究了一些32位下各种保护，收获颇多，但是在32位下由于内存限制所以，卡卡的感觉让人很不爽，于是研究了一下64为下的保护。

测试游戏：JFZR 环境：win7 x64

一：首先是双击调试，我之前发过一篇帖子，总结过双击调试的一些关键变量之类的东西，64位和32位基本想通，详细的可以看我前的帖子，地址：

http://bbs.pediy.cm/showthread.php?t=196149

PS：过双击调试的时候要打一下PG的补，以为要替换那几个全局变量，还有就是Inline

Hook IoAllocateMdl这个函数。这里再贴一下代理函数：

PMDL newIoAllocateMdl( \_\_in_opt PVOID VirtualAddress, \_\_in ULONG

Lengh,

\_\_in BOOLEAN SecondaryBuffer, \_\_in BOOLEAN ChargeQuota,

\_\_inout_opt PIRP Irp OPTIONAL) { if (VirtualAddress ==

KdEnteredDebugger)

{ //DbgPrint(\"\[KdEnteredDebugger\] address: %p\\n\",

KdEnteredDebugger);

VirtualAddress = (PUCHAR)KdEnteedDebugger + 0x30; }

return oldIoAllocateMl(VirtualAddress, Length, SecondaryBuffer,

ChargeQuota, Irp); }

二：双击调试过了之后，开始对关键点下访问断点（全局调试对象权限，DebugPort），发现\*P并没有对DebugPort做清零，而是只对全局调试对象权限做了清零处理，难道没有

了DebugPort清零？于是自己写了个程序对程序模拟的试了一下DebugPort清零（在未打PG补丁的情况下），结果就是触发PG蓝屏。也就是说64位下如果DebugPort清零就会触

发PG。

但是对全局对象权限的清零并不会触发PG。处理方法就是简单粗暴地用DPC定时器把权限给写回去：

// 用于全局调试对象权限的计时器 500m写一次 VOID TimerRoutine( \_In\_

struct \KDPC \*Dpc,

\_In_opt\_ PVOID DeferredContext, \_In_opt\_ PVOID SystemArgument1,

\_In_opt\_ PVOID SystemArgument2 ) { UNREFERENCED_PARAMETER(Dpc);

UNREFERENCED_PARAMETER(DeferredContext);

UNREFERENCED_PARAMETER(SystemArgument1);

UNREFERENCED_PARAMETER(SystemArgument2); LARGE_INTEGER lTime = { 0 };

ULONG ulMicroSecond = 0; //将定时器的时间设置为500ms ulMicroSecond =

500000; //将32位整数转化成64

位整数 lTime = RtlConvertLongToLargeInteger(-10 \* ulMicroSecond);

DbgPrint(\"dpc Timer\...\\n\");

KIRQL irql; irql = WPOFF(); \*(PULONG_PTR)ul_ValidAccessMask_Addr =

0x1f000f; WPON(irql);

KeSetTimer(&Timer, lTime, &myDpc); }

写回权限之后，然后用XT把一些回调结束掉，就发现可以使用OD附加了，但是又遇到情况了，OD附加后，F9运行，游戏却莫名的退出了。在32位调试\*p的时候也遇到过这种情

况，当时是\*p对线程计数做了手脚，于是我列了一下线程，发现并没有异常，于是打开XT检测了一下R3的HOOK，

当我尝试恢复KiUserExceptionDispatcher这个Hook的时候，游戏居然也跟着退出了，习惯性的拿起WinDbg对这个函数下了访问断点，结果如下图：



大体的跟了一下，可以确定这个19号线程是一个检测线程，我先是对此线程挂起，然后发现KiUserExceptionDispatcher这个函数可以正常恢复了，

后来我更暴力的把这个线程直接干掉了，也是没有问题的，发现\*P对此线程也没有做保护等处理。

处理完这个线程之后居然可以OD附加调试，硬断，F2都是正常的。附图：

后续：

发现X64位下的\*p强度好低，也可能是我调试的游戏强度略低，最后附上源码，并且感谢TA大牛提供的64位教程资料。

新手发帖无任何技术含量，望大牛轻喷\~

声明：本文只供计数交流，代码切勿用于非法途径

Test.rar

Test.rar

Test.rar

12.04KB

