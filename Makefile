
CC = i686-elf-gcc
CFLAGS = -ffreestanding -c
BUILD_DIR = build
.PHONY: run clean all

all: os-image.bin

$(BUILD_DIR):
	mkdir -p ./$(BUILD_DIR)

boot.bin: boot/boot.asm
	nasm -f bin boot/boot.asm -o boot.bin

$(BUILD_DIR)/entry.o: kernel/entry.asm | $(BUILD_DIR)
	nasm -f elf32 kernel/entry.asm -o $(BUILD_DIR)/entry.o

$(BUILD_DIR)/idt.o: kernel/idt.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/idt.o kernel/idt.c

$(BUILD_DIR)/isr_asm.o: kernel/isr.asm | $(BUILD_DIR)
	nasm -f elf32 kernel/isr.asm -o $(BUILD_DIR)/isr_asm.o

$(BUILD_DIR)/isr.o: kernel/isr.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/isr.o kernel/isr.c

$(BUILD_DIR)/irq.o: drivers/irq.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/irq.o drivers/irq.c

$(BUILD_DIR)/pic.o: drivers/pic.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/pic.o drivers/pic.c

$(BUILD_DIR)/vga.o: drivers/vga.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/vga.o drivers/vga.c

$(BUILD_DIR)/vga_graphics.o: drivers/vga_graphics.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/vga_graphics.o drivers/vga_graphics.c

$(BUILD_DIR)/kernel.o: kernel/main.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/kernel.o kernel/main.c

kernel.elf: $(BUILD_DIR)/kernel.o $(BUILD_DIR)/entry.o $(BUILD_DIR)/idt.o $(BUILD_DIR)/isr_asm.o $(BUILD_DIR)/isr.o $(BUILD_DIR)/irq.o $(BUILD_DIR)/pic.o $(BUILD_DIR)/vga.o $(BUILD_DIR)/vga_graphics.o linker.ld
	i686-elf-ld -T linker.ld -o kernel.elf $(BUILD_DIR)/entry.o $(BUILD_DIR)/kernel.o $(BUILD_DIR)/idt.o $(BUILD_DIR)/isr_asm.o $(BUILD_DIR)/isr.o $(BUILD_DIR)/irq.o $(BUILD_DIR)/pic.o $(BUILD_DIR)/vga.o $(BUILD_DIR)/vga_graphics.o

kernel.bin: kernel.elf
	i686-elf-objcopy -O binary kernel.elf kernel.bin

os-image.bin: kernel.bin boot.bin
	cat boot.bin kernel.bin > os-image.bin
	truncate -s 65536 os-image.bin

run: os-image.bin
	qemu-system-i386 -drive format=raw,file=os-image.bin

clean:
	rm -rf $(BUILD_DIR)
