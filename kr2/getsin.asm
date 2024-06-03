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
