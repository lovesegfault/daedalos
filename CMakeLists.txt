cmake_minimum_required(VERSION 3.6)
project(daedalos)

set(CMAKE_CXX_STANDARD 11)

set(SOURCE_FILES
        kernel/arch/x86_64/tty.c
        kernel/arch/x86_64/vga.h
        kernel/include/kernel/tty.h
        kernel/kernel/kernel.c
        libc/include/sys/cdefs.h
        libc/include/stdio.h
        libc/include/stdlib.h
        libc/include/string.h
        libc/stdio/printf.c
        libc/stdio/putchar.c
        libc/stdio/puts.c
        libc/stdlib/abort.c
        libc/string/memcmp.c
        libc/string/memcpy.c
        libc/string/memmove.c
        libc/string/memset.c
        libc/string/strlen.c)

add_executable(daedalos ${SOURCE_FILES})