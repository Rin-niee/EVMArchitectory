section .bss
    t resd 10000      ; резервируем место для 10000 элементов массива t

section .data
    format db "%d ", 0 ; формат для printf

section .text
    extern printf
    global main

main:
    ; инициализируем первые три элемента массива
    mov dword [t], 0
    mov dword [t+4], 0
    mov dword [t+8], 1

    ; цикл для вычисления последовательности
    mov ecx, 3        ; начинаем с t[3]
    mov edx, 10000    ; количество элементов

compute_sequence:
    push ecx          ; сохраним текущее значение ecx на стек

    ; t[n - t[n-1]]
    mov eax, ecx
    sub eax, 1
    mov ebx, [t + eax * 4]
    sub eax, ebx
    mov ebx, [t + eax * 4]

    ; t[n - 1 - t[n - 2]]
    mov eax, ecx
    sub eax, 1
    mov esi, [t + eax * 4]
    sub eax, 1
    mov edi, [t + eax * 4]
    sub eax, edi
    add ebx, [t + eax * 4]

    ; t[n - 2 - t[n - 3]]
    mov eax, ecx
    sub eax, 2
    mov edi, [t + eax * 4]
    sub eax, 1
    mov esi, [t + eax * 4]
    sub eax, esi
    add ebx, [t + eax * 4]

    ; сохраняем результат
    pop ecx
    mov [t + ecx * 4], ebx

    inc ecx
    cmp ecx, edx
    jl compute_sequence

    ; выводим последние 10 элементов
    mov ecx, 9990
print_last_10:
    mov eax, [t + ecx * 4]
    push eax
    push format
    call printf
    add esp, 8

    inc ecx
    cmp ecx, 10000
    jl print_last_10

    ; завершение программы
    xor eax, eax
    ret
