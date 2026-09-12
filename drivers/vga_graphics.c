#include "vga_graphics.h"

uint8_t *framebuffer = (uint8_t*)0xA0000;

void put_pixel(int x, int y, uint8_t color) {
    int pos = y * 320 + x;
    framebuffer[pos];
}

void clear_screen_graphics(uint8_t color) {
    for(int i; i < 320*220 + 1; i++) {
        framebuffer[i] = color;
    }
}
