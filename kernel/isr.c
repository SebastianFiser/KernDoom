#include "isr.h"

void fault_handler() {
    char *vga = (char *)0xB8000;
    vga[0] = 'D';
    vga[1] = 0x0F;
}
