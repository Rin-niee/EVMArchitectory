section .data 
    t times 10000 dq 0          ; массив для хранения значений последовательности
    format db "%d ", 0

section .text
    global _start

_start:
    mov qword [t], 1            ; t[0] = 1
    mov qword [t + 8], 2        ; t[1] = 2
    mov qword [t + 16], 3       ; t[2] = 3
    mov rsi, 3                  ; начинаем с t[3]
loop:
    cmp rsi, 10000              ; сравниваем с лимитом
    jge end_loop                ; если rsi >= 10000, выходим из цикла
    mov rax, rsi
    sub rax, 1
    mov rbx, qword [t + 8*rax]  ; rbx = t[n-1]
    mov rcx, rsi
    sub rcx, rbx
    mov rcx, qword [t + 8*rcx]  ; rcx = t[n - t[n-1]]
    mov rax, rsi
    sub rax, 1
    sub rax, 1
    mov rbx, qword [t + 8*rax]  ; rbx = t[n-2]
    mov rdx, rsi
    sub rdx, 1
    sub rdx, rbx
    mov rdx, qword [t + 8*rdx]  ; rdx = t[n-1 - t[n-2]]
    mov rax, rsi
    sub rax, 1
    sub rax, 1
    sub rax, 1
    mov rbx, qword [t + 8*rax]  ; rbx = t[n-3]
    mov rdi, rsi
    sub rdi, 2
    sub rdi, rbx
    mov rax, qword [t + 8*rdi]  ; rax = t[n-2 - t[n-3]]
    add rax, rcx
    add rax, rdx
    mov qword [t + 8*rsi], rax  ; a[n] = t[n - t[n-1]] + t[n-1 - t[n-2]] + t[n-2 - t[n-3]]
    inc rsi
    jmp loop
    
end_loop:
    mov rsi, t                  ; указатель на начало массива
    mov rdx, 10                 ; выводим последние 10 значений
print_loop:
    mov rax, [rsi + 8 * 9990]   ; загружаем значение
    mov rdi, format             ; строка формата для вывода
    mov rsi, rax                ; значение для печати
    xor rax, rax                ; очистить rax для вызова printf
    call printf                 ; вызвать printf
    add rsi, 8                  ; перейти к следующему значению
    dec rdx                     ; уменьшить счетчик
    jnz print_loop              ; повторить, если не 0
end:
    mov rax, 60
    xor rdi, rdi
    syscall




section .bss
    arr resd 10000      ; Reserve space for 10000 integers (array)

section .data
    fmt db "%d ", 0     ; Format string for printf

section .text
    global _start
    extern printf

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
    push eax
    push fmt
    call printf
    add esp, 8            ; Clean up the stack

    inc ecx
    jmp print_loop

end_program:
    ; Exit the program
    mov eax, 1            ; syscall number for exit
    xor ebx, ebx          ; exit code 0
    int 0x80
