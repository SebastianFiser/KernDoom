#include "idt.h"
#include "../drivers/pic.h"
#include "../drivers/vga_graphics.h"
#include "../drivers/irq.h"

void kernel_main() {

    clear_screen_graphics(4);
    idt_init();
    pic_remap(32, 40);
    pit_set_frequency(35);
    asm volatile("sti");

    while(1) {
        if (tick_count % 35 == 0) {
            clear_screen_graphics(4);
        } else if (tick_count % 35 == 17) {
            clear_screen_graphics(2);
        }
    }
}
