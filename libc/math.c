#include "math.h"
int ceil(int x, int y) {
    return (x + y - 1) / y;
}
int abs(int x) {
    return x>0?1:x<0?-1:0;
}