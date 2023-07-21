标题：关于Win7 x64下过TP保护(应用层)

作者：小宝(a71081954)

时间：2015-07-20

链接：http:/www.mengwuji.net/thread-2209-1-1.html

非常感谢大家那么支持我上一篇教程。

Win1 快出了，所以我打算尽快把应用层的部分说完。

调试对：DXF

调试工具：CE、OD、PCHunter、Windbg

调试先言：TP应用层保护做得比较多，包括对调试器的检测，比如CE工具会被DXF报非

法。有的保护还是内核与应用层交替保护。

应用层：

1、TP让调试器卡死(内核互动)

现象:

如图，TP会检测调试器让调试器暂停运行，实际上就是暂了调试器所有的线程而已。



这个保护是今年7月份新出的，所以我这里重点分析下，刚开始调试的时候就发现OD会莫

名其妙地卡死。

打开PCHunter发现OD的进程线程全部被暂停了。

开始我认为是TP调用了SuspendThread(函数:暂停指定线程)来让调试器卡死的。

于是我就打开Windbg附加并在这个函数上下断点，发现没有断下来。

然后我认为是调用了接口函数NtSuspendThread(函数:暂停指定线程\内核接口\>)

但是还是没有断下。所以排除DXF在Ring3调用了暂停线程让OD卡死。

于是我思考了一下，打开虚拟机，简单了双机调试保护（一段时间后还是会蓝屏），在

DXF启动之后，

在Windbg输入!process OD的进ID

来查看线程的调用堆载，我发现了很有意思的东西。

SupendCount被置为了1，再看看调用堆载。

原来TP在Ring0中调用了KiuspendThread来暂停OD的线程啊。怪不得断不下来。

于是我在KiSuspendThread头部下断点，发现当D打开的时候会断下，

这个是它的函数开头

0: kd\> u KiSuspendTread

nt!KiSuspendThread:

