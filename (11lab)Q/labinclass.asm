comma, decorator or end of line expected, got 45

extern void calculate_and_print(int arr[], int size); // Declare the NASM function

void print_numbers(int arr[], int size) {
    for (int i = 0; i < size; i++) {
        // Manually define the printf function prototype
        extern int printf(const char *format, ...);
        printf("%d ", arr[i]);
    }
    printf("\n");
}

int main() {
    int arr[10000];  // Create an array to store the calculated numbers
    calculate_and_print(arr, 10000);  // Call the NASM function to calculate and print the numbers
    print_numbers(arr, 10000);  // Print the numbers again using the C function
    return 0;
}

section .text
global calculate_and_print

calculate_and_print:
    ; Arguments:
    ; [esp + 4] = pointer to the array
    ; [esp + 8] = size of the array

    ; Initialize the first three elements of the array
    mov dword [esp + 4], 1
    mov dword [esp + 8], 1
    mov dword [esp + 12], 1

    ; Calculate the rest of the array
    mov ecx, 3            ; Start from the 4th element (index 3)
calc_loop:
    cmp ecx, [esp + 8]    ; Compare loop counter with the size of the array
    jge print_result      ; If we've calculated the required number of elements, jump to printing

    ; Calculate the current element
    mov eax, [esp + 4 + ecx*4 - 4]
    mov ebx, [esp + 4 + ecx*4 - 8]
    mov edx, [esp + 4 + ecx*4 - 12]
    
    ; Calculate the next element based on the given formula
    sub ecx, eax
    mov esi, ecx
    add ecx, eax
    dec ecx
    sub ecx, ebx
    mov edi, ecx
    add ecx, ebx
    sub ecx, 2
    sub ecx, edx
    mov ebp, ecx
    add ecx, 2
    add ecx, edx

    mov eax, [esp + 4 + esi*4]
    mov ebx, [esp + 4 + edi*4]
    mov edx, [esp + 4 + ebp*4]

    add eax, ebx
    add eax, edx

    ; Store the result in the array
    mov [esp + 4 + ecx*4], eax

    inc ecx
    jmp calc_loop

print_result:
    ; Print the last 10 elements
    mov ecx, [esp + 8] - 10  ; Start printing from the (size - 10)th element
print_loop:
    cmp ecx, [esp + 8]        ; Print 10 elements
    jge end_printing

    ; Get the current element
    mov eax, [esp + 4 + ecx*4]

    ; Print the element
    push eax
    push dword fmt
    call printf
    add esp, 8                ; Clean up the stack

    inc ecx
    jmp print_loop

end_printing:
    ret

section .data
    fmt db "%d ", 0     ; Format string for printf
