#include "util.h"

int strlen(const char *str) {
    int i;
    for (i = 0; str[i] != 0; i++);
    return i;
}

void memcpy(void * src, const void * dest, unsigned long nbytes) {

}