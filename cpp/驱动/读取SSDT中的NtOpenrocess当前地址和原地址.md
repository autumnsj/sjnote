ULONG GetCurAddr()\
{\
ULONG SSTD_NtOpenProcess_Cur_Addr;\
\_\_asm\
{\
push ebx\
push eax\
mov ebx, KeServiceDescriptorTable\
mov ebx, \[ebx\]\
mov eax, 0x7a\
imul eax, 4\
add ebx, eax\
mov ebx, \[ebx\]\
mov SSTD_NtOpenProcess_Cur_Addr, ebx\
pop eax\
pop ebx\
}\
return SSTD_NtOpenProcess_Cur_Addr;\
//LONG \*SSDT_Adr, SSDT_NtOpenProcess_Cur_Addr, t_addr;\
//\
////读取SSDT表中索引值为0x7A的函数\
////poi(poi(KeServiceDescriptorTable)+0x7a\*4)\
//t_addr = (LONG)KeServiceDescriptorTable-\>ServiceTableBase;\
//SSDT_Adr = (PLONG)(t_addr + 0x7A \* 4);\
//SSDT_NtOpenProcess_Cur_Addr = \*SSDT_Adr;\
//return SSDT_NtOpenProcess_Cur_Addr;\
//读取SSDT中的NtOpenrocess当前地址\
}\
ULONG GetOldAddr()\
{\
UNICODE_STRING old_NtOpenProcess;\
ULONG old_Addr;\
RtlInitUnicodeString(&old_NtOpenProcess, L\"NtOpenProcess\");\
old_Addr = (ULONG)MmGetSystemRoutineAddress(&old_NtOpenProcess);

return old_Addr;\
}
