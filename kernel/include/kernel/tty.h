#ifndef _KERNEL_TTY_H
#define _KERNEL_TTY_H

#include <stddef.h>

void termInit(void);
void termPutChar(char c);
void termWrite(const char *data,
               size_t      size);
void termWriteString(const char *data);

#endif /* ifndef _KERNEL_TTY_H */
