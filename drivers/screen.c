#include "screen.h"
#include "ports.h"
void __stack_chk_fail(){};
// Graphics mode function
void draw_pixel(int _x, int _y, u8 color) {
    u8* location = (u8*)0xA0000 + ((SCREEN_WIDTH * _y) + _x);
    *location = color;
}


int get_cursor_pos() {
    int offset = 0;
    outb(REG_SCREEN_CTRL, 0x0F);
    offset |= inb(REG_SCREEN_DATA);
    outb(REG_SCREEN_CTRL, 0x0E);
    offset |= ((u16)inb(REG_SCREEN_DATA)) << 8;
    //times 2 because of 1 st byte of the character and then the second one for the color
    return offset*2;
}
void update_cursor(int offset) {
    offset/=2;
	outb(REG_SCREEN_CTRL, 0x0F);
	outb(REG_SCREEN_DATA, (u16) (offset & 0xFF));
	outb(REG_SCREEN_CTRL, 0x0E);
	outb(REG_SCREEN_DATA, (u16) ((offset >> 8) & 0xFF));
}

int print_char(char c, u8 color, int x, int y) {
    u8* video = (u8*)0xB8000;
    int offset;
    //checks if position is at cursot
    if (x <= 0 && y <= 0) offset = get_cursor_pos();
    // else sets the cursor offset to the x and y pos
    else offset = (2*(y*TEXT_WIDTH + x));
    // checks if there is a newline and then updates the offset
    if (c == '\n') offset = (2*((y+1)*TEXT_WIDTH + 0));
    //else updates the video buffer plus the offset of the cursor with the color and then updates the offset
    else {
        *(video + offset) = c;
        *(video + offset + 1) = color;
        offset+=2;
    }
    update_cursor(offset);
    return offset;
}
void print(char* string, u8 color, int x, int y) {
    for (int i = 0; string[i] != 0; i++) {
        int offset = print_char(string[i], color, x, y);
        x = (offset%TEXT_WIDTH)/2;
        y = (offset/TEXT_WIDTH)/2;
    }
}