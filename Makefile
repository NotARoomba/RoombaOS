# CC=/usr/local/i386elfgcc/bin/i386-elf-gcc
# LD=/usr/local/i386elfgcc/bin/i386-elf-ld
CC=gcc
LD=ld -m elf_i386
CFLAGS=-ffreestanding -m32 -fno-pie
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
OBJ = ${C_SOURCES:.c=.o}

.PHONY: run	
run: clean build
	qemu-system-i386 -drive format=raw,file=RoombaOS.bin,if=floppy
build: ./boot/boot.bin kernel.bin
	cat $^ > RoombaOS.bin
kernel.bin: ./boot/kernel_entry.o ${OBJ}
	$(LD) -o $@ -Ttext 0x1000 $^ --oformat binary
%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} -ffreestanding -c $< -o $@

%.o: %.asm
	nasm $< -f elf -o $@

%.bin: %.asm
	nasm $< -f bin -o $@
clean:
	rm -fr *.bin *.o *.iso
	rm -fr ./kernel/*.bin ./kernel/*.o
	rm -fr ./boot/*.bin ./boot/*.o

