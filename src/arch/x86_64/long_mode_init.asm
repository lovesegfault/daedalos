global long_mode_start

section .text
bits 64
    VGA_BUFFER equ 0xb8000
    long_mode_start:
        mov rsi, msg
        mov rdi, VGA_BUFFER
        mov ax, 0x0720
        mov rcx, 80
        rep stosw
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
    msg db "Hey Daniel. Isn't this cool?", 0
