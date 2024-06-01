section .data


section .text
global _start

_start:
	mov rdi, fact

	mov qword [rdi], 1
	add rdi, 8
	mov rax, 1
	mov rbx, 1


follow:
	call out
	inc rbx
	mov rdx, rdx
	mul rbx
	cmp rdx, 0
	jz follow

	mov eax, 1
	xor ebx, ebx
	int 80h

out:
	push rax
	push rbx
	push rcx
	push rdx
	mov rbx, 10
	mov rdi, stringg
	add rdi, 24

start:
	xor rdx, rdx
	div rbx
	add dl, 30h
	mov [rdi], dl
	dec rdi

	cmp rax, 0
	jne start
	mov eax, 4
	mov ebx, 1
	mov ecx, stringg
	mov edx, [stringlen]
	int 80h 

	pop rdx
	pop rcx
	pop rbx
	pop rax
ret

section .data


fact times 100 dq 0
string times 25 db 20h
nl db 10
f db 0
stringlen db 26
