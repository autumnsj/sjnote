对windows安全比较熟悉的同学对模块注入应该都比较了解，很多病毒、木马、外挂都会用\
到，无模块注入应用得则比较少。\
无模块注入的好处是DLL注入进去后，确实已经不以模块的形式存在了，用任何进程模\
块查看工具，都找不到注入进去的DLL。因为它已经变为一块纯堆内存，跟EXE主模块里申\
请的堆没有任何差别。\
这里讲的一种无模块注入的方法，能够让DLL自身实现这样的功能，无需外部注入工具\
帮助处理。当然如果进程内自行加载这样的DLL后，也是以无模块DLL形式存在。\
注入完成后，进程内找不到注入的模块存在，用Dbgview每5秒可以看\
到\"No Module Thread\"消息打印出来，表示无模块DLL内进程的活动\
之前这个方法有在看雪发表过，不过没有详细讲，有的同学不是很明白，这里把源码贴\
出来，加上注释，应该会比较清楚了。\
LoadPE.CPP\
\"No Module Thread\"//coded by 燕十二\
#include \"stdafx.h\"\
#include \<stdio.h\>\
//将DLL文件读到内存\
BOOL LoadDll2Mem(PVOID &pAllocMem,DWORD &dwMemSize,char\* strFileName)\
{\
HANDLE hFile = CreateFileA(strFileName, GENERIC_READ,\
FILE_SHARE_READ, NULL,\
OPEN_EXISTING,\
FILE_ATTRIBUTE_NORMAL, NULL);\
if (INVALID_HANDLE_VALUE == hFile) {\
return FALSE;\
}\
PVOID pFileBuff = NULL;\
int nFileSize = GetFileSize(hFile, NULL);\
if (nFileSize == 0)\
{\
return FALSE;

}\
else\
{\
pFileBuff = VirtualAlloc(NULL,nFileSize,MEM_COMMIT,PAGE_EXECUTE_RE\
ADWRITE);\
}\
DWORD dwReadSize = 0;\
if (!ReadFile(hFile, pFileBuff, nFileSize, &dwReadSize, NULL))\
{\
return FALSE;\
}\
PVOID pBase = pFileBuff;\
//判断是否是PE\
PIMAGE_DOS_HEADER pIDH = (PIMAGE_DOS_HEADER)pFileBuff;\
if (IMAGE_DOS_SIGNATURE != pIDH-\>e_magic)\
{\
return FALSE;\
}\
PIMAGE_NT_HEADERS pINH = (PIMAGE_NT_HEADERS)((ULONG)pFileBuff + pIDH-\
\>e_lfanew);\
if (IMAGE_NT_SIGNATURE != pINH-\>Signature)\
{\
return FALSE;\
}\
dwMemSize = nFileSize;\
pAllocMem = pFileBuff;\
return TRUE;\
}

