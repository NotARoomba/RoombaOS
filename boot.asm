[org 0x7c00]

KERNEL_OFFSET equ 0x1000

BOOT_DISK: db 0
mov [BOOT_DISK], dl ; set boot disk

; stack and base pointer
mov bp, 0x9000
mov sp, bp

;text mode to clear screen
mov ah, 0x0
mov al, 0x3
int 0x10
call load_kernel
call switch_to_pm
jmp $

%include "disk.asm"
%include "print.asm"
%include "print32.asm"
%include "gdt.asm"
%include "switch.asm"
[bits 16]
load_kernel:
	mov bx, MSG_LOAD_KERNEL
	call print

	mov bx, KERNEL_OFFSET
	mov dh, 2 ; sectors
	mov dl, [BOOT_DISK]
	call disk_load
	ret
[bits 32]
START_PM:
	mov ebx, MSG_PROT_MODE
	call print_pm
	call KERNEL_OFFSET
	jmp $

MSG_REAL_MODE: db "Started in 16-bit real mode", 0
MSG_PROT_MODE: db "Loaded 32-bit protected mode", 0
MSG_LOAD_KERNEL: db "Loading kernel...", 0
times 510-($-$$) db 0
db 0x55, 0xaa
