#include "vga.h"
#include <stdint.h>

char *vga = (char *)0xB8000;
void clear_screen() {
    for(int i = 0; i < 2000; i++) {
        vga[i * 2 ] = ' ';
        vga[i * 2 + 1] = 0x0F;
    }
}

char nibble_to_ascii(uint8_t nibble) {
    if (nibble <= 9) {
        return '0' + nibble;
    } else {
        return 'A' + (nibble - 10);
    }
}

void print_hex(uint8_t value) {
    uint8_t top_char = nibble_to_ascii((value >> 4) & 0xF);
    uint8_t bottom_char = nibble_to_ascii(value & 0xF);
    vga[7] = top_char | (0x0F << 8);
    vga[8] = bottom_char | (0x0F << 8);
}
