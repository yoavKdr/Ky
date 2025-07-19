msg_lm_not_found:                   db `ERROR: Long mode not supported. Exiting...`, 0


DetectLongMod:
	mov eax, 0x80000001
	cpuid
	test edx, 1 << 29
	jz NoLongMode
	ret

NoLongMode:
    call Clear_64
    mov esi, msg_lm_not_found
    call Printf_32
	hlt
