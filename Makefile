# CC=/usr/local/i386elfgcc/bin/i386-elf-gcc
# LD=/usr/local/i386elfgcc/bin/i386-elf-ld
CC=gcc
LD=ld -m elf_i386
FLAGS=-ffreestanding -m32 -fno-pie


.PHONY: run	
run: clean build
	qemu-system-i386 --nographic -fda RoombaOS.bin	
build: boot.bin kernel.bin
	cat boot.bin kernel.bin > RoombaOS.bin
boot.bin:
	nasm -f bin -o boot.bin boot.asm
	# nasm -f bin -o zeros.bin zeros.asm
kernel.bin: kernel_entry.o kernel.o
	$(LD) -o kernel.bin -Ttext 0x1000 kernel_entry.o kernel.o --oformat binary
kernel_entry.o:
	nasm -f elf -o kernel_entry.o kernel_entry.asm
kernel.o:
	$(CC) $(FLAGS) -c kernel.c -o kernel.o
clean:
	rm -fr *.bin *.o
