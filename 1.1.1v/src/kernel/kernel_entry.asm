[bits 64]
;[extern main]

section .text
global _start

_start:
    mov al, 'X'
    mov dx, 0x3F8
    out dx, al
    
    ;call main
    jmp $