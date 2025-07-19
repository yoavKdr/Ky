[org 0x7E00]
[bits 16]

jmp RealModExtend
nop

; Include
%include "16-bit/print.asm"
%include "16-bit/gdt.asm"
%include "16-bit/elevate.asm"

; vars
msg_es: db "Program Jumped To Extended Space Successfully!", 0x0D, 0x0A, 0


RealModExtend:
	mov bx, msg_es
	call Printf

	call Elevate

	jmp $


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
    mov ax, data_seg_64           ; Set the A-register to the data descriptor.
    mov ds, ax                    ; Set the data segment to the A-register.
    mov es, ax                    ; Set the extra segment to the A-register.
    mov fs, ax                    ; Set the F-segment to the A-register.
    mov gs, ax                    ; Set the G-segment to the A-register.
    mov ss, ax                    ; Set the stack segment to the A-register.
	
	mov rsp, 0x90000
    mov rbp, rsp
	; --------- init long mod ---------


	mov rdi, style_blue
	call Clear_64

	mov rdi, style_blue
	mov rsi, msg_lm
	call Printf_64


	; --------- kernel ---------
	mov al, 'K'
    mov dx, 0x3F8
    out dx, al

	jmp 0x8200

	jmp $

times 1024 - ($ - $$) db 0