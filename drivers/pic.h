#pragma once
#include <stdint.h>
#include "../lib/io.h"

#define PIC1_COMMAND 0x20
#define PIC1_DATA 0x21
#define PIC2_COMMAND 0xA0
#define PIC2_DATA 0xA1

#define ICW1_INIT 0x11
#define ICW4_8086 0x01

#define BASE 1193182

void pic_remap(int offset1, int offset2);
void pit_set_frequency(uint32_t hz);
