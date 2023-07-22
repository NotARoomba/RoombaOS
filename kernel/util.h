#pragma once
typedef unsigned char u8;
typedef unsigned short u16;

int strlen (const char *str);
// dest, src
void memcpy(u8 *, const u8 *, unsigned long);

void itoa(int n, char s[]);
void reverse(char []);

struct vec2{
    int x;
    int y;
};
typedef struct vec2 vec2 ;