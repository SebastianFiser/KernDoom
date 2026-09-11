#include "idt.h"
#include "../drivers/pic.h"
#include "../drivers/vga.h"

void kernel_main() {

    clear_screen();
    idt_init();
    pic_remap(32, 40);
    asm volatile("sti");

    while(1) {

    }
}
