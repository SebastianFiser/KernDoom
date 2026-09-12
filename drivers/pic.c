#include "pic.h"

void pic_remap(int offset1, int offset2) {
    outb(PIC1_COMMAND, ICW1_INIT);
    io_wait();
    outb(PIC2_COMMAND, ICW1_INIT);
    io_wait();

    outb(PIC1_DATA, offset1);
    io_wait();
    outb(PIC2_DATA, offset2);
    io_wait();

    outb(PIC1_DATA, 4);
    io_wait();

    outb(PIC2_DATA, 2);
    io_wait();

    outb(PIC1_DATA, ICW4_8086);
    io_wait();
    outb(PIC2_DATA, ICW4_8086);
    io_wait();

}

void pit_set_frequency(uint32_t hz) {
    uint16_t divisor = BASE / hz;
    outb(0x43, 0x36);
    io_wait();
    outb(0x40, divisor & 0xFF);
    io_wait();
    outb(0x40, (divisor >> 8) & 0xFF);
    io_wait();
}
