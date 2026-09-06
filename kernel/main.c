char *vga = (char *) 0xB8000;

void kernel_main() {

    vga[0] = 'x';
    vga[1] = 0x0F;

    while(1) {

    }
}
