disk_load:
	; make sure to set 'dl' beforehand
	pusha
	push dx
	
	mov ah, 0x02
	mov al, dh
	mov cl, 0x02 ; 1 is boot sector, 2 is 'available'
	mov ch, 0x00 ; 0th cylinder
	mov dh, 0x00

	int 0x13 ; BIOS interrupt
	jc disk_error

	pop dx
	cmp al, dh
	jne sectors_error
	popa
	mov bx, LOADED_DISK
	call print
	ret
disk_error:
	mov bx, DISK_ERROR
	call print
	mov dh, ah
	call print_hex ; http://stanislavs.org/helppc/int_13-1.html
	jmp disk_loop
sectors_error:
	mov bx, SECTORS_ERROR
	call print
disk_loop:
	jmp $
LOADED_DISK: db "Loaded Disk...", 0
DISK_ERROR: db "Disk read error", 0
SECTORS_ERROR: db "Mismatched sectors read", 0
