[org 0x7C00] ; BIOS loads boot sector at 0x7C00
[bits 16] ; Stating real mode (16 bits)

; jumping to the start of the bootloader to avoid overwriting by the includes or msgs
jmp RealMod
nop

; Include
%include "16-bit/print.asm"
%include "16-bit/disk_reader.asm"
%include "16-bit/gdt.asm"
%include "16-bit/elevate.asm"

; Vars
msg_rm: db "Hello World, In Real Mod!", 0x0D, 0x0A, 0

kernel_sectors: db 0
boot_drive: db 0x00

RealMod:
	; set the poiters to the start
	mov bp, 0x0500
	mov sp, bp

	; Print
	mov bx, msg_rm
	call Printf

	mov byte[boot_drive], dl 	; Saving the boot drive inorder to use it later on
	mov bx, 0x0002
	mov cx, [kernel_sectors]
	add cx, 2
	mov dx, 0x7E00
	
	call ReadDisk 	; Read the disk in order to get more then 512 bits

	call Elevate

	jmp $	; Infinite loop to halt the system

times 510 - ($ - $$) db 0x00 ; Set the rest of the 512-byte sector with 0s
dw 0xAA55 ; Boot signature


pm_entry_point:
[bits 32]

; Include
%include "32-bit/print.asm"
%include "32-bit/clear.asm"

%include "32-bit/DLM.asm"
%include "32-bit/DCPUID.asm"

%include "32-bit/Paging.asm"

%include "32-bit/gdt.asm"
%include "32-bit/elevate.asm"



; vars
msg_pm: db "Program Jumped To Protected Mod Successfully!", 0


ProtectedMod:
	; ------- init protected mod -------
	mov ax, data_seg
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000 ; set the pointer to a safe plase
    mov esp, ebp
	; ------- init protected mod -------


	call ClearVGA
	mov esi, msg_pm
	call Printf_32

	call DetectLongMod
	call DetectCPUID

	call InitPageTable
	call Elevate_32

	jmp $
	
times 512 - ($ - pm_entry_point) db 0x00


lm_entry_point:
[bits 64]

; Include
%include "64-bit/clear.asm"
%include "64-bit/print.asm"


; vars
msg_lm: db "Program Jumped To Long Mod Successfully!", 0
style_blue:	equ 0x1F


LongMod:
	; --------- init long mod ---------
    cli
    mov ax, data_seg_64
    mov ds, ax              
    mov es, ax              
    mov fs, ax              
    mov gs, ax              
    mov ss, ax              
	
	;mov rsp, 0x90000
    ;mov rbp, rsp
	; --------- init long mod ---------


	mov rdi, style_blue
	call Clear_64

	mov rdi, style_blue
	mov rsi, msg_lm
	call Printf_64


	; --------- kernel ---------
	jmp 0x8200

	jmp $

times 512 - ($ - lm_entry_point) db 0x00