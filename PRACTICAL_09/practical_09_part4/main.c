#include <stdio.h>

extern int add(int a, int b, int c);
extern int sub(int a, int b);

int main(int argc, char **argv)
{
  printf("Add: %d\n", add(4, 6, 8));
  printf("Sub: %d\n", sub(10, 3));
  return 0;
}
