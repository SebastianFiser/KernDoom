#include "idt.h"
#include "../drivers/pic.h"
#include "../drivers/vga_graphics.h"
#include "../drivers/irq.h"
#include "../drivers/ata.h"
#include "wad_loader.h"

void kernel_main() {

    clear_screen_graphics(1);
    idt_init();
    pic_remap(32, 40);
    pit_set_frequency(35);
    asm volatile("sti");

    load_wad();

    char *wad_buffer = (char*)0x200000;
    if (wad_buffer[0] == 'I' && wad_buffer[1] == 'W' && wad_buffer[2] == 'A' && wad_buffer[3] == 'D') {
        clear_screen_graphics(2);
    } else {
        clear_screen_graphics(4);
    }

    while(1) {

    }
}
