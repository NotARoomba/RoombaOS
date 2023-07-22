#pragma once
#include "../kernel/util.h"
#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5
u8 inb (u16 port);
void outb (u16 port, u8 data);
u16 inw (u16 port);
void outw (u16 port, u16 data);