fffff800\`03e6cc60 48895c2408 mov qword ptr [rsp+8\],rbx

fffff800\`03e6cc65 4889742410 mov qword ptr \[rsp+10h\],rsi

fffff800\`03e6cc6a 57 push rdi

fffff800\`03e6cc6b 4883c30 sub rsp,30h

fffff800\`0e6cc6f 8364245800 and dword ptr \[rsp+58h\],0

fffff800\`03e6cc74 65488b1c2588010000 mv rbx,qword ptr gs:\[188h\]

fffff800\`03e6cc7d 4885b test rbx,rbx

它还保留着用_\_stdcall的调用约定，在64位下一般都是\_\_fastcall

通过对参数的分析，发现这个函数的第一个参数也就是rbx，里面存的是线程对象。

我在网上也没有找到相关的信息，于是我自己在头部改成了ret。

之后运行OD就不会卡死了。

继续深究，原来TP创建了一个内核回调，就是CreateProcess的回，

自己可以打开PCHunter查看。

当发现是OD的进程被创建时，就会调用这个函数让进程暂停。

哦，原来是这样，那我们有什么办法解决它呢？怎么才能让调试器正常运行呢？

方案:1自己恢复调试器的进程(推荐) 2、删除内核回调(驱动推荐)3、Hook

KiSuspenThread 绕过(稍难)

在这里我推荐第一种，因为们是要在应用层下操作。



方法很简单，当我们打开OD工具时，打开PCHunter选择OD的进程，右键恢复进运行即

可。

也可以自己做一个工具，恢复OD的进程，但是你要确保自己的序不会进入黑名单。

至此，我们的调试器能正常打开了。

2、函数钩子(Hook)

这个保护不能说是新鲜了的吧，在应用层里很多游戏都这么干。

其实就是把一些重要的调试函数行钩子，导致程序崩溃或者无法调试。

我们打开PCHunter，来到如图的位置，选择XF的进程-\>右键选择扫描。

现在你只需要坐下等大约5分钟吧，好像有一千多个钩子(笑)，要有耐心。

看到图中3钩子了吗，它就是我们要说的。

我这里来说明下这3函数的用途。

DbgURemoteBreakin:远程中断，附加调试器时调试器会发送信息让

进程走这里。

KiUserExceptionDispatcher:UEF异常处理函数，梦老大讲解过的，

这个我们不能随便恢复，干脆不管它

因为XF自己制造异常自己处理。



LdrInitalizeThunk映像文件链入口，当DLL载入时会经过这里，如

果我们恢复它将无法注入DLL。

这3个钩子有两个是我们必须恢复的，就是一和三

第三个比较好处理，PCHunter中已经给出了函数原来的机器码。我们之间用PCHuntr恢复

也可以自己写个程序恢复

但是第一个就不好了，我们必须用程序自己来恢复,因为:

红线部分是需要重定位的，机器每次开机都会不同，我们可以通过获取自己程序的这个位

置的代码来恢复。

具体怎恢复这里就不说了，我会贴出代码给大家。

那么2个Hook搞定后我们就要来解决崩溃题了。

3、异常崩溃

大家可以发现OD附加DXF后运行，游戏会莫名其妙地崩溃，你可能认为OD被DXF检测到

了，其实它是个通用

的反调试的手。

自己给自己制造异常，自己处理，如果OD抢着处理这个异常，反而会使进程崩溃。

这个就是它异常崩溃的原理。

其实是一个线程在自发异常的，怎么把它揪出来呢？



打开Wndbg，附加DXF，运行，可以发现一段时间后，Windbg断下

如图所示：

线程I:F08 发送了一个内存访问异常(0x80000002)它故意让Windbg断下。

它需要试探是否有调试器，于是我们就找到它了，把f08换成十进制发现是

3848的线程发送异常的，在PCHunter中可以看到，如图所示，它是由ntdll.dll发送的。

唯一的办法就是结束这个线程，右键-\>结束线程，搞定，OD附加DXF不会崩溃了。

但是你自己做个程序来找到这条线程然后来结束掉，可以通过搜索线程入口特征码的方

式来

找到它。

那么现，我们调试DXF再也没有问题了。但是CE工具开启久了也会被提示非法，怎么办？

4、检测非法工具

也许大家常想要知道怎么办。

它检测非法工具的原理是:

使用eadProcessMemory(函数:读取进程内存)搜索进程特征码，找到属于非法工具的特

征码后游戏消失，提示非法重启。

若想决它，我们有以下方案:

1、删除工具中的特征码 2、在内核中拦截NtReadirtualMemory或

KeStackAttachProces来绕过搜索



3、找到搜索的线程，结束该线程。

其实我发现第3种是一劳永逸，所以我在这里说下第三种方法。

打开PCHunter找到如下几条线程。选择后同时右键结束，OK，CE再也会非法了。

这几条线程都是TenSLX.dll模块里的，其实这个方在腾Xun游戏里面通用。

别问我是怎么知道的，其实我是一个个试过的(笑)。

5、关于CRC代码自校验

通过上面的说明，大家应该可以总结一个结论

在应用层中游戏若想保护自己都是采用走线程或Hok方式。

所以大可以自己找到CRC代码自校验的线程吧？结束掉，OK，可以

下软件断点(int 3)了。

结束语:

别以为样就能在DXF里为所欲为了，还有三方检

测等着你呢!



这些还需要靠大家自己多去练习，总结规，其实

你会发现，

再难的保护还都是这样子的了(笑)\...\...

附赠代码(部分):

1. void CAnitTP_AppDlg::OnBnClickedButonAnit()

2. {

3. DWORD pid = GetProcessIdByProcName(TEXT(\"DNF.exe\");

4. f (pid==0)

5. {

6. MessageBox(TEXT(\"对不起，没有找到指定游戏进程.(DNF.exe)\"),

TEXT(\操作失败\"), MB_OK \|

MB_ICONERROR);

7. reurn;

8.

9. }

10. const BYTE code\[8\] = {0x90,0x90,0x90,0x90,0x90,0x55,0x8b,0xec};

11. const BYTE code2\[13\]  { 0xC3, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90,

0x90, 0x90, 0x90,

0x90, 0x90 ,0xE9};

12.

13.

14. DORD trds\[521\];

15. int trdcont=0;

16.trdcount=GetProcessThreadId(pid, trds);

17. LVOID pEntryPoint=NULL;

18. BYTE buf\[13\];

19. HNDLE hThread;

20. fr (int i = 0; i \< trdcount;i++)

21. {

22. pntryPoint=GetThreadEntryPointById(trds\[i\]);

23. ReadProcessMemoryEx(pid, pEntryPoint, buf, 8);

24. TCAR ModuleName\[256\];

25. GetProcessThreadMduleNameByTid(pid, trds\[i\], ModuleName);

26.

27. if (memcmp(buf, code, 8) == 0 \|\| lstrcmp(ModuleName,

L\"TenSLX.dll\")==0)

28. {

29. hThread = OpenThread(THREAD_ALL_ACCESS, FALSE, rds\[i\]);

30. if (!hThread)continue;

31. TerminateTread(hThread,0);

32. CloseHandle(hThread);

33.



34\. }

35.

36. RedProcessMemoryEx(pid, (LPVOID)((int)pEntryPoint - 0xc), buf,

13);

37. if (memcmpbuf, code2, 13) == 0)

38. 

39. hTread = OpenThread(THREAD_ALL_ACCESS, FALSE, trds\[i\]);

40. if (!hThread)coninue;

41. SuspendThreadhThread);

42. CloseHandle(hThrea);

43.

44. }

45. }

46.

47.

48.

49. byte code3\[7\] = { 0x6A,0x08, 0x68, 0x00, 0x00, 0x00, 0x00 };

50. LPVOID pDbgUiRemoteBrakin =

(LPVOID)GetProcAddress(GetModuleandle(\_T(\"ntdll.dll\")),

\"DbgUiRemoteBreakin\"); //调试用

51. memcpy(&code3\[3\], (LPVOID)((int)pDbgUiRemteBreakin + 3), 4);

52. WriteProcessMemoryEx(pid, pDgUiRemoteBreakin, code3, 7);

53.

54. bye code4\[6\] = { 0x8b, 0xff, 0x55, 0x8b, 0xec, 0xff };

55. PVOID pLdrInitializeThunk =

(LPVOID)GetProcAddress(GetMduleHandle(\_T(\"ntdll.dll\")),

\"LdrIitializeThunk\"); //DLL注入用

56. WriteProcessMemoryEx(pid, pLdrInitializeThunk, code, 6);

57.

58.

MessageBox(TEXT(\"操作完毕,开始调吧!\"),TEXT(\"OK\"),MB_OK\|MB_ICONINFORMATION);

59. 

复制代码

功能函数头文:

1. #ifndef ANSHU

2. #define HANSHU

3.

4. #include \<TlHelp32.h\>

5. #include \<psapi.h\>

6. #pragma comment(lib,\"psapi.lib\")

7.

8. typedef enum \_HREADINFOCLASS {

9. ThreadBasicInformatio,

10. TheadTimes,

11. hreadPriority,

12. ThreadBasePriority,

13. ThreadAffinityMask,

14. ThreadImpersonationToken,

15. ThreadDescriptorTableEntry,



16\. ThreadEnableAlignmentFaultFixup,

17. ThreadEventPair_Reusable,

18. ThreadQuerySetWin32StartAddress,

19. ThreadZeroTlsCell,

20. ThreadPerformanceCount,

21. ThreadAmILastThread,

22. ThreadIdealProcessor,

23. ThreadPriorityBoost,

24. ThreadSetTlsArrayAddress,

25. ThreadIsIoPending,

26. ThreadHideFromDebugger,

27. ThreadBreakOnTermination,

28. MaxThreadInfoClass

29. } THREADINFOCLASS;

30.

31. typedef struct \_CLIENT_ID {

32. HANDLE UniqueProcess;

33. HANDLE UniqueThread;

34. } CLIENT_ID;

35. typedef CLIENT_ID \*PCLIENT_ID;

36.

37. typedef struct \_THREAD_BASIC_INFORMATION { // Information Class 0

38. LONG ExitStatus;

39. PVOID TebBaseAddress;

40. CLIENT_ID ClientId;

41. LONG AffinityMask;

42. LONG Priority;

43. LONG BasePriority;

44. } THREAD_BASIC_INFORMATION, \*PTHREAD_BASIC_INFORMATION;

45.

46. typedef LONG (\_\_stdcall \*fZwQueryInformationThread) (

47. IN HANDLE ThreadHandle,

48. IN THREADINFOCLASS ThreadInformationClass,

49. OUT PVOID ThreadInformation,

50. IN ULONG ThreadInformationLength,

51. OUT PULONG ReturnLength OPTIONAL

52. );

53.

54. fZwQueryInformationThread ZwQueryInformationThread;

55.

56.

57. DWORD GetProcessPidByWndName(LPCTSTR szWndName)

58. {

59. HWND hWnd = FindWindow(NULL,szWndName);

60. if (IsWindow(hWnd))



61\. {

62. DWORD pid;

63. GetWindowThreadProcessId(hWnd,&pid);

64. return pid;

65. }

66. return 0;

67. }

68.

69. DWORD GetProcessIdByProcName(LPCTSTR szProcName)

70. {

71. HANDLE hSnapshot= CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);

72. PROCESSENTRY32 pro;

73. pro.dwSize=sizeof(pro);

74. BOOL bMore=Process32First(hSnapshot,&pro);

75. while (bMore)

76. {

77. if (lstrcmp(szProcName,pro.szExeFile)==0)

78. {

79. CloseHandle(hSnapshot);

80. return pro.th32ProcessID;

81. }

82. bMore=Process32Next(hSnapshot,&pro);

83. }

84. CloseHandle(hSnapshot);

85. return 0;

86. }

87.

88. BOOL ReadProcessMemoryEx(DWORD pid,LPVOID addr,LPVOID buffer,DWORD

size)

89. {

90. HANDLE hProcess=OpenProcess(PROCESS_ALL_ACCESS,FALSE,pid);

91. if (hProcess==0)

92. {

93. return FALSE;

94. }

95. BOOL bResult=ReadProcessMemory(hProcess,addr,buffer,size,NULL);

96. CloseHandle(hProcess);

97. return bResult;

98. }

99.

100. BOOL WriteProcessMemoryEx(DWORD pid,LPVOID addr,LPVOID buffer,DWORD

size)

101. {

102. HANDLE hProcess=OpenProcess(PROCESS_ALL_ACCESS,FALSE,pid);

103. if (hProcess==0)

104. {

105. return FALSE;

106. }



107\. BOOL bResult=WriteProcessMemory(hProcess,addr,buffer,size,NULL);

108. CloseHandle(hProcess);

109. return bResult;

110. }

111.

112. int GetProcessThreadId(DWORD pid,DWORD \*trds)

113. {

114. HANDLE hSnapshot= CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD,pid);

115. if (hSnapshot==INVALID_HANDLE_VALUE)

116. return 0;

117. THREADENTRY32 trd;

118. trd.dwSize=sizeof(trd);

119. BOOL bMore=Thread32First(hSnapshot,&trd);

120. int i=0;

121. while (bMore)

122. {

123. if (trd.th32OwnerProcessID==pid)

124. {

125. trds\[i\]=trd.th32ThreadID;

126. i++;

127.

128. }

129. bMore=Thread32Next(hSnapshot,&trd);

130. }

131. CloseHandle(hSnapshot);

132. return i;

133. }

134.

135. LPVOID GetThreadEntryPointById(DWORD tid)

136. {

137. HANDLE hThread=OpenThread(THREAD_ALL_ACCESS,FALSE,tid);

138. if (hThread==0)

139. {

140. return NULL;

141. }

142. LPVOID Addr=NULL;

143. ZwQueryInformationThread=

(fZwQueryInformationThread)GetProcAddress(GetModuleHandle(TEXT(\"ntdll.dll\")),\"ZwQueryInformati

onThread\");

144.

ZwQueryInformationThread(hThread,ThreadQuerySetWin32StartAddress,&Addr,4,NULL);

145. CloseHandle(hThread);

146. return Addr;

147. }

148.

149. BOOL GetProcessThreadModuleNameByTid(DWORD pid, DWORD tid, LPWSTR

pszModuleName)

150. {



151\. HANDLE hProcess = NULL;

152. LPVOID pStart = NULL;

153. TCHAR tmpStr\[256\];

154. hProcess = OpenProcess(PROCESS_ALL_ACCESS, FALSE, pid);

155. if (!hProcess)return FALSE;

156. pStart = GetThreadEntryPointById(tid);

157. if (!pStart) return FALSE;

158. GetMappedFileName(hProcess, pStart, tmpStr, 256);

159. for (int i = lstrlen(tmpStr); i \>0; i\--)

160. {

161. if (tmpStr\[i\]== \'\\\\\')

162. {

163. lstrcpy(pszModuleName, &tmpStr\[i+1\]);

164. break;

165. }

166. }

167.

168.

169. CloseHandle(hProcess);

170. return TRUE;

171. }

172.

173. void TerminateThreadEx(DWORD tid,DWORD exitcode=0)

174. {

175. HANDLE hThread=OpenThread(THREAD_ALL_ACCESS,FALSE,tid);

176. if (hThread!=NULL)

177. {

178. TerminateThread(hThread,exitcode);

179. CloseHandle(hThread);

180. }

181.

182. }

183.

184. BOOL EnableDebugPrivilege()

185. {

186. HANDLE token;

187. //提升权限

188.

if(!OpenProcessToken(GetCurrentProcess(),TOKEN_ADJUST_PRIVILEGES,&token))

189. {

190. return FALSE;

191. }

192. TOKEN_PRIVILEGES tkp;

193. tkp.PrivilegeCount = 1;

194.

::LookupPrivilegeValue(NULL,SE_DEBUG_NAME,&tkp.Privileges\[0\].Luid);

195. tkp.Privileges\[0\].Attributes = SE_PRIVILEGE_ENABLED;

196. if(!AdjustTokenPrivileges(token,FALSE,&tkp,sizeof(tkp),NULL,NULL))



197\. {

198. return FALSE;

199. }

200. CloseHandle(token);

201. return TRUE;

202. }

203.

204.

205. #endif

复制代码

