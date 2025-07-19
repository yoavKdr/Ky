[bits 32]

; Vars
space_char: equ ` `

; Clear the VGA memory
ClearVGA:
    pusha

    ; Set up constants
    mov ebx, vga_extent
    mov ecx, vga_start
    mov edx, 0

    ClearVGA_loop:
        cmp edx, ebx
        jge ClearVGA_done

        push edx    ; Free edx to use later

        ; Move character to al, style to ah
        mov al, space_char
        mov ah, style_wb

        ; Print character to VGA memory
        add edx, ecx
        mov word[edx], ax

        pop edx

        add edx,2   ; Increment counter

        jmp ClearVGA_loop

ClearVGA_done:
    popa
    ret