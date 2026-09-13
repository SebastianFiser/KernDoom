#include "sys.h"

void halt_system() {
    __asm__ volatile("cli");
    while(1) {
        __asm__ volatile("hlt");
    }
}
