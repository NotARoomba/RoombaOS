#pragma once
typedef unsigned char u8;
typedef unsigned short u16;

int strlen (const char *str);
void memcpy(void *, const void *, unsigned long);

struct vec2{
    int x;
    int y;
};
typedef struct vec2 vec2 ;