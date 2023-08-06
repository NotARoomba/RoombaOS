#pragma once
#include "../kernel/types.h"
#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 200
#define SCREEN_SIZE (SCREEN_WIDTH *  SCREEN_HEIGHT)

#define GC_SIZE 8

#define TEXT_HEIGHT 25
#define GTEXT_HEIGHT (SCREEN_HEIGHT/GC_SIZE)
#define TEXT_WIDTH 80
#define GTEXT_WIDTH (SCREEN_WIDTH/GC_SIZE)
#define TEXT_SIZE (TEXT_HEIGHT*TEXT_WIDTH)
#define GTEXT_SIZE (GTEXT_HEIGHT*GTEXT_WIDTH)

#define TEXT_MODE 0

void draw_pixel(vec2 pos, u8 color);
vec2 draw_char(char c, u8 color, vec2 pos);
void draw_text(char* string, u8 color, vec2 pos);
void draw_textf(char* string);
void draw_line(vec2 start, vec2 end, u8 color);
void draw_backspace();

int print_char(char c, u8 color, vec2 pos);
void print(char* string, u8 color, vec2 pos);
void printf(char* string);
void print_backspace();