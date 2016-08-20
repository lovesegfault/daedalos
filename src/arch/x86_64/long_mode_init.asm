global long_mode_start
extern kernel_main


section .text
bits 64
    long_mode_start:
        ; print `OKAY` to screen
        call kernel_main
        cli
        hlt
