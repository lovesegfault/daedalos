#include <stdio.h>
#include <stdlib.h>

__attribute__((__noreturn__))
void abort(void) {
#if defined(__is_libk)

  // TODO: Add proper kernel panic.
  printf("kernel: panic: abort()\n");
#else  /* if defined(__is_libk) */

  // TODO: Abnormally terminate the process as if by SIGABRT.
  printf("abort()\n");
#endif /* if defined(__is_libk) */

  while (1) {}
  __builtin_unreachable();
}
