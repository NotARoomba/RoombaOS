#include "util.h"

int strlen(const char *str) {
    int i;
    for (i = 0; str[i] != 0; i++);
    return i;
}
// BOOK OF C
 void reverse(char s[]) {
     int i, j;
     char c;
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
}  

 void itoa(int n, char s[]) {
     int i, sign;

     if ((sign = n) < 0)  /* record sign */
         n = -n;          /* make n positive */
     i = 0;
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
     } while ((n /= 10) > 0);     /* delete it */
     if (sign < 0)
         s[i++] = '-';
     s[i] = '\0';
     reverse(s);
}  

void memcpy(u8 * dest, const u8 * src, unsigned long nbytes) {
    for (int i = 0; i < nbytes; i++) {
        *(dest + i) = *(src + i);
    }
}