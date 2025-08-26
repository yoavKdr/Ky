#include "inc/vga.h"

extern "C" void main() {
    const vga_char clear_char = {' ', 0x47};

    for (int i = 0; i < 80 * 25; ++i) {
        TEXT_AREA[i].character = clear_char.character;
        TEXT_AREA[i].attribute = clear_char.attribute;
    }

    const char* msg = "Hello from C++ kernellol!";
    for (int i = 0; msg[i]; ++i) {
        TEXT_AREA[i].character = msg[i];
        TEXT_AREA[i].attribute = 0x2F;
    }

    while (1) {
        asm volatile("hlt");
    }
}
