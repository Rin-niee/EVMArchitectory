section .data
    a_times: times 10000 dq 0    ; массив для хранения чисел
    output_format db "%d ", 0      ; формат вывода для чисел

section .text
    global _start

_start:
    ; Заполнение массива согласно начальным значениям
    mov rsi, a_times                ; адрес массива
    mov ecx, 10000                  ; количество чисел
    mov rax, 1                      ; начальное значение a[1]
    mov qword [rsi], rax            ; сохраняем a[1]
    mov rax, 2                      ; начальное значение a[2]
    mov qword [rsi + 8], rax        ; сохраняем a[2]
    mov rax, 3                      ; начальное значение a[3]
    mov qword [rsi + 16], rax       ; сохраняем a[3]

calc_loop:
    cmp ecx, 10000                  ; проверяем, достигли ли конца массива
    je print_last_ten              ; если достигли, переходим к выводу последних 10 чисел

    mov rdi, rcx                    ; сохраняем текущий индекс в rdi
    dec rdi                         ; вычисляем n - 1
    mov rdx, [rsi + rdi * 8]        ; загружаем t[n-1] в rdx
    mov rdi, rdx                    ; сохраняем t[n-1] в rdi

    mov rax, rcx                    ; сохраняем текущий индекс в rax
    sub rax, rdi                    ; вычисляем n - t[n-1]
    mov rdi, rax                    ; сохраняем n - t[n-1] в rdi
    mov rax, [rsi + rdi * 8]        ; загружаем t[n - t[n-1]] в rax

    mov rdi, rcx                    ; сохраняем текущий индекс в rdi
    sub rdi, 2                      ; вычисляем n - 2
    mov rbx, [rsi + rdi * 8]        ; загружаем t[n-2] в rbx
    mov rdi, rbx                    ; сохраняем t[n-2] в rdi

    mov rcx, rbx                    ; сохраняем t[n-2] в rcx
    sub rcx, 3                      ; вычисляем n - t[n-2]
    mov rdi, rcx                    ; сохраняем n - t[n-2] в rdi
    mov rcx, [rsi + rdi * 8]        ; загружаем t[n - t[n-2]] в rcx

    add rax, rcx                    ; складываем t[n - t[n-1]] и t[n - t[n-2]]
    add rax, rdx                    ; складываем результат с t[n-1]
    mov [rsi + rcx * 8], rax        ; сохраняем результат в массиве

    inc ecx                         ; увеличиваем счетчик чисел
    jmp calc_loop

print_last_ten:
    mov rsi, a_times                ; адрес массива
    mov rsi, [rsi + 9990 * 8]       ; адрес последних 10 чисел в массиве
    mov ecx, 10                     ; количество чисел для вывода

print_loop:
    mov rax, 1                      ; используем вызов syscall для вывода на консоль
    mov rdi, 1                      ; дескриптор файла (stdout)
    mov rdx, qword [rsi]            ; количество байт для вывода (в данном случае 1 число)
    mov rax, 1                      ; syscall для записи в stdout
    syscall

    mov rsi, [rsi + 8]              ; переходим к следующему числу для вывода
    dec ecx                         ; уменьшаем счетчик чисел для вывода
    cmp ecx, 0                      ; проверяем, закончили ли вывод всех чисел
    je exit_program
    jmp print_loop

exit_program:
    mov rax, 60                     ; syscall для выхода из программы
    xor rdi, rdi                    ; код возврата 0
    syscall



section .data
    n equ 10000
    array times n dd 0
    format db "%d ", 0
section .text
    global _start
    extern printf
_start:
    mov ebp, esp; for correct debugging
    ; Initialize the first three values
    mov dword [array], 1       ; a[1] = 1
    mov dword [array + 4], 2   ; a[2] = 2
    mov dword [array + 8], 3   ; a[3] = 3

    ; Calculate the rest of the sequence
    mov ecx, 3                 ; start with a[4]
calc_loop:
    cmp ecx, n
    jg print_last_10

    ; Calculate a[n] = a[n - a[n-1]] + a[n-1 - a[n-2]] + a[n-2 - a[n-3]]
    mov eax, ecx
    sub eax, 1
    mov ebx, [array + eax*4]   ; a[n-1]
    sub eax, ebx
    mov edx, eax               ; save a[n - a[n-1]]

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
    inc ecx
    jmp calc_loop

print_last_10:
    ; Print the last 10 numbers
    mov ecx, 10
    mov esi, n
    sub esi, ecx

print_loop:
    cmp esi, n
    jge loop_end    
    mov eax, [array + esi*4]
    push eax
    push format
    call printf
    add esp, 8
    inc esi
    loop print_loop
loop_end:
    ; Exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80
