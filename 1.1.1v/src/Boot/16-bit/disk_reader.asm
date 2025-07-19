[bits 16]

; Vars
extended_space: equ 0x7E00

success_msg: db "Sectors Loaded Successfully!", 0x0D, 0x0A, 0
error_msg: db "ERROR: Loading Sectors Failed!", 0x0D, 0x0A, 0

boot_drive: db 0 ; the drive we using


ReadDisk:
    mov ah, 0x02               ; For the ATA Read bios utility    
    mov al, 4                  ; Number of sectors to read
    mov cl, 2                  ; Sector to load (bootloader was sector 1)
    mov bx, extended_space     ; Start location to read
    mov ch, 0x00               ; Cylinder
    mov dh, 0x00               ; Head
    mov dl, byte[boot_drive]   ; Boot drive


    int 0x13    ; Call BIOS disk service

    jc ReadDisk_error

; ReadDisk_success:
    ; Print if success
    mov bx, success_msg
    call Printf

    ret

ReadDisk_error:
    ; Print
    mov bx, error_msg
    call Printf

    jmp $   ; Infinite loop to make halt
    ;ret
