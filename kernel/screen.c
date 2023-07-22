#include "screen.h"

void draw_pixel(int _x, int _y, unsigned int color) {
    u8* location = (u8*)0xA0000 + ((SCREEN_WIDTH * _y) + _x);
    *location = color;
}
void screen_clear(u8 color) {
    memset((void*)0xA0000, color, SCREEN_SIZE);
}
