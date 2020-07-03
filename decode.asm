section .data
	file_name db 'myfile1.txt',0
	key db 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8
	size dd 0x9999999
	count dd 0x00
section .bss
	fd_in resb 1
	info resb 1024*1024*50
	result resb 1024*1024*50
section .text
global _start
_start:
_open1:
	mov eax, 5
	mov ebx, file_name
	mov ecx, 0
	mov edx, 0777
	int 0x80

	mov [fd_in], eax
_read:
	mov eax, 3
	mov ebx, [fd_in]
	mov ecx, info
	mov edx, [size]
	int 0x80
_close1:
	mov eax, 6
	mov ebx, [fd_in]
	int 0x80

_print1:
;	mov eax, 4
;	mov ebx, 1
;	mov ecx, info
;	mov edx, [size]
;	int 0x80

	xor esi, esi
	mov edi, [size]
_encode:
	mov eax, esi
	mov edx, 0
	mov ebx, 8
	div ebx
	mov ebp, edx

	cmp word[info+esi], 0x00
	je _open2
	mov ax, word[info+esi*2]
	mov cx, word[key+ebp]
	ror ax, cl
	mov word[result+esi*2], ax
	inc esi
	cmp edi,esi
	jnb _encode
_open2:
	mov dword[count], esi

	mov eax, 5
	mov ebx, file_name
	mov ecx, 1
	mov edx, 0777
	int 0x80

	mov [fd_in], eax
_write:
	mov eax, 4
	mov ebx, [fd_in]
	mov ecx, result
	mov edx, [count]
	int 0x80

_close:
	mov eax, 6
	mov ebx, [fd_in]
	int 0x80
_exit:
	mov eax, 1
	int 0x80
