[bits 32]

Elevate_32:
    ; Elevate to 64-bit mode
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    ; Enable paging
    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax
    
    lgdt [gdt_64_descriptor]
    jmp code_seg_64:LongMod