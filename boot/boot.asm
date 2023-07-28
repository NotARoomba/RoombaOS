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
	call activate_a20
	mov eax, cr0        ; cr0 cannot be manipulated directly, manipulate eax instead
	and ax, 0xFFFB      ; clear coprocessor emulation CR0.EM
	or ax, 0x2          ; set coprocessor monitoring  CR0.MP
	mov cr0, eax
	mov eax, cr4        ; cr4 too cannot be manipulated directly
	or ax, 3 << 9       ; set CR4.OSFXSR and CR4.OSXMMEXCPT at the same time
	mov cr4, eax
	;text mode
	mov ah, 0x0
	mov al, 0x3
	int 0x10
	;video mode
	; mov ax, 0x13
	; int 0x10
	cli
	lgdt [gdt_descriptor]
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax
	jmp CODE_SEG:START_PM
activate_a20:
	pusha
	mov     ax,2403h                ;--- A20-Gate Support ---
	int     15h
	jb      a20_failed                  ;INT 15h is not supported
	cmp     ah,0
	jnz     a20_failed                  ;INT 15h is not supported
	
	mov     ax,2402h                ;--- A20-Gate Status ---
	int     15h
	jb      a20_failed              ;couldn't get status
	cmp     ah,0
	jnz     a20_failed              ;couldn't get status
	
	cmp     al,1
	jz      a20_activated           ;A20 is already activated
	
	mov     ax,2401h                ;--- A20-Gate Activate ---
	int     15h
	jb      a20_failed              ;couldn't activate the gate
	cmp     ah,0
	jnz     a20_failed              ;couldn't activate the gate
a20_failed:
	mov bx, A20_E
	call print
	jmp $
a20_activated:
	mov bx, A20_SUCCESS
	call print
	popa
	ret
load_kernel:
	mov bx, MSG_LOAD_KERNEL
	call print

	mov bx, KERNEL_OFFSET
	mov dh, 40; sectors
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
	call KERNEL_OFFSET
	jmp $

MSG_REAL_MODE: db "Started in 16-bit real mode", 0
MSG_PROT_MODE: db "Loaded 32-bit protected mode", 0
MSG_LOAD_KERNEL: db "Loading kernel...", 0
A20_E: db "A20 ER", 0
A20_SUCCESS: db "A20 Done", 0
times 510-($-$$) db 0
db 0x55, 0xaa
