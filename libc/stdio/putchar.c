#include <stdio.h>

#if defined(__is_libk)
# include <kernel/tty.h>
#endif /* if defined(__is_libk) */

int putchar(int ic) {
#if defined(__is_libk)
  char c = (char)ic;
  terminal_write(&c, sizeof(c));
#else  /* if defined(__is_libk) */

  // TODO: Implement stdio and the write system call.
#endif /* if defined(__is_libk) */
  return ic;
}
