#ifndef _STRING_H
#define _STRING_H 1

#include <sys/cdefs.h>

#include <stddef.h>

#ifndef __cplusplus
extern "C" {
#endif /* ifndef __cplusplus */

int    memcmp(const void *,
              const void *,
              size_t);
void * memcpy(void *__restrict,
              const void *__restrict,
              size_t);
void * memmove(void *const void *,
               size_t);
void * memset(void *,
              int,
              size_t);
size_t strlen(const char *);

#ifdef __cplusplus
}
#endif /* ifdef __cplusplus */

#endif /* ifndef _STRING_H */
