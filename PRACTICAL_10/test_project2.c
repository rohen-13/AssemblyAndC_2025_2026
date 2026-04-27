/* Project 2 test file */
#include <assert.h>
#include <stdio.h>

extern int register_adder(int first, int second);

int main(void)
{
    assert(register_adder(7, 5) == 12);
    assert(register_adder(-3, 10) == 7);
    assert(register_adder(-5, 9) == 4);
    assert(register_adder(0, 0) == 0);

    printf("All C tests passed.\n");
    return 0;
}
