global long_mode_start

section .text
bits 64
VGA_BUFFER equ 0xb8000
long_mode_start:
    mov rsi, msg
    mov rdi, VGA_BUFFER
loop:
    lodsq
    cmp rax, 0
    je end
    stosq
    jmp loop
end:
    hlt
section .data
    msg db "Thanks Dan!", 0
