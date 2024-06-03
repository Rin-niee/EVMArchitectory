section .data
    output_format db "%d ", 0

section .text
    global _start

_start:
    mov ecx, 10000       ; количество чисел, которые нужно вычислить
    mov esi, 1           ; t[n-1]
    mov edi, 1           ; t[n-2]
    mov ebx, 1           ; t[n-3]
    mov edx, 10          ; количество чисел, которые нужно вывести
    mov ebp, esp         ; сохраняем указатель на стек

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

    ; Сохраняем новое число на стеке
    mov [esp], esi
    sub esp, 4

    dec ecx             ; уменьшаем счётчик вывода чисел
    jnz calculate_next  ; если не выведены все числа, продолжаем

    ; Выводим последние 10 чисел с вершины стека на консоль
print_last_10:
    mov eax, [esp]      ; берём число с вершины стека
    mov ebx, 1
    mov ecx, output_format
    int 0x80

    add esp, 4          ; перемещаем указатель на следующее число на стеке
    dec edx             ; уменьшаем счётчик выведенных чисел
    jnz print_last_10   ; если не выведены все числа, продолжаем

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80
