[bits 32]
VIDEO_MEMORY equ 0xb8000
COLOR equ 0x0f
print_pm:
	pusha
	mov edx, VIDEO_MEMORY
print_pm_loop:
	mov al, [ebx] ; address of char
	mov ah, COLOR

	cmp al, 0
	je print_pm_return

	mov [edx], ax
	inc ebx
	add edx, 2

	jmp print_pm_loop

print_pm_return:
	popa
	ret
