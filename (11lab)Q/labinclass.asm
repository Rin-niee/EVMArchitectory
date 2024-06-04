невозможно найти Scrt1.o: Нет такого файла или каталога
/usr/bin/ld: невозможно найти crti.o: Нет такого файла или каталога
/usr/bin/ld: пропускается несовместимый /usr/lib/gcc/x86_64-linux-gnu/11/libgcc.a при поиске -lgcc
/usr/bin/ld: невозможно найти -lgcc: Нет такого файла или каталога
/usr/bin/ld: пропускается несовместимый /usr/lib/x86_64-linux-gnu/libgcc_s.so.1 при поиске libgcc_s.so.1
/usr/bin/ld: невозможно найти libgcc_s.so.1: Нет такого файла или каталога
/usr/bin/ld: пропускается несовместимый /usr/lib/x86_64-linux-gnu/libgcc_s.so.1 при поиске libgcc_s.so.1
/usr/bin/ld: пропускается несовместимый /usr/lib/gcc/x86_64-linux-gnu/11/libgcc.a при поиске -lgcc
/usr/bin/ld: невозможно найти -lgcc: Нет такого файла или каталога
collect2: error: ld returned 1 exit status




section .bss
    t resd 10000 ; резервируем место для 10000 элементов массива t

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
    mov ecx, 3 ; начинаем с t[3]
    mov edx, 10000 ; количество элементов
compute_sequence:
    mov eax, ecx
    sub eax, 1
    mov ebx, [t + eax * 4] ; t[n-1]
    sub ecx, ebx
    mov ebx, [t + ecx * 4] ; t[n - t[n-1]]
    add eax, ebx

    mov ecx, eax
    sub ecx, 1
    mov ebx, [t + ecx * 4] ; t[n-1 - t[n-2]]
    add eax, ebx

    mov ecx, eax
    sub ecx, 1
    mov ebx, [t + ecx * 4] ; t[n-2 - t[n-3]]
    add eax, ebx

    mov [t + ecx * 4], eax ; t[n] = результат

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

nasm -f elf32 sequence.asm -o sequence.o
Скомпилируйте с помощью GCC, чтобы создать исполняемый файл:
sh
Копировать код
gcc -m32 sequence.o -o sequence -lc
Запустите исполняемый файл:
sh
Копировать код
./sequence
