[org 0x7C00] ; BIOS loads boot sector at 0x7C00
[bits 16] ; Stating real mode (16 bits)

; jumping to the start of the bootloader to avoid overwriting by the includes or msgs
jmp RealMod
nop

; Include
%include "16-bit/print.asm"
%include "16-bit/disk_reader.asm"

; Vars
msg_rm: db "Hello World, In Real Mod!", 0x0D, 0x0A, 0


RealMod:
	; set the poiters to the start
	mov bp, 0x0500
	mov sp, bp

	; Print
	mov bx, msg_rm
	call Printf

	mov byte[boot_drive], dl 	; Saving the boot drive inorder to use it later on

	call ReadDisk 	; Read the disk in order to get more then 512 bits

	jmp extended_space	; jmp to place begger then 512 bits

	jmp $	; Infinite loop to halt the system

times 510 - ($ - $$) db 0x00 ; Set the rest of the 512-byte sector with 0s
dw 0xAA55 ; Boot signature