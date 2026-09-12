#include "irq.h"
#include "pic.h"
#include "vga.h"

volatile uint32_t tick_count = 0;

void irq0_handler() {
    outb(PIC1_COMMAND, 0x20);
    tick_count ++;
}

void irq1_handler() {
    uint8_t scancode = inb(0x60);
    print_hex(scancode);
    outb(PIC1_COMMAND,0x20);
}
