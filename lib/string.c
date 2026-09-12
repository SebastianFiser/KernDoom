#include "string.h"
#include <stdarg.h>

void *memcpy(void *dest, const void *src, uint32_t n) {
    char *d = (char *)dest;
    const char *s = (const char *)src;

    for(uint32_t i = 0; i < n; i++) {
        d[i] = s[i];
    }

    return d;
}

void *memset(void *ptr, int value, uint32_t n) {
    uint8_t *p = (uint8_t *)ptr;
    uint8_t v = (uint8_t)value;

    for(uint32_t i = 0; i < n; i++) {
        p[i] = v;
    }

    return p;
}

uint32_t strlen(const char *str) {
    uint32_t count = 0;
    while(str[count] != '\0') {
        count++;
    }
    return count;
}


int strcmp(const char *str1, const char *str2) {
    while(*str1 && (*str1 == *str2)) {
        str1++;
        str2++;
    }
    return *(const unsigned char *)str1 - *(const unsigned char *)str2;
}

char *strcpy(char *dest, const char *src) {
    char *d = dest;
    while(*src) {
        *d++ = *src++;
    }
    *d = '\0';
    return dest;
}

void itoa(int value, char *buf, int base) {
    int i = 0;
    int is_negative = 0;

    if (value == 0) {
        buf[i++] = '0';
        buf[i] = '\0';
        return;
    }

    if (value < 0 && base == 10) {
        is_negative = 1;
        value = -value;
    }

    while (value != 0) {
        int digit = value % base;
        buf[i++] = digit < 10 ? '0' + digit : 'A' + digit - 10;
        value /= base;
    }

    if (is_negative) {
        buf[i++] = '-';
    }

    buf[i] = '\0';

    for (int j = 0; j < i / 2; j++) {
        char temp = buf[j];
        buf[j] = buf[i - 1 - j];
        buf[i - 1 - j] = temp;
    }
}

void sprintf(char *buf, const char *fmt, ...) {
    va_list args;
    va_start(args, fmt);

    int buf_i = 0;
    char num_buf[32];

    for (int i = 0; fmt[i] != '\0'; i++) {
        if (fmt[i] == '%') {
            i++;
            switch (fmt[i]) {
                case 'd' : {
                    int val = va_arg(args, int);
                    itoa(val, num_buf, 10);
                    strcpy(buf + buf_i, num_buf);
                    buf_i += strlen(num_buf);
                    break;
                }
                case 'x' : {
                    int val = va_arg(args, int);
                    itoa(val, num_buf, 16);
                    strcpy(buf + buf_i, num_buf);
                    buf_i += strlen(num_buf);
                    break;
                }
                case 's' : {
                    char *str = va_arg(args, char *);
                    strcpy(buf + buf_i, str);
                    buf_i += strlen(str);
                    break;
                }
                case 'c' : {
                    char ch = va_arg(args, int);
                    buf[buf_i++] = ch;
                    break;
                }
            }
        } else {
            buf[buf_i++] = fmt[i];
        }
    }

    buf[buf_i] = '\0';
    va_end(args);
}
