InitPageTable:
	pushad

	mov edi, 0x1000
	mov cr3, edi
    xor eax, eax
    mov ecx, 4096
    rep stosd

	mov edi, cr3

	mov dword [edi], 0x2003
	add edi, 0x1000
	mov dword [edi], 0x3003
	add edi, 0x1000
	mov dword [edi], 0x4003
	add edi, 0x1000

	mov ebx, 0x00000003
	mov ecx, 512

	SetEntry:
		mov dword [edi], ebx
		add ebx, 0x1000
		add edi, 8
		loop SetEntry

	mov eax, cr4
	or eax, 1 << 5
	mov cr4, eax

	popad
	ret