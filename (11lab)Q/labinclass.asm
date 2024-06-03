section .bss
    arr resd 10000      ; Reserve space for 10000 integers (array)

section .data
    newline db 10       ; Newline character

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

    ; Print newline character
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
    ; Print integer value in ebx
    ; This function assumes that the integer value is in ebx
    ; and that there are no leading zeros in the value.
    
    ; Check if ebx is zero
    test ebx, ebx
    jnz .print_non_zero
    ; If ebx is zero, print '0'
    mov eax, 4            ; syscall number for sys_write
    mov ebx, 1            ; file descriptor 1 (stdout)
    mov ecx, zero         ; address of zero character
    mov edx, 1            ; number of bytes to write
    int 0x80              ; Call kernel
    ret

.print_non_zero:
    ; Initialize
    mov ecx, 0            ; Digit counter
    mov edi, esp          ; Store digits on the stack

.convert_loop:
    xor edx, edx          ; Clear edx for division
    div dword 10          ; Divide ebx by 10
    add dl, '0'           ; Convert remainder to ASCII
    dec edi               ; Move stack pointer down
    mov [edi], dl         ; Store digit
    inc ecx               ; Increment digit counter
    test eax, eax         ; Check if quotient is zero
    jnz .convert_loop     ; If not zero, continue loop

.print_loop:
    ; Print each digit
    mov eax, 4            ; syscall number for sys_write
    mov ebx, 1            ; file descriptor 1 (stdout)
    mov edx, 1            ; number of bytes to write (1 byte per digit)
    mov ecx, edi          ; address of current digit
    int 0x80              ; Call kernel
    inc edi               ; Move to next digit
    loop .print_loop      ; Repeat for all digits

    ret                   ; Return from subroutine

section .data
zero db '0'  
