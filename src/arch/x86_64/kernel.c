#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

enum vga_color {
	COLOR_BLACK = 0,
	COLOR_BLUE = 1,
	COLOR_GREEN = 2,
	COLOR_CYAN = 3,
	COLOR_RED = 4,
	COLOR_MAGENTA = 5,
	COLOR_BROWN = 6,
	COLOR_LIGHT_GREY = 7,
	COLOR_DARK_GREY = 8,
	COLOR_LIGHT_BLUE = 9,
	COLOR_LIGHT_GREEN = 10,
	COLOR_LIGHT_CYAN = 11,
	COLOR_LIGHT_RED = 12,
	COLOR_LIGHT_MAGENTA = 13,
	COLOR_LIGHT_BROWN = 14,
	COLOR_WHITE = 15,
};

uint8_t make_color(enum vga_color fg, enum vga_color bg) {
	return fg | bg << 4;
}

uint16_t make_vgaentry(char c, uint8_t color) {
	uint16_t c16 = c;
	uint16_t color16 = color;
	return c16 | color16 << 8;
}

size_t strlen(const char* str) {
	size_t len = 0;
	while (str[len])
		len++;
	return len;
}

static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;

size_t terminal_row;
size_t terminal_column;
uint8_t terminal_color;
uint16_t* terminal_buffer;

void terminal_initialize() {
	terminal_row = 0;
	terminal_column = 0;
	terminal_color = make_color(COLOR_LIGHT_GREY, COLOR_BLACK);
	terminal_buffer = (uint16_t*) 0xB8000;
	for (size_t y = 0; y < VGA_HEIGHT; y++) {
		for (size_t x = 0; x < VGA_WIDTH; x++) {
			const size_t index = y * VGA_WIDTH + x;
			terminal_buffer[index] = make_vgaentry(' ', terminal_color);
		}
	}
}

void terminal_setcolor(uint8_t color) {
	terminal_color = color;
}

void terminal_putentryat(char c, uint8_t color, size_t x, size_t y) {
	const size_t index = y * VGA_WIDTH + x;
	terminal_buffer[index] = make_vgaentry(c, color);
}

void terminal_scroll(){
    for(size_t height_c = 0; height_c < VGA_HEIGHT - 1; height_c++){
        for (size_t width_c = 0; width_c < VGA_WIDTH; width_c++){
			size_t to = height_c * VGA_WIDTH + width_c;
			size_t from = (height_c + 1) * VGA_WIDTH + width_c;
            terminal_buffer[to] = terminal_buffer[from];
        }
    }
}

void terminal_putchar(char c) {
	if (c == '\n')
    {
        terminal_column = 0;
        if(++terminal_row == VGA_HEIGHT) {
            terminal_scroll();
        }
    }
    else {
        terminal_putentryat(c, terminal_color, terminal_column, terminal_row);
    }
	if (++terminal_column == VGA_WIDTH) {
		terminal_column = 0;
		if (++terminal_row == VGA_HEIGHT) {
            terminal_scroll();
        }
	}
}

void terminal_writestring(const char* data) {
	size_t datalen = strlen(data);
	for (size_t i = 0; i < datalen; i++)
		terminal_putchar(data[i]);
}
void kernel_main() {
	/* Initialize terminal interface */
	terminal_initialize();
	for (int i = 0; i <= 2; i++)
	{
	for(char z = 'A'; z<='z'; z++)
	{
		char foo[] = {z,'\n','\0'};
		terminal_writestring(foo);
	}
}
}
