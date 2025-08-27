#include "vga.h"
#include "portio/portio.h"


#define VGA_BUF ((uint8_t *)0xB8000)

#define VGA_WIDTH 80
#define VGA_HEIGHT 25

#define VGA_CTRL 0x3D4
#define VGA_DATA 0x3D5
#define CURSOR_HIGH 0x0E
#define CURSOR_LOW 0x0F

#define TAB_SIZE 8


uint8_t cursor_x = 0;
uint8_t cursor_y = 0;
uint8_t back_color = BLUE;

uint8_t make_color(const uint8_t fore, const uint8_t back)
{
    return (back << 4) | (fore & 0x0F);
}

void clean(void)
{
    uint8_t *vid = VGA_BUF;

    for (unsigned int i = 0; i < 80 * 25 * 2; i += 2)
    {
        vid[i] = ' ';      // сам символ
        vid[i + 1] = make_color(WHITE,back_color); // атрибут цвета
    }
}



void print_char(const char c,
                const unsigned int x,
                const unsigned int y,
                const uint8_t fore)
{
    // проверка границ экрана
    if (x >= VGA_WIDTH || y >= VGA_HEIGHT)
        return;

    uint8_t *vid = VGA_BUF;
    uint8_t color = make_color(fore, back_color);

    // вычисляем смещение в байтах
    unsigned int offset = (y * VGA_WIDTH + x) * 2;

    vid[offset] = (uint8_t)c; // ASCII‑код символа
    vid[offset + 1] = color;  // атрибут цвета
}

void print_string(const char *str,
                  const unsigned int x,
                  const unsigned int y,
                  const uint8_t fore)
{
    uint8_t *vid = VGA_BUF;
    unsigned int offset = (y * VGA_WIDTH + x) * 2;
    uint8_t color = make_color(fore, back_color);

    unsigned int col = x; // текущая колонка

    for (uint32_t i = 0; str[i]; ++i)
    {
        char c = str[i];

        if (c == '\t')
        {
            // считаем сколько пробелов до следующего кратного TAB_SIZE
            unsigned int spaces = TAB_SIZE - (col % TAB_SIZE);
            for (unsigned int s = 0; s < spaces; s++)
            {
                vid[offset] = ' ';
                vid[offset + 1] = color;
                offset += 2;
                col++;
            }
        }
        else
        {
            vid[offset] = (uint8_t)c;
            vid[offset + 1] = color;
            offset += 2;
            col++;
        }

        // если дошли до конца строки VGA
        if (col >= VGA_WIDTH)
            break; // (или можно сделать перенос)
    }
}

void update_hardware_cursor(uint8_t x, uint8_t y)
{
    uint16_t pos = y * VGA_WIDTH + x;
    // старший байт
    outb(VGA_CTRL, CURSOR_HIGH);
    outb(VGA_DATA, (pos >> 8) & 0xFF);
    // младший байт
    outb(VGA_CTRL, CURSOR_LOW);
    outb(VGA_DATA, pos & 0xFF);
}
