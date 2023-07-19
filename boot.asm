mov ah, 0x0e
mov al, 'A'
int 0x10
loop:
	inc al
	add al, 32
	int 0x10
	inc al
	cmp al, 'z' + 1
	je end	
	sub al, 32
	int 0x10
	jmp loop

end:
	jmp $
times 510-($-$$) db 0
db 0x55, 0xaa
