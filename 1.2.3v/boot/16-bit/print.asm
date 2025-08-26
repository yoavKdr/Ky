[bits 16]

; How to print:
; msg_hello_world: db `\r\nHello World, from the BIOS!\r\n`, 0
; mov bx, msg_hello_world
; call Printf
Printf:

    ; I will use ax and bx so i save then befor using
    push ax
    push bx

    ; 0x0E is a BIOS utilities to set int 0x10 to print
    mov ah, 0x0E
    
    printf_loop:
        ; Check is there is more char if the next value is 0 then jump to the end
        cmp byte[bx], 0
        je printf_end
        ; Give al the char and then print it
        mov al, byte[bx]
        int 0x10
        ; jump to the next value then return on the loop
        inc bx
        jmp printf_loop
    printf_end:
        ; Pop the data back and then return
        pop bx
        pop ax
        ret