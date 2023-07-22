# CC=/usr/local/i386elfgcc/bin/i386-elf-gcc
# LD=/usr/local/i386elfgcc/bin/i386-elf-ld
CC=gcc
LD=ld -m elf_i386
CFLAGS=-ffreestanding -m32 -fno-pie
C_SOURCES = $(wildcard kernel/*.c drivers/*.c interrupts/*.c libc/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h interrupts/*.h libc/*.h)
OBJ = ${C_SOURCES:.c=.o interrupts/interrupt.o}

.PHONY: run	
run: clean build
	qemu-system-i386 -drive format=raw,file=RoombaOS.bin,if=floppy
	#qemu-system-i386 -drive format=raw,file=RoombaOS.iso
build: ./boot/boot.bin kernel.bin
	cat $^ > RoombaOS.bin
kernel.bin: ./boot/kernel_entry.o ${OBJ}
	$(LD) -o $@ -Ttext 0x1000 $^ --oformat binary
%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} -c $< -o $@

%.o: %.asm
	nasm $< -f elf -o $@

%.bin: %.asm
	nasm $< -f bin -o $@
clean:
	rm -fr *.bin *.o *.iso
	rm -fr ./kernel/*.bin ./kernel/*.o ./drivers/*.o ./boot/*.bin ./boot/*.o ./interrupts/*.bin ./interrupts/*.o ./libc/*.bin ./libc/*.o
iso: ./boot/boot.bin kernel.bin
	dd if=/dev/zero of=RoombaOS.iso bs=512 count=2880
	dd if=./boot/boot.bin of=RoombaOS.iso conv=notrunc bs=512 seek=0 count=1
	dd if=./kernel.bin of=RoombaOS.iso conv=notrunc bs=512 seek=1 count=2048
	
