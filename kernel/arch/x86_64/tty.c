#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>

#include <kernel/tty.h>

#include "vga.h"

static const size_t VGA_WIDTH     = 80;
static const size_t VGA_HEIGHT    = 25;
static uint16_t *const VGA_MEMORY = (uint16_t *)0xB8000;

static size_t termRow;
static size_t termCol;
static uint8_t   termColor;
static uint16_t *termBuf;

void termInit(void)
{
  termRow = 0;
  termCol = 0;
  termBuf = VGA_MEMORY;

  for (size_t i = 0; i < VGA_HEIGHT; i++)
  {
    for (size_t j = 0; j < VGA_WIDTH; j++)
    {
      const size_t index = i * VGA_WIDTH + j;
      termBuf[index] = vgaEntry(' ', terminal);
    }
  }
}

void termSetColor(uint8_t color)
{
  temColor = color;
}

void termPutEntryAt(unsigned char c, uint8_t color, size_t x, size_t y)
{
  const size_t index = y * VGA_WIDTH + x;

  termBuf[index] = vgaEntry(c, color);
}

void termPutChar(char c)
{
  unsigned char uc = c;

  termPutEntryAt(uc, termColor, termCol, termRow);

  if (++termCol == VGA_WIDTH)
  {
    termCol = 0;

    if (++termRow == VGA_HEIGHT)
    {
      termRow = 0;
    }
  }
}

void termWrite(const char *data, size_t size)
{
  for (size_t i = 0; i < size; i++)
  {
    termPutChar(data[i]);
  }
}

void termWriteString(const char *data)
{
  termWrite(data, strlen(data));
}
