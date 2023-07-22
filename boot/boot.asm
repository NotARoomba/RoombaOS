[bits 16]
[org 0x7c00]

KERNEL_OFFSET equ 0x1000

BOOT_DISK: db 0
mov [BOOT_DISK], dl ; set boot disk

; stack and base pointer
xor ax, ax
mov es, ax
mov ds, ax
mov bp, 0x9000
mov sp, bp

;text mode to clear screen
call load_kernel

call switch_to_pm
jmp $

%include "./boot/disk.asm"
%include "./boot/print.asm"
%include "./boot/gdt.asm"
switch_to_pm:
	mov ax, 0x2401 ; A20?
	int 0x15
	mov ah, 0x0
	mov al, 0x3
	int 0x10
	cli
	lgdt [gdt_descriptor]
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax
	jmp CODE_SEG:START_PM
load_kernel:
	mov bx, MSG_LOAD_KERNEL
	call print

	mov bx, KERNEL_OFFSET
	mov dh, 2 ; sectors
	mov dl, [BOOT_DISK]
	call disk_load
	ret

%include "./boot/print32.asm"

[bits 32]
START_PM:
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000
	mov esp, ebp

	; mov ebx, MSG_PROT_MODE
	; call print_pm
	call KERNEL_OFFSET
	jmp $

MSG_REAL_MODE: db "Started in 16-bit real mode", 0
MSG_PROT_MODE: db "Loaded 32-bit protected mode", 0
MSG_LOAD_KERNEL: db "Loading kernel...", 0
times 510-($-$$) db 0
db 0x55, 0xaa
