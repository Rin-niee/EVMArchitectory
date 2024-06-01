%include "io.inc"

section .text
global CMAIN
CMAIN:
    mov qword [t], 1
    mov qword [t+4], 2
    mov qword [t+8], 3
    mov rsi, 3
nloop:
    cmp rsi, 10000 ;сравниваем значения
    jge end_nloop  ;и при удачном сравнении выходим из цикла и переходим в конец
    mov rax, rsi
    sub rax, 1
    mov rbx, qword [t+ 8*rax] ;rbx = t[n-1]
    sub rsi, rbx
    mov rcx, qword [t+rsi*4] ;rcx = t[n-t[n-1]]
    add rsi, rbx
    sub rax, 1
    mov rbx, qword [t+rax*4] ;rbx = t[n-2]
    sub rsi, rbx
    mov rdx, qword [t+rsi*4] ;rdx = t[n-1-t[n-2]]
    add rsi, rbx
    sub rax, 1
    mov rbx, qword [t+rax*4] ;rbx = t[n-3]
    sub rsi, rbx
    mov rax, qword [t+rsi*4] ;rax = t[n-2-t[n-3]]
    add rax, rcx
    add rax, rdx
    add rsi, rbx
    mov qword [t+ rsi*4], rax ; a[n]=a[n-a[n-1]]+ a[n-1-a[n-2]]+ a[n-2-a[n-3]]
    inc rsi
    jmp nloop
    
end_nloop:
    mov rsi, t + 9990*4 
    mov rdx, 10
print_nloop:
    mov rax, 1
    mov rdi, 1
    mov rbx, 1
    mov rax, 1
    syscall
    
    add rsi, 4
    dec rdx
    jnz print_nloop
nend:
    mov rax, 60
    xor rdi, rdi
    syscall
    
section .data 
    t times 10000 dq 0
    format db "%d ", 0   