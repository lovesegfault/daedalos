global long_mode_start

section .text
bits 64
VGA_BUFFER equ 0xb8000
long_mode_start:
clear:
    mov rsi, clr
    mov rdi, VGA_BUFFER
    mov ah, 0x02
loop:
    lodsb
    test al,al
    je end
    stosw
    jmp loop
end:
    hlt
section .data
    msg db "Thanks Dan!", 0
    clr db "                                                                                ", 0
