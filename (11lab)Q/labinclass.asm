section .bss
    arr resd 10000      ; Reserve space for 10000 integers (array)

section .data
    fmt db "%d ", 0     ; Format string for printf

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

    ; Calculate n - t[n-1], n-1 - t[n-2], and n-2 - t[n-3]
    sub ecx, eax          ; ecx = n - t[n-1]
    mov esi, ecx
    add ecx, eax          ; Restore ecx

    dec ecx
    sub ecx, ebx          ; ecx = n-1 - t[n-2]
    mov edi, ecx
    add ecx, ebx          ; Restore ecx

    sub ecx, 2
    sub ecx, edx          ; ecx = n-2 - t[n-3]
    mov ebp, ecx
    add ecx, 2
    add ecx, edx          ; Restore ecx

    ; Calculate t[n - t[n-1]], t[n-1 - t[n-2]], t[n-2 - t[n-3]]
    mov eax, [arr + esi*4]
    mov ebx, [arr + edi*4]
    mov edx, [arr + ebp*4]

    ; Calculate the current value
    add eax, ebx
    add eax, edx

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
    mov ebx, eax
    call print_int

    inc ecx
    jmp print_loop

end_program:
    ; Exit the program
    mov eax, 1            ; syscall number for exit
    xor ebx, ebx          ; exit code 0
    int 0x80

print_int:
    ; Print integer value in ebx
    mov esi, 10           ; Set esi to 10 (for dividing by 10)
    mov edi, 0            ; Set edi to 0 (for storing digits)
    mov ecx, 10           ; Set counter to 10 (for 10 digits)
    mov edx, ebx          ; Move value to edx for division
.loop:
    xor eax, eax          ; Clear eax for division
    div esi               ; Divide value in edx:eax by 10
    add dl, '0'           ; Convert remainder to ASCII
    mov [esp+edi], dl     ; Store digit in stack
    inc edi               ; Move to next digit in stack
    dec ecx               ; Decrement counter
    test eax, eax         ; Check if quotient is zero
    jnz .loop             ; If not zero, continue looping

    ; Print the digits
    mov edx, edi          ; Set edx to number of digits
    mov ecx, esp          ; Set ecx to address of first digit
.print_loop:
    mov eax, 4            ; syscall number for sys_write
    mov ebx, 1            ; file descriptor 1 (stdout)
    mov esi, ecx          ; Set esi to address of current digit
    mov edi, 1            ; Number of bytes to write (1 byte for 1 digit)
    int 0x80              ; Call kernel

    inc ecx               ; Move to next digit
    dec edx               ; Decrement counter
    jnz .print_loop       ; If counter is not zero, continue printing

    ret  
