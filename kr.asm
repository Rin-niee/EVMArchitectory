section .data
    buffer db '0000000000', 0 ; Буфер для хранения строки с десятичным представлением

section .bss
    digits resb 11 ; Буфер для чисел в строковом виде (максимум 10 цифр + нуль-терминатор)

section .text
    global _start

_start:
    ; Копируем содержимое регистра ECX в EAX
    mov eax, ecx

    ; Переменные для работы
    mov edi, digits + 10 ; Указатель на конец буфера
    mov byte [edi], 0    ; Нуль-терминатор

convert_to_string:
    ; Если EAX == 0 и мы уже сконвертировали хотя бы одну цифру, то выход
    test eax, eax
    jz print_number

    ; Выделяем последнюю цифру и сохраняем её
    mov ebx, 10
    xor edx, edx
    div ebx                ; EDX = EAX % 10, EAX = EAX / 10
    add dl, '0'            ; Преобразуем в ASCII
    dec edi
    mov [edi], dl

    jmp convert_to_string

print_number:
    ; Если число было нулевым
    cmp edi, digits + 10
    jne print_digits
    ; Если число 0, добавляем его в буфер
    dec edi
    mov byte [edi], '0'

print_digits:
    ; Подсчитываем длину строки
    mov eax, digits + 10
    sub eax, edi
    mov edx, eax

    ; Подготавливаем параметры для системного вызова write
    mov eax, 4            ; write
    mov ebx, 1            ; stdout
    mov ecx, edi          ; указатель на строку
    ; длина строки уже в EDX
    int 0x80              ; вызов системного прерывания

    ; Завершаем выполнение программы
    mov eax, 1            ; sys_exit
    xor ebx, ebx          ; статус выхода 0
    int 0x80   





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

    ; Найти длину строки
    mov edi, buffer
    xor eax, eax
.find_length:
    cmp byte [edi + eax], 0
    je .print_string
    inc eax
    jmp .find_length

.print_string:
    ; Вывести строку
    mov ebx, eax        ; длина строки в ebx
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov edx, eax        ; длина строки
    mov ecx, buffer     ; указатель на буфер
    int 0x80            ; системный вызов

    ; Вывести символ новой строки
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, newline    ; указатель на символ новой строки
    mov edx, 1          ; длина строки
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


section .data
    msg db 'Hello, World!', 0xA    ; Строка для вывода с символом новой строки
    len equ $ - msg                ; Длина строки

section .text
    global _start

_start:
    ; Вывести строку
    mov eax, 4         ; sys_write
    mov ebx, 1         ; stdout
    mov ecx, msg       ; указатель на строку
    mov edx, len       ; длина строки
    int 0x80           ; системный вызов

    ; Завершить программу
    mov eax, 1         ; sys_exit
    xor ebx, ebx       ; код возврата 0
    int 0x80           ; системный вызов
