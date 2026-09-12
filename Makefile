
CC = i686-elf-gcc
CFLAGS = -ffreestanding -c
BUILD_DIR = build
KERNEL_RESERVED_SECTORS = 20
WAD_START_LBA = 21
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

$(BUILD_DIR)/wad_loader.o: kernel/wad_loader.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/wad_loader.o kernel/wad_loader.c

$(BUILD_DIR)/ata.o: drivers/ata.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/ata.o drivers/ata.c

$(BUILD_DIR)/string.o: lib/string.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/string.o lib/string.c

$(BUILD_DIR)/kernel.o: kernel/main.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/kernel.o kernel/main.c

kernel.elf: $(BUILD_DIR)/kernel.o $(BUILD_DIR)/entry.o $(BUILD_DIR)/string.o $(BUILD_DIR)/wad_loader.o $(BUILD_DIR)/ata.o $(BUILD_DIR)/idt.o $(BUILD_DIR)/isr_asm.o $(BUILD_DIR)/isr.o $(BUILD_DIR)/irq.o $(BUILD_DIR)/pic.o $(BUILD_DIR)/vga.o $(BUILD_DIR)/vga_graphics.o linker.ld
	i686-elf-ld -T linker.ld -o kernel.elf $(BUILD_DIR)/entry.o $(BUILD_DIR)/kernel.o $(BUILD_DIR)/string.o $(BUILD_DIR)/wad_loader.o $(BUILD_DIR)/ata.o $(BUILD_DIR)/idt.o $(BUILD_DIR)/isr_asm.o $(BUILD_DIR)/isr.o $(BUILD_DIR)/irq.o $(BUILD_DIR)/pic.o $(BUILD_DIR)/vga.o $(BUILD_DIR)/vga_graphics.o

kernel.bin: kernel.elf
	i686-elf-objcopy -O binary kernel.elf kernel.bin

os-image.bin: kernel.bin boot.bin doom1.wad
	@KSIZE=$$(wc -c < kernel.bin); \
	MAX=$$(( $(KERNEL_RESERVED_SECTORS) * 512)); \
	if [ $$KSIZE -gt $$MAX ]; then \
		echo "ERROR: kernel.bin ($$KSIZE B) overgrown reserve ($$MAX)!"; \
		exit 1; \
	fi
	cp kernel.bin kernel_padded.bin
	truncate -s $$(( $(KERNEL_RESERVED_SECTORS) * 512 )) kernel_padded.bin
	cat boot.bin kernel_padded.bin doom1.wad > os-image.bin

run: os-image.bin
	qemu-system-i386 -drive format=raw,file=os-image.bin -m 32 -no-reboot -no-shutdown

clean:
	rm -rf $(BUILD_DIR)
