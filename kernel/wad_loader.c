#include "wad_loader.h"
#include "../drivers/ata.h"
#include <stdint.h>

uint16_t *wad_buffer = (uint16_t*)0x200000;
uint32_t lba = WAD_START_LBA;
uint32_t sectors_remaining = WAD_TOTAL_SECTORS;

void load_wad() {
    while (sectors_remaining > 0) {
        uint8_t chunk = (sectors_remaining > MAX_SECTORS_PER_CALL)
                        ? MAX_SECTORS_PER_CALL
                        : sectors_remaining ;

        ata_read_sectors(lba, chunk, wad_buffer);

        lba += chunk;
        wad_buffer += chunk * 256;
        sectors_remaining -= chunk;
    }
}