//将DLL文件按section信息构建内存，重新对齐填充各section，并自行计算填充导入表\
BOOL PELoader(char \*lpStaticPEBuff, PVOID& pExecuMem)\
{\
long lPESignOffset = \*(long \*)(lpStaticPEBuff + 0x3c);\
IMAGE_NT_HEADERS \*pINH = (IMAGE_NT_HEADERS \*)\
(lpStaticPEBuff + lPESignOffset);\
long lImageSize = pINH-\>OptionalHeader.SizeOfImage;\
char \*lpDynPEBuff = (char
\*)VirtualAlloc(NULL,lImageSize,MEM_COMMIT,PAGE\
\_EXECUTE_READWRITE);\
if(lpDynPEBuff == NULL)\
{\
return FALSE;\
}\
memset(lpDynPEBuff, 0, lImageSize);\
long lSectionNum = pINH-\>FileHeader.NumberOfSections;\
IMAGE_SECTION_HEADER \*pISH = (IMAGE_SECTION_HEADER \*)\
((char \*)pINH + sizeof(IMAGE_NT_HEADERS));\
memcpy(lpDynPEBuff, lpStaticPEBuff, pISH-\>VirtualAddress);\
long lFileAlignMask = pINH-\>OptionalHeader.FileAlignment - 1;\
long lSectionAlignMask = pINH-\>OptionalHeader.SectionAlignment - 1;\
for(int nIndex = 0; nIndex \< lSectionNum; nIndex++, pISH++)\
{\
memcpy(lpDynPEBuff + pISH-\>VirtualAddress, lpStaticPEBuff + pISH-\
\>PointerToRawData, pISH-\>SizeOfRawData);\
}\
if(pINH-\
\>OptionalHeader.DataDirectory\[IMAGE_DIRECTORY_ENTRY_IMPORT\].Size \>
0)\
{\
IMAGE_IMPORT_DESCRIPTOR \*pIID = (IMAGE_IMPORT_DESCRIPTOR \*)\
(lpDynPEBuff + \\

pINH-\
\>OptionalHeader.DataDirectory\[IMAGE_DIRECTORY_ENTRY_IMPORT\].VirtualAddress\
);\
for(; pIID-\>Name != NULL; pIID++)\
{\
IMAGE_THUNK_DATA \*pITD = (IMAGE_THUNK_DATA \*)(lpDynPEBuff + pIID-\
\>FirstThunk);\
char\* pLoadName = lpDynPEBuff + pIID-\>Name;\
HINSTANCE hInstance = LoadLibrary(pLoadName);\
if(hInstance == NULL)\
{\
VirtualFree(lpDynPEBuff,lImageSize,MEM_DECOMMIT);\
return FALSE;\
}\
for(; pITD-\>u1.Ordinal != 0; pITD++)\
{\
FARPROC fpFun;\
if(pITD-\>u1.Ordinal & IMAGE_ORDINAL_FLAG32)\
{\
fpFun = GetProcAddress(hInstance, (LPCSTR)(pITD-\
\>u1.Ordinal & 0x0000ffff));\
}\
else\
{\
IMAGE_IMPORT_BY_NAME \* pIIBN = (IMAGE_IMPORT_BY_NAME \*)\
(lpDynPEBuff + pITD-\>u1.Ordinal);\
fpFun = GetProcAddress(hInstance, (LPCSTR)pIIBN-\>Name);\
}\
if(fpFun == NULL)\
{\
delete lpDynPEBuff;\
return false;

}\
pITD-\>u1.Ordinal = (long)fpFun;\
}\
}\
}\
if(pINH-\
\>OptionalHeader.DataDirectory\[IMAGE_DIRECTORY_ENTRY_BASERELOC\].Size
\> 0)\
{\
IMAGE_BASE_RELOCATION \*pIBR = (IMAGE_BASE_RELOCATION \*)\
(lpDynPEBuff + \\\
pINH-\
\>OptionalHeader.DataDirectory\[IMAGE_DIRECTORY_ENTRY_BASERELOC\].VirtualAddr\
ess);\
long lDifference = (long)lpDynPEBuff - pINH-\>OptionalHeader.ImageBase;\
for(; pIBR-\>VirtualAddress != 0; )\
{\
char \*lpMemPage = lpDynPEBuff + pIBR-\>VirtualAddress;\
long lCount = (pIBR-\
\>SizeOfBlock - sizeof(IMAGE_BASE_RELOCATION)) \>\> 1;\
short int \*pRelocationItem = (short int \*)\
((char \*)pIBR + sizeof(IMAGE_BASE_RELOCATION));\
for(int nIndex = 0; nIndex \< lCount; nIndex++)\
{\
int nOffset = pRelocationItem\[nIndex\] & 0x0fff;\
int nType = pRelocationItem\[nIndex\] \>\> 12;\
if(nType == 3)\
{\
\*(long \*)(lpMemPage + nOffset) += lDifference;\
}

else if(nType == 0)\
{\
}\
}\
pIBR = (IMAGE_BASE_RELOCATION \*)(pRelocationItem + lCount);\
}\
}\
pExecuMem = lpDynPEBuff;\
return true;\
}\
typedef BOOL (WINAPI \*DLL_MAIN)\
( HMODULE hModule,DWORD ul_reason_for_call,LPVOID lpReserved);\
//通过PE信息获取EP作为入口函数，并运行,这里把dwReaseon设置为NO_MODULE_MARK，保留参\
数设置为模块的路径\
//相当于再次以(hModule,NO_MODULE_MARK,pModuleName)为参数，调用一次原始的DllMain\
函数\
bool CallDllMain(PVOID pExecMem,DWORD dwReaseon,char\* pModuleName)\
{\
PIMAGE_NT_HEADERS pINH = (PIMAGE_NT_HEADERS)\
((ULONG)pExecMem + ((PIMAGE_DOS_HEADER)pExecMem)-\>e_lfanew);\
DWORD dwEP = pINH-\>OptionalHeader.AddressOfEntryPoint;\
DLL_MAIN lpDllMain = (DLL_MAIN)((DWORD)pExecMem + dwEP);\
lpDllMain((HMODULE)pExecMem,dwReaseon,pModuleName);\
return TRUE;\
}\
BOOL LaunchDll(char \*strName,DWORD dwReason)

