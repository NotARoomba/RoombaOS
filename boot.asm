[org 0x7c00]
mov ah, 0
int 0x16
mov bx, buffer
mov [bx], al
inc bx
jmp bloop
buffer:
	times 10 db 0
bloop:
	mov ah, 0
	int 0x16
	cmp bx, buffer+10
	je printBuffer
	mov [bx], al
	inc bx
	jmp bloop
printBuffer:
	mov ah, 0x0e
	mov bx, buffer
	jmp ploop
ploop:
	mov al, [bx]
	cmp bx, buffer+10
	je end
	int 0x10
	inc bx
	jmp ploop
			
	
end:
	jmp $
times 510-($-$$) db 0
db 0x55, 0xaa
