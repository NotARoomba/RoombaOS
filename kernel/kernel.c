
#include "util.h"
#include "text.h"
#include "screen.h"

void kmain() {
  // screen_clear(0x00);
  for(int i = 0; i<10; i++) {
    draw_pixel(i,i,0x0a);
  }
  draw_char(100, 100, 35, 0x0a);
  //print("aaaaaaaaaaaaa", 0x0a);
  //print_c('X', 0x0a);
}
