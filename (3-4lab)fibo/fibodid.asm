org 100h
mov sp, 100h
mov si, fibonacci;указатель на массив с числами фибоначчи
mov ax, 1       ;1 число фибоначчи в 1 регистр(1)
mov bx, 1       ;2 число фибоначчи во 2 регистр(1)
;вычисление ряда чисел фибоначчи
fibcount: 
    mov cx, ax
    add cx, bx  ;поиск следующего числа, сумма двух предыдущих
    jc perepoln ;переход на метку при переполнении
    mov [si], ax;заносим в массив 
    inc si      ;прыжок на следующее число массива
    inc si
    mov ax, bx  ;перемещение метку в соответствии с нужным числом
    mov bx, cx
    jmp fibcount ;возвращение к началу цикла
perepoln:        ;метка переполнения
    mov [si], ax ;записываем число в массив
    inc si       ;аналогичный переход указателя
    inc si
    mov [si], bx ;перемещение значения в массив
    mov dx, 90h
;2 часть:вывод последнего числа на экран
dig:
    mov ax, bx ;перенос последнего числа в регистр для дальнейшей работы с выводом
dig2:
    mov di, dx  ;сохранение значения(для дальнейшего вывода)
    xor dx, dx  ; обнуление регистра
    mov bx, 10  
    div bx      ;ax/dx для вывода крайнего числа
    push ax     ;сохранение значения 
    mov si, digitt
    add si, dx  ;добавляем цифру для правильного указателя в массиве
    mov al, [si]
    mov dx, di  ;восстановление значения регистра для отобращения
    out dx, al  ;вывод
    inc dx
    inc dx
    pop ax      ;восстановление значения ax
    cmp ax, 0   ;сравнение, остались ли какие-то числа
    jne dig2    ;если число не последнее(=/= 0), то снова переход
b1:             ;бесконечный цикл для выхода из программы
    jmp b1
digitt db 3fh, 6h, 5bh, 4fh, 66h, 6dh, 7dh, 7h, 7fh, 6fh
fibonacci times 100 dw 0
