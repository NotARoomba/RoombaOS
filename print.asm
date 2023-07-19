print:
	;makse sure value is in bx
	pusha
loop:
	mov al, [bx]
	cmp al, 0
	je return
	mov ah, 0x0e
	int 0x10
	inc bx
	jmp loop
return:
	call newline
	popa
	ret
newline:
	mov ah, 0x0e ; just in case
	mov al, 0x0a ; newline
	int 0x10
	mov al, 0x0d ; carriage return
	int 0x10
	ret
print_hex:
	pusha

	mov cx, 0
hex_loop:
	cmp cx, 4
	je end

	;convert last char to acsii
	mov ax, dx
	and ax, 0x000f
	add al, 0x30
	cmp al, 0x39
	jle step2
	add al, 7
step2:
	mov bx, HEX_OUT + 5
	sub bx, cx
	mov [bx], al
	ror dx, 4

	inc cx
	jmp hex_loop
end:
	;print
	mov bx, HEX_OUT
	call print
	popa
	ret
	
HEX_OUT: db '0x0000', 0
