
#include "kernel.h"
#include "../libc/string.h"
#include "../drivers/screen.h"
#include "../interrupts/isr.h"

void kmain() {
  // Graphics mode test
  //draw_text(0, 0, "Welcome to RoombaOS!", 0x0a);
  // Test mode test
  //print("start\n", 0x0a, -1, -1);
  isr_install();
    irq_install();

    printf("Type something, it will go through the kernel. Type END to halt the CPU\n> ");
}

void user_input(char *input) {
    if (strcmp(input, "END") == 0) {
        printf("Stopping the CPU. Bye!\n");
        asm volatile("hlt");
    }
    printf("You said: ");
    printf(input);
    printf("\n> ");
}