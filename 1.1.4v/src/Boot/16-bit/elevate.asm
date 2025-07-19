[bits 16]

; This function set the CPU to protected mode
Elevate:
    
    call EnableA20

    cli ; Disable interrupts

    lgdt [gdt_descriptor]    ; Tell the CPU where is the GDT

    ; Enable 32-bit mode by setting bit 0 of the original control register
    mov eax, cr0
    or eax, 0x00000001
    mov cr0, eax

    jmp code_seg:ProtectedMod

EnableA20:
    in al, 0x92
    or al, 2
    out 0x92, al
    ret