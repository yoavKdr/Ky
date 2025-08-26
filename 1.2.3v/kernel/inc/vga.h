#pragma once

#include <stdint.h>

struct vga_char {
    uint8_t character;
    uint8_t attribute;
} __attribute__((packed));

static volatile vga_char* const TEXT_AREA = (volatile vga_char*)0xB8000;
