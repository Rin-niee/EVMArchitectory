section .data
    alpha dq 0.0       ; Угол
    value dq 0.0       ; Результат

section .text
    global getsin

getsin:
    push    ebp
    mov     ebp, esp
    fld     qword [alpha]    ; Загрузка угла в стек FPU
    fld     st0             ; Дублирование угла
    fmul    st0, st0        ; Вычисление квадрата угла
    fld     st1             ; Дублирование квадрата угла
    fcos                    ; Вычисление косинуса
    fchs                    ; Инверсия результата (синус)
    fstp    qword [value]   ; Сохранение результата
    pop     ebp
    ret
