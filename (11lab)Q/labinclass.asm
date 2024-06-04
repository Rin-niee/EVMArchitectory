fiboo.o: warning: relocation in read-only section `.text'
/usr/bin/ld: warning: creating DT_TEXTREL in a PIE



section .data
    n equ 10000
    array times n dd 0
    format db "%d ", 0

section .bss

section .text
    extern printf
    global _start

_start:
    ; Initialize the first three values
    mov dword [array], 1       ; a[1] = 1
    mov dword [array + 4], 2   ; a[2] = 2
    mov dword [array + 8], 3   ; a[3] = 3

    ; Calculate the rest of the sequence
    mov ecx, 3                 ; start with a[4]
calc_loop:
    inc ecx
    cmp ecx, n
    jg print_last_10

    ; Calculate a[n] = a[n - a[n-1]] + a[n-1 - a[n-2]] + a[n-2 - a[n-3]]
    mov eax, ecx
    sub eax, 1
    mov ebx, [array + eax*4]   ; a[n-1]
    sub eax, ebx
    mov edx, [array + eax*4]   ; a[n - a[n-1]]

    mov eax, ecx
    sub eax, 2
    mov ebx, [array + eax*4]   ; a[n-2]
    sub eax, ebx
    add edx, [array + eax*4]   ; + a[n-1 - a[n-2]]

    mov eax, ecx
    sub eax, 3
    mov ebx, [array + eax*4]   ; a[n-3]
    sub eax, ebx
    add edx, [array + eax*4]   ; + a[n-2 - a[n-3]]

    mov [array + ecx*4], edx   ; store the result

    jmp calc_loop

print_last_10:
    ; Print the last 10 numbers
    mov ecx, 10
    mov esi, n
    sub esi, ecx

print_loop:
    mov eax, [array + esi*4]
    push eax
    push format
    call printf
    add esp, 8

    inc esi
    loop print_loop

    ; Exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80
