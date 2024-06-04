#include <stdio.h>

extern void calculate_and_print(int arr[], int size); // Declare the NASM function

void print_numbers(int arr[], int size) {
    for (int i = 0; i < size; i++) {
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