{\
PVOID pRelocMem = NULL;\
PVOID pExecuMem = NULL;\
DWORD dwMemSize = 0;\
if (LoadDll2Mem(pRelocMem,dwMemSize,strName))\
{\
PELoader((char \*)pRelocMem,pExecuMem);\
CallDllMain(pExecuMem,dwReason,strName);\
ZeroMemory(pRelocMem,dwMemSize);\
VirtualFree(pRelocMem,dwMemSize,MEM_DECOMMIT);\
}\
return TRUE;\
}\
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--\
TestDll.cpp\
// TestDll.cpp : Defines the entry point for the DLL application.\
//Coded by 燕十二\
#include \"stdafx.h\"\
#include \"LoadPE.h\"\
//防止无模块DLL多次注入\
BOOL IsMutexExist(char\* pstrMutex)\
{\
BOOL bRet = FALSE;\
HANDLE hMutex = NULL;\
hMutex = CreateMutexA(NULL, TRUE, pstrMutex);\
if ( hMutex )\
{\
if ( GetLastError() == ERROR_ALREADY_EXISTS )\
bRet = TRUE;\
ReleaseMutex(hMutex);\
CloseHandle(hMutex);\
}\
else

{\
bRet = TRUE;\
}\
return bRet;\
}\
//调用LoadPE.cpp里的函数，自行处理PE加载，把DLL在新申请的内存加载起来，并执行入口函数\
void LaunchNoModule()\
{\
LaunchDll(dllModuleName,NO_MODULE_MARK);\
}\
unsigned int \_\_stdcall NoModuleThread(void\* lpParameter)\
{\
while (TRUE)\
{\
Sleep(5000);\
OutputDebugString(\"No Module Thread\");\
}\
return TRUE;\
}\
//开启一个线程，调用实际的DLL功能代码\
void NoModuleEntryCall(HMODULE hModule, DWORD ul_reason_for_call, char\*
ps\
trModuleName)\
{\
char szMutexName\[MAX_PATH\];\
wsprintf(szMutexName,\"yanshier2013nomoduleinject%d\",GetCurrentProcessI\
d());\
g_hMutex = CreateMutex(NULL, TRUE, szMutexName);\
char szLog\[MAX_PATH\] = {0};\
wsprintf(szLog,\"NoModuleEntryCall Module Start:%p\",hModule);\
OutputDebugString(szLog);\
//下面为正常Dll功能代码

CreateThread(NULL,NULL,\
(LPTHREAD_START_ROUTINE)NoModuleThread,NULL,NULL,NULL);\
}\
BOOL ChooseSub(HMODULE hModule, DWORD ul_reason_for_call, char\*
pstrModule\
Name)\
{\
BOOL bRet = FALSE;\
GetModuleFileNameA(NULL, exeModuleName, MAX_PATH);\
if ( ul_reason_for_call == NO_MODULE_MARK )\
strcpy(dllModuleName, pstrModuleName);\
else\
GetModuleFileName(hModule, dllModuleName, MAX_PATH);\
if ( ul_reason_for_call == NO_MODULE_MARK )\
{\
NoModuleEntryCall(hModule, DLL_PROCESS_ATTACH, 0);\
bRet = TRUE;\
}\
else\
{\
LaunchNoModule();\
bRet = FALSE;\
}\
return bRet;\
}\
//ul_reason_for_call等于NO_MODULE_MARK时，DllMain已经是在新申请的内存中运行\
//DllMain返回值是个很关键的地方，可能平常写DLLMain的时候不会注意到，都是直接返回\
TRUE，没有去关注FALSE的情况\
//ul_reason_for_call等于DLL_PROCESS_ATTACH时,DllMain返回FALSE会使DLL自行卸载\
//利用这一点再结合PE自行加载，就可以实现无模块注入了\
//当然，这样的DLL，如果由程序内部加载，也是以无模块的形式存在的

BOOL APIENTRY DllMain( HMODULE hModule,\
DWORD ul_reason_for_call,\
LPVOID lpReserved\
)\
{\
BOOL bRet = FALSE;\
if ( ul_reason_for_call == DLL_PROCESS_ATTACH \|\| ul_reason_for_call
==\
NO_MODULE_MARK )\
{\
char szMutexName\[MAX_PATH\];\
wsprintf(szMutexName,\"yanshier2013nomoduleinject%d\",GetCurrentProc\
essId());\
if ( IsMutexExist(szMutexName))\
return FALSE;\
bRet = ChooseSub(hModule, ul_reason_for_call, (char \*)lpReserved);\
}\
else\
{\
if ( ul_reason_for_call == DLL_PROCESS_DETACH)\
{\
ReleaseMutex(g_hMutex);\
CloseHandle(g_hMutex);\
bRet = TRUE;\
}\
}\
return bRet;\
}
