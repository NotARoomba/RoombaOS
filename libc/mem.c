#include "mem.h"

void memcpy(u8 * dest, const u8 * src, unsigned long nbytes) {
    for (int i = 0; i < nbytes; i++) {
        *(dest + i) = *(src + i);
    }
}