
CC = i686-elf-gcc
CFLAGS = -ffreestanding -c
.PHONY: run clean

boot.bin: boot/boot.asm
	nasm -f bin boot/boot.asm -o boot.bin

entry.o: kernel/entry.asm
	nasm -f elf32 kernel/entry.asm -o entry.o

kernel.o: kernel/main.c
	$(CC) $(CFLAGS) -o kernel.o kernel/main.c

kernel.elf: kernel.o entry.o linker.ld
	i686-elf-ld -T linker.ld -o kernel.elf entry.o kernel.o

kernel.bin: kernel.elf
	i686-elf-objcopy -O binary kernel.elf kernel.bin

os-image.bin: kernel.bin boot.bin
	cat boot.bin kernel.bin > os-image.bin
	truncate -s 65536 os-image.bin

run: os-image.bin
	qemu-system-i386 -drive format=raw,file=os-image.bin

clean:
	rm -f kernel.elf kernel.o boot.bin entry.o kernel.bin os-image.bin
