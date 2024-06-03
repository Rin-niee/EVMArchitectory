#include <stdio.h>

extern double alpha, value;
void getsin();

int main() {
    int i;
    for (i = 0; i < 361; i++) {
        alpha = i;
        getsin();
        printf("%4d %13.7f\n", i, value);
    }
    return 0;
}


section .data
    pi dq 3.14159265358979323846   ; Число пи
    alpha dq 0.0       ; Угол
    value dq 0.0       ; Результат

section .text
    global getsin

getsin:
    fld qword [alpha]     ; Загрузка угла в стек FPU
    fldpi                ; Загрузка числа пи в стек
    fmul                ; Умножение на число пи
    fld1                ; Загрузка 1 в стек
    fdiv                ; Деление на 180 для получения радианов
    fsin                ; Вычисление синуса угла
    fstp qword [value]    ; Сохранение результата в переменную value
    ret
