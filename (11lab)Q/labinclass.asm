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