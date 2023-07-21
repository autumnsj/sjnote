目录

1. SSDT Hok效果图

2. SSDT简介

3. SSDT结构

4. SSDT HOOK原理

5. Hook前准备

6. 如何获得SDT中函数的地址呢

7. SSDT Hook程

8. SSDT Hook实现进程保护

9. Ring3与Ring0的通信

10. 如何安装启动停止卸载服务

11. 参考文献

12. 源码附件

13. 版权

SSDT Hook效果图

加载驱动并成功Hook NtTerminateProcess函数：



当对

指定的进程进行保护后，尝试使用"任务管理器"结束进程的时候，会弹出"拒绝访问"的窗口，说

明，我们的目的已经达到：



SSDT简介

SSDT 的全称是 System Services Descriptor Table，系统服务描述符表。

这个表就是一个把 Ring3 的 Win32 API 和 Ring0 的内核 API 联系起来。

SSDT

并不仅仅只包含一个庞大的地址索引表，它还包含着一些其它有用的信息，诸如地址索引的基

地址、服务函数个数等。

通过修改此表的函数地址可以对常用 Windows 函数及 API 进行

Hook，从而实现对一些关心的系统

动作进行过滤、监控的目的。

一些

HIPS、防毒软件、系统监控、注册表监控软件往往会采用此接口来实现自己的监控模块。

SSDT结构

SSDT即系统服务描述符表，它的结构如下(参考《Undocument Windows 000

Secretes》第二

章):

// KSYSTEM_SERVICE_TABLE 和 KSERVICE_TABLE_DESCRIPTOR // 用来定义 SDT

结构 typedef struct

\_KSYSTEM_SERVICE_TABLE { PULONG ServiceTableBae; // SSDT (System

Service Dispatch Table)的基地

PULONG ServiceCounterTablease; // 用于 checked builds, 包含 SSDT

中每个服务被调用的次数 ULONG

NumberOfService; // 服务函数的个数, NumberOfService \* 4

就是整个地址表的大小 ULONG ParamTableBase; //

SSPT(System Service Parameter Table)的基地址 } KSYSTEM_SERVICE_TABLE,

\*PKSYSTEM_SERVICE_TABLE;

typedef struct \_KSERVICE_TABLE_DESCRIPTOR { KSYSTEM_SERVICE_TABLE

ntoskrnl; // ntoskrnl.exe 的服务函

数 KSYSTEM_SERVICE_TABL win32k; // win32k.sys

的服务函数GDI32.dll/User32.dll 的内核支持)

KSYSTM_SERVICE_TABLE notUsed1; KSYSTEM_SERVICE_TABLE notUsed2;

}KSERVIE_TABLE_DESCRIPTOR,

\*PKSERICE_TABLE_DESCRIPTOR;

内核中有两个系统服务描述符表,一个是KeServiceDescriptorTable(由ntoskrnl.exe导出),一个

是KeServieDescriptorTableShadow(没有导出)

两者的区别是，KeServieDescriptorTable仅有ntoskrnel一项，

KeServieDescriporTableShadow包含了ntoskrnel以及win32k。一般的Native

API的服务地址由

KeServceDescriptorTable分派，gdi.dll/user.dll的内核API调用服务地址由

KeSerieDescriptorTableShadow分派。还有要清楚一点的是win32k.sys只有在GUI线程中才加

载，一般情况下是不加载的，所以要Hook

KeServieDescriptorTableShadow的话，一般是用一个

GUI程序通过IoControCode来触发(想当初不明白这点，蓝屏死机了N次都想不明白是怎么回事)。

SSDT HOOK原理

关于内核 Hook 有多种类型，面也给出一副图示：



SSDT HOOK只是其一种Hook技术，本篇文章主要讲解SSDT Hook的使用。

SSDT HOOK原理图



通过Kernel Detective具，我们可以发现，SSDT

Hook前后，NtTerminateProcess当前地址会

发生变化，其中，变化后的当前地址：0xF885A110为我们自定义的Hook函数（即：

HookNtTerminateProcess）的地址。这样，以后每次执行NtTerminateProcess的时候，就会根据

执行"当前地址"所指向的函数了，这也就是SSDT Hok的原理。

另外，看雪的\"堕落天才\"写的不错我直接引用下：

SSDT HOOK

的原理其实非常简单，我们先实际看看KeServiceDescriptorTable是什么样的。

lkd\> dd KeServiceDescriptorTable 8055ab80 804e3d20 00000000 0000011c

804d9f48 8055ab90 00000000

0000000 00000000 00000000 8055aba0 00000000 00000000 00000000 00000000

8055abb0 00000000 00000000

00000000 00000000

如上,80587691 80516ef 8057ab71 80581b5c

这些就是系统服务函数的地址了。比如我

们在ring3调用OpenProces时，进入sysenter的ID是0x7A(XP SP2)，然后系统查

