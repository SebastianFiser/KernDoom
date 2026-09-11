#include "irq.h"
#include "pic.h"
#include <stdint.h>
#include "vga.h"

static int tick_count = 0;

void irq0_handler() {
    outb(PIC1_COMMAND, 0x20);
    tick_count ++;
    uint16_t* vga = (uint16_t *)0xB8000;
        vga[0] = ('A' + (tick_count % 26)) | (0x0F << 8);
}

void irq1_handler() {
    uint8_t scancode = inb(0x60);
    print_hex(scancode);
    outb(PIC1_COMMAND,0x20);
}
