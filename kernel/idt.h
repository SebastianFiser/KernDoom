#pragma once
#include <stdint.h>
extern void isr0();

struct idt_entry {
    uint16_t offset_low;
    uint16_t selector;
    uint8_t reserved;
    uint8_t flags;
    uint16_t offset_high;
}__attribute__((packed));
extern struct idt_entry idt[256];

struct idt_ptr {
    uint16_t limit;
    uint32_t base;
}__attribute__((packed));


void idt_init();
