#pragma once

#include <stdint.h>

void *memcpy(void *dest, const void *src, uint32_t n);

void *memset(void *ptr, int value, uint32_t n);

uint32_t strlen(const char *str);

int strcmp(const char *str1, const char *str2);

char *strcpy(char *dest, const char *src);

void sprintf(char *dest, const char *format, ...);
