section .bss
    buffer resb 12      ; Буфер для строкового представления числа (максимум для 32-битного числа: 10 цифр + знак + null)

section .data
    newline db 0xA      ; Символ новой строки

section .text
    global _start

_start:
    mov ecx, 123456     ; Пример значения для ECX

    ; Преобразовать ECX в строку
    call int_to_string

    ; Вывести строку
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov edx, buffer     ; указатель на буфер
    mov ecx, 12         ; максимальная длина строки (включая null-терминатор)
    int 0x80            ; системный вызов

    ; Вывести символ новой строки
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov edx, 1          ; длина строки
    mov ecx, newline    ; указатель на символ новой строки
    int 0x80            ; системный вызов

    ; Завершить программу
    mov eax, 1          ; sys_exit
    xor ebx, ebx        ; код возврата 0
    int 0x80            ; системный вызов

; Подпрограмма для преобразования числа в строку
int_to_string:
    mov edi, buffer + 11 ; Указатель на конец буфера
    mov byte [edi], 0    ; Null-терминатор
    dec edi

    mov eax, ecx         ; Копируем значение из ECX в EAX
    mov ebx, 10          ; Основа деления (десятичная система)

.convert_loop:
    xor edx, edx         ; Очистить регистр edx
    div ebx              ; Деление edx:eax на ebx, результат в eax, остаток в edx
    add dl, '0'          ; Преобразовать остаток в ASCII символ
    mov [edi], dl        ; Сохранить символ в буфере
    dec edi              ; Переместить указатель влево
    test eax, eax        ; Проверить, не ноль ли eax
    jnz .convert_loop    ; Если нет, продолжить цикл

    inc edi              ; Переместить указатель на первый символ числа
    ret
