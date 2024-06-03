section .data
    newline db 10 ; Символ новой строки

section .bss
    digits resb 11 ; Буфер для чисел в строковом виде (максимум 10 цифр + нуль-терминатор)

section .text
    global _start

_start:
    ; Пример: Задать значение регистра ECX
    mov ecx, 12345 ; Здесь задается значение регистра ECX

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

    ; Выводим символ новой строки
    mov eax, 4            ; write
    mov ebx, 1            ; stdout
    mov ecx, newline      ; указатель на символ новой строки
    mov edx, 1            ; длина строки
    int 0x80              ; вызов системного прерывания
