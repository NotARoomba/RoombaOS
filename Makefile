.PHONY: run	
run: build
	qemu-system-x86_64 --nographic RoombaOS.bin	
build: boot.bin
	mv boot.bin RoombaOS.bin
boot.bin:
	nasm -f bin -o boot.bin boot.asm
