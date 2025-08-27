// kernel.c
#include "vga/vga.h"
#include "keyboard/keyboard.h"


uint8_t counter = 0;
uint8_t counter_lines = 4;
uint8_t key_pressed = 0;


void kernel_main() {
    clean();
    print_string("loading...", 0, 0, WHITE);
    print_string("Kernel Ready! Press keys", 0, 1, WHITE);
    
    while (1) {
        keyboard_handler();
        char ch = kbd_getchar();
        if (ch == '\n'&& !key_pressed){
            counter = 0;
            if (counter_lines < 25){
                counter_lines += 1;
            }else{
                counter_lines = 0;
            }
            key_pressed = 1;
        }else if (ch != -1 && !key_pressed) {
            print_char(ch, counter, counter_lines, WHITE);
            counter += 1;
            if (counter > 80){
                if (counter_lines >= 25){
                    clean();
                    counter_lines = 0;
                }else{
                    counter_lines += 1;
                }
                counter = 0;
            }
            key_pressed = 1;
        }
        else if (ch == -1) {
            key_pressed = 0;
        }
        update_hardware_cursor(counter,counter_lines);
    }
}