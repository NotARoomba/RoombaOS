# CC=/usr/local/i386elfgcc/bin/i386-elf-gcc
# LD=/usr/local/i386elfgcc/bin/i386-elf-ld
CC=gcc
LD=ld -m elf_i386
FLAGS=-ffreestanding -m32 -fno-pie
KERNEL=$(wildcard ./kernel/*.c)
KERNELO = $(patsubst %.c,%.o,$(KERNEL))

.PHONY: run	
run: clean build
	qemu-system-i386 -drive format=raw,file=RoombaOS.bin,if=floppy
build: boot.bin kernel.bin
	cat boot.bin kernel.bin > RoombaOS.bin
boot.bin:
	nasm -f bin -o boot.bin ./boot/boot.asm
	# nasm -f bin -o zeros.bin zeros.asm
kernel.bin: kernel_entry.o $(KERNELO)
	$(LD) -o kernel.bin -Ttext 0x1000 kernel_entry.o $(KERNELO) --oformat binary
kernel_entry.o:
	nasm -f elf -o kernel_entry.o ./kernel/kernel_entry.asm
%.o: %.c
	$(CC) $(FLAGS) -c $< -o $@
clean:
	rm -fr *.bin *.o *.iso
	rm -fr ./kernel/*.bin ./kernel/*.o