KeServiceDescriptorTable，大概是这样

KeSrviceDescriptorTable.ntoskrnel.ServiceTableBase(804e3d20) + 0x7A \*

= 804E3F0

8,然后804E3F08 -\>8057559e

这个就是OpenProcess系统服务函数所在,我们再跟踪看看:

lkd\> u 8057559e nt!NtOpenPocess: 8057559e 68c4000000 push 0C4h

805755a3 6860b54e80 push offse

nt!ObReferenceObjectByPointer+0x17 (804eb560) 805755a8 e8e5e4f6ff call

nt!InterlockedPushEntrySList+0x79 (804e3a92) 80755ad 33f6 xor esi,esi

原来8057559e就是NtOpenProcess函数所在的始地址。

嗯，如果我们把8057559e改为指向我们函数的地址呢？比如

MyNtOpenProcess，那么统就会

直接调用MyNtOpenProcess，而不是原来的NtOpenProcess了。这就是SSDT HOOK

原理所在。

另外，关于Ring3层转入Ring0层的具体流程，可以参考下我的这篇博文，对加深理解SSDT

Hook技

术还是有帮助的：Ring3转入Ring0跟踪

Hook前准备

我们要修改SSDT表，首先这个表必须是可写的，但在x以后的系统中他都是只读的，三个办法来修

改内存保护机制

(1) 更改注册表

恢复页面保护：HKLM\\SYSTEM\\CurrentCotrolset\\Control\\Session

Mange\\Memory

Management\\EnforeWriteProtection=0

去掉页面保护：HKLM\\SYSTEM\\CurrentControlset\\ontrol\\Session

Manger\\Memory

Management\\DisablePagingExecuive=1

(2)改变CR0寄存器的第1位

Windows对内存的分配，是采用的分页管理。其中有个CR0寄存器如下图：



其中第1位叫做保护属性位，控制着页的读或写属性。如果为1，则可以读/写/执行；如果为0，则只可

以读/执行。

SSDT，IDT的页属性在默认下都是只读，可执行的，但不能写。

代码如下

//设置为不可写 void DisableWrite() { \_\_try { \_asm { mov eax, cr0 or

eax, 10000h mov cr0, eax sti } }

