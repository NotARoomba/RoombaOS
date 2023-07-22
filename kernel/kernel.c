int __stack_chk_fail(void)
{
  return 0;
}

void print_c(char c, int color, volatile char *video) {
  *video++ = c;
  *video++ = color;
}

void kmain() {
  volatile char *video = (volatile char*)0xb8000;
  print_c('X', 0x0a, video);
  video++;
  video++;
  print_c('X', 0x0a, video);
}
