#include "idt.h"
#include <stdint.h>
struct idt_entry idt[256];

void idt_set_gate(int n, uint32_t handler, uint16_t selector, uint8_t flags) {
    idt[n].offset_low = handler & 0xFFFF;
    idt[n].offset_high = (handler >> 16) & 0xFFFF;
    idt[n].selector = selector;
    idt[n].flags = flags;
}

void idt_init() {
    struct idt_ptr idtp;
    idtp.limit = sizeof(idt) - 1;
    idtp.base = (uint32_t)idt;
    for (int i = 0; i < 256; i++) {
        idt_set_gate(i, 0, 0, 0);
    }

    idt_set_gate(0, (uint32_t)isr0, 0x08, 0x8E);
    idt_set_gate(32, (uint32_t)irq0, 0x08, 0x8E);
    idt_set_gate(33, (uint32_t)irq1, 0x08, 0x8E);

    __asm__ volatile ("lidt %0" : : "m" (idtp));
}
