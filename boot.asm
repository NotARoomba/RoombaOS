[org 0x7c00]

getInput:
	mov bx, sp ; moves the current stack pointer to the base pointer
	getInputLoop:
		mov ah, 0
		int 0x16
		push ax
		cmp al, 0x0D
		je printInput
		jmp getInputLoop
printInput:
	sub bx, 2 ; moving down (up) the stack 
	mov al, [bx]
	mov ah, 0x0e
	int 0x10
	cmp al, 0x0D
	je end
	jmp getInput

jmp getInput
end:
	jmp $
times 510-($-$$) db 0
db 0x55, 0xaa
