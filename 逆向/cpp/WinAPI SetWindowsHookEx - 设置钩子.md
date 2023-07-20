WinAPI: SetWindowsHookEx - 设置钩子\
提示: 如果要设置系统级钩子, 钩子函数必须在 DLL 中.\
SetWindowsHookEx( idHook: Integer; {钩子类型} lpfn: TFNHookProc;
{函数指\
针} hmod: HINST; {包含钩子函数的模块(EXE、DLL)句柄; 一般是 HInstance;
如\
果是当前线程这里可以是 0} dwThreadId: DWORD {关联的线程; 可用\
GetCurrentThreadId 获取当前线程; 0 表示是系统级钩子} ): HHOOK; {返回\
钩子的句柄; 0 表示失败} //钩子类型 idHook 选项: WH_MSGFILTER = -1;
{线程级;\
截获用户与控件交互的消息} WH_JOURNALRECORD = 0; {系统级;
记录所有消息队列从消息队\
列送出的输入消息, 在消息从队列中清除时发生; 可用于宏记录}
WH_JOURNALPLAYBACK = 1;\
{系统级; 回放由 WH_JOURNALRECORD 记录的消息,
也就是将这些消息重新送入消息队列}\
WH_KEYBOARD = 2; {系统级或线程级; 截获键盘消息} WH_GETMESSAGE =\
3; {系统级或线程级; 截获从消息队列送出的消息} WH_CALLWNDPROC = 4;
{系统级或线\
程级; 截获发送到目标窗口的消息, 在 SendMessage 调用时发生} WH_CBT =\
5; {系统级或线程级; 截获系统基本消息, 譬如:
窗口的创建、激活、关闭、最大最小化、移动等\
等} WH_SYSMSGFILTER = 6; {系统级; 截获系统范围内用户与控件交互的消息}\
WH_MOUSE = 7; {系统级或线程级; 截获鼠标消息} WH_HARDWARE = 8;\
{系统级或线程级; 截获非标准硬件(非鼠标、键盘)的消息} WH_DEBUG = 9;
{系统\
级或线程级; 在其他钩子调用前调用, 用于调试钩子} WH_SHELL = 10;
{系统级或线\
程级; 截获发向外壳应用程序的消息} WH_FOREGROUNDIDLE = 11;
{系统级或线程级; 在程序\
前台线程空闲时调用} WH_CALLWNDPROCRET = 12; {系统级或线程级;
截获目标窗口处理完毕\
的消息, 在 SendMessage 调用后发生}
