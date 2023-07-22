global _start;
_start:
[bits 32]
[extern kmain]
call kmain
jmp $
