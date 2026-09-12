#pragma once
#include <stdint.h>

extern volatile uint32_t tick_count;

void irq0_handler(void);
void irq1_handler(void);
