#include <stdio.h>

int foo();
int private_foo();

int main()
{
	printf("foo: %d\n", private_foo());
	return 0;
}
