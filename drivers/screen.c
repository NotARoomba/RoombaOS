#include "screen.h"
#include "ports.h"
#include "../libc/mem.h"
#include "../libc/math.h"

void __stack_chk_fail(){};
// Graphics mode function
void draw_pixel(int _x, int _y, u8 color) {
    u8* location = (u8*)0xA0000 + ((SCREEN_WIDTH * _y) + _x);
    *location = color;
}


int get_cursor_pos() {
    outb(REG_SCREEN_CTRL, 14);
    int offset = inb(REG_SCREEN_DATA) << 8; /* High byte: << 8 */
    outb(REG_SCREEN_CTRL, 15);
    offset += inb(REG_SCREEN_DATA);
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
void print_backspace() {
    int offset = get_cursor_pos()-2;
    int row = offset / (2 * TEXT_WIDTH);
    int col = (offset - (row*2*TEXT_WIDTH))/2;
    if (col<= 1) return; 
    print_char(0x00, 0x0f, col, row);
    update_cursor(offset);
}


int print_char(char c, u8 color, int x, int y) {
    u8* video = (u8*)0xB8000;
    int offset;
    //checks if position is at cursot
    if (x < 0 && y < 0) offset = get_cursor_pos();
    // else sets the cursor offset to the x and y pos
    else offset = (2*(y*TEXT_WIDTH + x));
    // checks if there is a newline and then updates the offset
    if (c == '\n') offset = (2*(((offset / (2 * TEXT_WIDTH))+1)*TEXT_WIDTH));
    //else updates the video buffer plus the offset of the cursor with the color and then updates the offset
    else {
        *(video + offset) = c;
        *(video + offset + 1) = color;
        offset+=2;
    }
    if (offset >= (TEXT_SIZE * 2)) {
        //need to move every i row to i-1 where i is 1
        for (int i = 1; i < TEXT_HEIGHT; i++) {
            //copy the row back
            memcpy(video + (2*((i-1)*TEXT_WIDTH)),video + (2*(i*TEXT_WIDTH)), TEXT_WIDTH*2);
        }
        // the last line has remenants from the prevoius offset
        u8* line = video + (2*((TEXT_HEIGHT-1)*TEXT_WIDTH));
        for (int i = 0; i < (TEXT_WIDTH*2); i++) line[i] = 0;
        offset -= (2*TEXT_WIDTH);
    }
    update_cursor(offset);
    return offset;
}
void print(char* string, u8 color, int x, int y) {
    for (int i = 0; string[i] != 0; i++) {
        int offset = print_char(string[i], color, x, y);
        y = ((offset/TEXT_WIDTH)/2);
        x = (offset - (y*2*TEXT_WIDTH))/2;
    }
}
void printf(char* string)  {
    print(string, 0x0f, -1, -1);
}