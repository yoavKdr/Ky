[bits 16]

; Vars
success_msg: db "Sectors Loaded Successfully!", 0x0D, 0x0A, 0
error_msg: db "ERROR: Loading Sectors Failed!", 0x0D, 0x0A, 0

ReadDisk:
    push ax
    push bx
    push cx
    push dx
    push cx


    mov ah, 0x02                ; For the ATA Read bios utility              
    mov al, cl                  ; Number of sectors to read     
    mov cl, bl                  ; Sector to load (bootloader was sector 1)
    mov bx, dx                  ; Start location to read
    mov ch, 0x00                ; Cylinder
    mov dh, 0x00                ; Head
    mov dl, byte[boot_drive]    ; Boot drive

    int 0x13    ; Call BIOS disk service

    jc ReadDisk_error    ; Check read error

    pop bx
    cmp al, bl
    jne ReadDisk_error


; ReadDisk_success:
    ; Print if success    mov bx, success_msg
    call Printf

    ; Restore the registers
    pop dx
    pop cx
    pop bx
    pop ax

    ret


ReadDisk_error:
    mov bx, error_msg
    call Printf

    jmp $