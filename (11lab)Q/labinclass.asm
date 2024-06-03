section .bss
    arr resd 10000      ; Reserve space for 10000 integers (array)

section .data
    fmt db "%d ", 0     ; Format string for printf
    newline db 10, 0    ; Newline character

section .text
    global _start

_start:
    ; Initialize the first three elements of the array
    mov dword [arr], 1
    mov dword [arr+4], 1
    mov dword [arr+8], 1

    ; Calculate the rest of the array
    mov ecx, 3            ; Start from the 4th element (index 3)
calc_loop:
    cmp ecx, 10000        ; Compare loop counter with 10000
    jge print_result      ; If we've calculated 10000 elements, jump to printing

    ; Calculate t[n-1], t[n-2], and t[n-3]
    mov eax, [arr + ecx*4 - 4]
    mov ebx, [arr + ecx*4 - 8]
    mov edx, [arr + ecx*4 - 12]

    ; Calculate t[n - t[n-1]], t[n-1 - t[n-2]], t[n-2 - t[n-3]]
    sub ecx, eax          ; ecx = n - t[n-1]
    mov esi, ecx
    add ecx, eax          ; Restore ecx

    sub ecx, ebx
    mov edi, ecx
    add ecx, ebx          ; Restore ecx

    sub ecx, edx
    mov ebp, ecx
    add ecx, edx          ; Restore ecx

    ; Calculate the current value
    mov eax, [arr + esi*4]
    add eax, [arr + edi*4]
    add eax, [arr + ebp*4]

    ; Store the result in the array
    mov [arr + ecx*4], eax

    inc ecx
    jmp calc_loop

print_result:
    ; Print the last 10 elements
    mov ecx, 9990         ; Start printing from the 9991st element
print_loop:
    cmp ecx, 10000        ; Print 10 elements
    jge end_program

    ; Get the current element
    mov eax, [arr + ecx*4]

    ; Print the element
    push eax
    call print_int
    add esp, 4            ; Clean up stack

    ; Print newline
    mov eax, 4            ; syscall number for sys_write
    mov ebx, 1            ; file descriptor 1 (stdout)
    mov ecx, newline      ; address of newline character
    mov edx, 1            ; number of bytes to write (1 byte for newline)
    int 0x80              ; Call kernel

    inc ecx
    jmp print_loop

end_program:
    ; Exit the program
    mov eax, 1            ; syscall number for exit
    xor ebx, ebx          ; exit code 0
    int 0x80

print_int:
    ; Print integer value in eax
    pusha                 ; Save all registers
    mov ebx, eax          ; Move value to ebx for printing
    mov ecx, 10           ; Set counter to 10 (for base 10)
    xor esi, esi          ; Clear esi

print_int_loop:
    xor edx, edx          ; Clear edx for division
    div ecx               ; Divide eax by 10
    add dl, '0'           ; Convert remainder to ASCII
    push edx              ; Push ASCII character onto stack
    inc esi               ; Increment digit count
    test eax, eax         ; Check if quotient is zero
    jnz print_int_loop    ; If not zero, continue loop

print_digits:
    pop eax               ; Pop ASCII character from stack
    mov [esp+esi-1], al   ; Store character in buffer
    dec esi               ; Decrement esi
    jnz print_digits      ; Loop until all digits are printed

    mov eax, 4            ; syscall number for sys_write
    mov ebx, 1            ; file descriptor 1 (stdout)
    lea ecx, [esp]        ; address of buffer
    mov edx, 1            ; number of bytes to write (1 byte per digit)
    int 0x80              ; Call kernel

    popa                  ; Restore all registers
    ret
