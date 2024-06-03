section .data
    output_format db "%d ", 0

section .text
    global _start

_start:
    mov ecx, 10000       ; количество чисел, которые нужно вычислить
    mov esi, 1           ; t[n-1]
    mov edi, 1           ; t[n-2]
    mov ebx, 1           ; t[n-3]
    mov edx, 9           ; количество чисел, которые нужно вывести

calculate_next:
    ; Считаем следующее число по алгоритму
    mov eax, esi
    sub eax, edi
    mov ecx, [ebx + eax*4]
    add esi, ecx

    mov eax, edi
    sub eax, ebx
    mov ecx, [esi + eax*4]
    add edi, ecx

    mov eax, ebx
    sub eax, esi
    mov ecx, [edi + eax*4]
    add ebx, ecx

    ; Выводим число на консоль
    mov eax, esi
    mov ebx, 1
    mov ecx, output_format
    int 0x80

    dec edx
    jnz calculate_next

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80
