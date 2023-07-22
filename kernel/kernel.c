
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
    print("Welcome to RoombaOS!\n", 0x0C, -1, -1);
    printf("Type HELP for a list of commands\n> ");
}

void user_input(char *input) {
    if (strcmp(input, "END") == 0) {
        printf("Stopping the CPU. Bye!\n");
        asm volatile("hlt");
    } else if(strcmp(input, "HELP") == 0) {
      printf("List of Commands: \n");
      printf("HELP - shows this menu\n");
      printf("END - stops the CPU");
    } else {
      printf("\"");
      printf(input);
      printf("\"");
      printf(" is not a command. Type HELP for a list of commands.");
    }
    printf("\n> ");
}