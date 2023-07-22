
#include "util.h"
#include "text.h"
#include "../drivers/screen.h"

void kmain() {
  // Graphics mode test
  //draw_text(0, 0, "Welcome to RoombaOS!", 0x0a);
  // Test mode test
  print("start", 0x0a, -1, -1);
  print("hello\nworld\na", 0x0a, 0, 23);
}
