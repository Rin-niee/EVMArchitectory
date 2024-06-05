%include "io64.inc"

section .data
    a_times: times 10000 dq 0         ; массив для хранения чисел
    output_format db "%d ", 0         ; формат вывода для чисел
    newline db 10, 0                  ; символ новой строки

section .bss
    num_str resb 20

section .text
global CMAIN
CMAIN:
    mov rbp, rsp; for correct debugging
    ; Заполнение массива согласно начальным значениям
    mov rsi, a_times                ; адрес массива
    mov rcx, 3                      ; начальный индекс
    mov rax, 1                      ; начальное значение a[1]
    mov qword [rsi], rax            ; сохраняем a[1]
    mov rax, 2                      ; начальное значение a[2]
    mov qword [rsi + 8], rax        ; сохраняем a[2]
    mov rax, 3                      ; начальное значение a[3]
    mov qword [rsi + 16], rax       ; сохраняем a[3]

calc_loop:
    cmp rcx, 10000                  ; проверяем, достигли ли конца массива
    jge print_last_ten
    push rcx                    ; если достигли, переходим к выводу последних 10 чисел

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

    mov rdx, rcx                    ; сохраняем текущий индекс в rdx
    sub rdx, rbx                    ; вычисляем n - t[n-2]
    mov rcx, [rsi + rdx * 8]        ; загружаем t[n - t[n-2]] в rcx

    add rax, rcx                    ; складываем t[n - t[n-1]] и t[n - t[n-2]]
    add rax, rdx                    ; складываем результат с t[n-1]

    ; Записываем результат в массив используя правильные регистры
    mov rdx, rcx                    ; сохраняем индекс
    mov [rsi + rdx * 8], rax        ; сохраняем результат в массиве
    pop rcx
    inc rcx                         ; увеличиваем счетчик чисел 
    jmp calc_loop

print_last_ten:
    mov rsi, a_times                ; адрес массива
    add rsi, 9990 * 8               ; адрес последних 10 чисел в массиве
    mov rcx, 10                     ; количество чисел для вывода

print_loop:
    mov rax, [rsi]                  ; загружаем текущее число
    mov rdi, num_str                ; адрес буфера для строки
    call int_to_str                 ; преобразуем число в строку

    ; вычисляем длину строки
    mov rdx, rdi                    ; адрес строки
    mov rdi, num_str                ; начальный адрес буфера
    sub rdx, rdi                    ; длина строки

    ; вывод строки на консоль
    mov rax, 1                      ; syscall write
    mov rdi, 1                      ; дескриптор файла (stdout)
    mov rsi, num_str                ; буфер строки
    syscall

    ; вывод новой строки
    mov rax, 1                      ; syscall write
    mov rdi, 1                      ; дескриптор файла (stdout)
    mov rsi, newline                ; буфер новой строки
    mov rdx, 1                      ; длина новой строки
    syscall

    add rsi, 8                      ; переходим к следующему числу для вывода
    dec rcx                         ; уменьшаем счетчик чисел для вывода
    cmp rcx, 0
    jnz print_loop                  ; повторяем цикл, если не закончили вывод

; Функция для преобразования числа в строку
; Вход: rax - число
; Выход: rsi - буфер строки, rdx - длина строки
int_to_str:
    mov rcx, 10                     ; основание числа
    mov rbx, rdi                    ; сохраняем адрес буфера
    mov rdi, rbx
    add rdi, 20                     ; указываем на конец буфера
    mov byte [rdi], 0               ; добавляем нулевой байт в конец строки

convert_loop:
    test rax, rax 
    jz end_con_loop
    xor rdx, rdx                    ; очищаем rdx для div
    div rcx                         ; делим rax на 10, результат в rax, остаток в rdx
    add dl, '0'                     ; преобразуем остаток в символ
    dec rdi                         ; перемещаем указатель буфера влево
    mov [rdi], dl                   ; сохраняем символ в буфер               
    jmp convert_loop                ; если не все, продолжаем цикл
end_con_loop:
    mov rdx, rbx                    ; начальный адрес буфера
    sub rdx, rdi                    ; длина строки
    mov rsi, rdi                    ; конечный адрес буфера
    ret
