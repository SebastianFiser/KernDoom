#include "vga_graphics.h"
#include "font8x8_basic.h"
uint8_t *framebuffer = (uint8_t*)0xA0000;

void put_pixel(int x, int y, uint8_t color) {
    int pos = y * 320 + x;
    framebuffer[pos] = color;
}

void clear_screen_graphics(uint8_t color) {
    for(int i; i < 320*220 + 1; i++) {
        framebuffer[i] = color;
    }
}

void draw_char_pixel(int row, int col, int x, int y, char c, uint8_t color) {
    if (font8x8_basic[(int)c][row] & (1 << col)) {
        put_pixel(x + col, y + row, color);
    }
}

void draw_char(int x, int y, char c, uint8_t color) {
    for (int row = 0; row < 8; row++) {
        for (int col = 0; col < 8; col++) {
            draw_char_pixel(row, col, x, y, c, color);
        }
    }
}

void draw_string(int x, int y, const char *str, uint8_t color) {
    for (int i = 0; str[i] != '\0'; i++) {
        draw_char(x + i * 8, y, str[i], color);
    }
}
