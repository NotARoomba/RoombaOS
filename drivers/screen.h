#pragma once
#include "../kernel/util.h"
#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 200
#define SCREEN_SIZE (SCREEN_WIDTH *  SCREEN_HEIGHT)

#define TEXT_HEIGHT 25
#define TEXT_WIDTH 80


void draw_pixel(int _x, int _y, u8 color);

int print_char(char c, u8 color, int _x, int _y);
void print(char* string, u8 color, int x, int y);