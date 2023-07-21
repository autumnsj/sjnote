关于PG

8B C7 48 8B 7C 24 68 4883 C4 40 41 5C C3 CC CC

8B C4 53 5 57 41 54

48h,8Bh,4h

mov rax, rs

B0h,01h,C3h

mov al,1

ret

winload.exe

EC 58 0F 00 00 33 FF39 3D 48 19 D1 FF

81 EC 58 0F 00 00

07

jz short loc_140561371

90

nop

ntoskrnl.exe

5C 24 08 57 48 83 EC 20 33 DB 38 1D 16 1D E1 FF

0F 85 94 00 00 00 33 C0

0Fh,85h,94h,00h,00h,00h

jnz loc_1403EAB0C

E9h,94h,00h,00h,00h

nop

jmp loc_1403EAB0C

