[bits 32]

; Vars
vga_start:                  equ 0x000B8000
vga_extent:                 equ 80 * 25 * 2	; VGA Memory is 80 chars wide by 25 chars tall (one char is 2 bytes)
style_wb:                   equ 0x0F

; Message address stored in esi
Printf_32:

    pusha
    mov edx, vga_start

    ; Do main loop
    Printf_loop:
        ; If char == \0, string is done
        cmp byte[esi], 0
        je  Printf_done

        ; Move character to al, style to ah
        mov al, byte[esi]
        mov ah, style_wb

        mov word[edx], ax   ; Print character to vga memory location

        ; Increment counter registers
        add esi, 1
        add edx, 2

        jmp Printf_loop

Printf_done:
    popa
    ret