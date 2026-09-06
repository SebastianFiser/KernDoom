#include "idt.h"

void clear_screen() {
    char *vga = (char *)0xB8000;
    for(int i = 0; i < 2000; i++) {
        vga[i * 2 ] = ' ';
        vga[i * 2 + 1] = 0x0F;
    }
}

void kernel_main() {

    clear_screen();
    idt_init();
    __asm__ volatile ("int $0x0");

    while(1) {

    }
}
