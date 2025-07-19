msg_cpuid_not_found:                db `ERROR: CPUID unsupported, but required for long mode`, 0


DetectCPUID:
	pushfd
	pop eax

	mov ecx, eax

	xor eax, 1 << 21

	push eax
	popfd
	
	pushfd
	pop eax

	push ecx
	popfd


	xor eax, ecx
	jz NoCPUID
	ret

NoCPUID:
    call Clear_64
    mov esi, msg_cpuid_not_found
    call Printf_32
	hlt