section .data
global x1
global x2
global a
global b
global c
global d
a dq 2.0
b dq 4.0
c dq 1.5
d dq 0.0
four dq 4.0
two  dq 2.0
zero dq 0.0
x1 dq 0.0
x2 dq 0.0
temp2 times 256 dd 0
global discr

section .text
discr:
   finit
   fld qword [b]    ;  b
   fmul qword [b]   ;  b*b
   fld qword [a]    ;  a   b*b
   fld qword [four] ;  4  a   b*b
   fmul             ;  4*a  b*b
   fld qword [c]    ;  c  4*a  b*b
   fmul             ;  c*4*a  b*b
   fsubp st1, st0   ;  b*b-4*a*c
   fst qword [d]    ; [d] = b*b-4*a*c

   fld qword [d]    ; 
   fcom qword [zero]; 
   fstsw ax         ; 
   sahf             ;
   jle exit         ;

   fsqrt            ; sqrt(d)
   fld qword [b]    ; b  sqrt(d)
   fchs             ; -b  sqrt(d)
   faddp st1, st0   ; sqrt(d)-b
   fld qword [a]    ; a  sqrt(d)-b
   fld qword [two]  ; 2  a  sqrt(d)-b
   fmul             ; 2*a  sqrt(d)-b
   fdivp st1, st0   ; (sqrt(d)-b) / (2a)
   fst qword [x1]   ; x1 = (sqrt(d)-b) / (2a)
 
   fld qword [b]    ; b  (sqrt(d)-b) / (2a)  
   fchs             ; -b  (sqrt(d)-b) / (2a) 
   fld qword [d]    ; d  -b  (sqrt(d)-b) / (2a)
   fsqrt            ; sqrt(d)  -b  (sqrt(d)-b) / (2a)
   fsubp st1, st0   ; -b-sqrt(d)  (sqrt(d)-b) / (2a) 
   fld qword [a]    ; a  -b-sqrt(d)  (sqrt(d)-b) / (2a)   
   fld qword [two]  ; 2  a  -b-sqrt(d)  (sqrt(d)-b) / (2a)  
   fmul             ; 2*a  -b-sqrt(d)  (sqrt(d)-b) / (2a) 
   fdivp st1, st0   ; (-b-sqrt(d)) / (2a)  (sqrt(d)-b) / (2a) 
   fst qword [x2]   ; x2 = (-b-sqrt(d)) / (2a)

   exit: ret

section .note.GNU-stack

times 256  dd 0
