global long_mode_start

section .text
bits 64
    long_mode_start:
        ; print `OKAY` to screen
        call kernel_main
        cli
        hlt
        
