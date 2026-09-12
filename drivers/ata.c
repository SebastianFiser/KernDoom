#include "ata.h"
#include "../lib/io.h"

void ata_read_sectors(uint32_t lba, uint8_t count, uint16_t *buffer) {
    outb(0x3F6, 0x02);

    outb(0x1F6, 0xE0 | ((lba >> 24) & 0x0F));

    outb(0x1F2, count);

    outb(0x1F3, lba & 0xFF);
    outb(0x1F4, (lba >> 8) & 0xFF);
    outb(0x1F5, (lba >> 16) & 0xFF);

    outb(0x1F7, 0x20);


    for ( int sector = 0; sector < count; sector++) {
        while (!(inb(0x1F7) & 0x08)) {

        }

        for (int i = 0; i < 256; i++) {
            buffer[i] = inw(0x1F0);
        }

        buffer += 256;

    }

}