\_\_except(1) { DbgPrint(\"DisableWrite执行失败！\"); } } // 设置为可写

void EnableWrite() { \_\_try { \_asm {

cli mov eax,cr0 and eax,not 10000h //and eax,0FFFEFFFFh mov cr0,eax } }

\_\_except(1) {

DbgPrint(\"EnableWrite执行失败！\"); } }

（3）通过Memory Descriptor List(MDL)

具体做法可以google下，这里就不介绍了

如何获得SSDT中函数的地址呢？

这里主要使用了两个宏：

①获取指定服务的索引号：SYSCALL_INDEX

②获取指定服务的当前地址：SYSCALL_FUNCTION

这两个宏的具体定义如下：

//根据 ZwServiceFunction 获取 ZwServiceFunction 在 SSDT

中所对应的服务的索引号 #define

SYSCALL_INDEX(ServiceFunction) (\*(PULONG)((PUCHAR)ServiceFunction + 1))

//根据

ZwServiceFunction 来获得服务在 SSDT

中的索引号，然后再通过该索引号来获取

ntServiceFunction的地址 #define SYSCALL_FUNCTION(ServiceFunction)

KeServiceDescriptorTable-

\>ntoskrnl.ServiceTableBase\[SYSCALL_INDEX(ServiceFunction)\]

SSDT Hook流程



在驱动的入口函数中(DriverEntry),对未进行SSDT

Hook前的SSDT表进行了备份（用一个数组保

存），备份时，一个索引号对应一个当前地址，如上图所示。

这样，在解除Hook的时候，就可以从全局数组中根据索引号获取未Hook前的服务名的当前地址，以

便将原来的地址写回去，这一步很重要。

当用户选择保护某个进程的时候，就会通过DeviceIoControl发送一个

IO_INSERT_PROTECT_PROCESS控制码给驱动程序，此时驱动程序会生成一个

IRP:IRP_MJ_DEVICE_CONTROL,我们事先已经在驱动程序中为

IRP_MJ_DEVICE_CONTROL指定了一个派遣函数：SSDTHook_DispatchRoutine_CONTROL。

在该派遣函数中：我们通过获取控制码（是保护进程还是取消保护进程），如果是要保护某个进程，

则通过

DeviceIoControl的第3个参数将要保护的进程的pid传递给驱动程序。然后在派遣函数

SSDTHook_DispatchRoutine_CONTROL中从缓冲区中读取该pid，如果是要保护进程，则将要"保

护进程"的pid添加到一个数组中，如果是要"取消保护进程"，则将要取消保护的进程PID从数组中移

除。

在Hook

NtTermianteProcess函数后，会执行我们自定义的函数：HookNtTerminateProcess，在

HookNtTerminateProcess函数中，我们判断当前进程是否在要保护的进程数组中，如果该数组中存

在该pid，则我们返回一个"权限不够"的异常，如果进程保护数组中不存在该pid，则直接调用原来

SSDT 中的 NtTerminateProcess 来结束进程。

SSDT Hook实现进程保护

有了上面的理论基础之后，接下来可以谈谈SSDT

Hook实现进程保护的具体实现了。

实现进程保护，可以Hook NtTermianteProcess，另外也可以Hook

NtOpenProcess，这里，我是

Hook NtTermianteProcess。

SSDT Hook原理一节中已经说过，SSDT Hook原理的本质是：自定义一个函数

（HookNtTerminateProcess），让系统服务NtTermianteProcess的当前地址指向我们自定义函数

地址。

这一步工作是在驱动入口函数中执行的。当驱动加载的时候，将自定义函数的地址写入SSDT表中

NtTermianteProcess服务的当前地址：

// 实现 Hook 的安装，主要是在 SSDT 中用 newService 来替换掉 oldService

NTSTATUS InstallHook(ULONG

oldService, ULONG newService) { \_\_try { ULONG uOldAttr = 0;

EnableWrite(); //去掉页面保护 KdPrint((\"伪

造NtTerminateProcess地址: %x\\n\",(int)newService));

//KeServiceDescriptorTable-

\>ntoskrnl.ServiceTableBase\[SYSCALL_INDEX(oldService)\] = newService;

SYSCALL_FUNCTION(oldService) =

newService;// DisableWrite(); //恢复页面保护 return STATUS_SUCCESS; }

\_\_except(1) { KdPrint((\"安装Hook

失败!\")); } }

这里需要注意的是：在Hook前，需要去掉内存的页面保护属性，Hook后，需要回复内存的页面保护

属性。

HookNtTerminateProcess函数的代码如下：

//\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

// 函数名称 : HookNtTerminateProcess // 描 述 : 自定义的

NtOpenProcess，用来实现 Hook Kernel API // 日 期 : 2013/06/28 // 参 数 :

ProcessHandle:进程句柄

ExitStatus: // 返 回 值 :

//\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

NTSTATUS

HookNtTerminateProcess(\_\_in_opt HANDLE ProcessHandle,\_\_in NTSTATUS

ExitStatus) { ULONG uPID;

NTSTATUS rtStatus; PCHAR pStrProcName; PEPROCESS pEProcess; ANSI_STRING

strProcName; // 通过进程句柄来

获得该进程所对应的 FileObject 对象，由于这里是进程对象，自然获得的是

EPROCESS 对象 rtStatus =

ObReferenceObjectByHandle(ProcessHandle, FILE_READ_DATA, NULL,

KernelMode, (PVOID\*)&pEProcess,



NULL); if (!NT_SUCCESS(rtStatus)) { return rtStatus; } // 保存 SSDT

中原来的 NtTerminateProcess 地址

pOldNtTerminateProcess =

(NTTERMINATEPROCESS)oldSysServiceAddr\[SYSCALL_INDEX(ZwTerminateProcess)\];

// 通过该函数可以获取到进程名称和进程 ID，该函数在内核中实质是导出的(在

WRK 中可以看到) // 但是 ntddk.h 中并没有到

处，所以需要自己声明才能使用 uPID = (ULONG)PsGetProcessId(pEProcess);

pStrProcName = \_strupr((TCHAR

\*)PsGetProcessImageFileName(pEProcess));//使用微软未公开的PsGetProcessImageFileName函数获取进程名

// 通过

进程名来初始化一个 ASCII 字符串 RtlInitAnsiString(&strProcName,

pStrProcName); if

(ValidateProcessNeedProtect(uPID) != -1) { //

确保调用者进程能够结束(这里主要是指 taskmgr.exe) if (uPID

!= (ULONG)PsGetProcessId(PsGetCurrentProcess())) { //

如果该进程是所保护的的进程的话，则返回权限不够的异常即

可 return STATUS_ACCESS_DENIED; } } // 对于非保护的进程可以直接调用原来

SSDT 中的 NtTerminateProcess 来结束

进程 rtStatus = pOldNtTerminateProcess(ProcessHandle, ExitStatus);

return rtStatus; }

Ring3与Ring0的通信

请看考：张帆《Windows驱动开发技术详解》一书第7章：派遣函数

如何安装、启动、停止、卸载服务

请参考我的另一篇博文：NT式驱动加载器（附带源码）

参考文献

SSDT Hook的妙用－对抗ring0 inline

hook：http://bbs.pediy.com/showthread.php?

t=40832

进程隐藏与进程保护(SSDT Hook 实现)：

http://www.cnblogs.com/BoyXiao/archive/2011/09/03/2164574.html

张帆的《Windows驱动开发技术详解》一书

源码附件

SSDT Hook实现内核级的进程保护

版权

