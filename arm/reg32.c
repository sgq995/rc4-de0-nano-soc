#include <stdio.h>

#define get_bit(x, n) ((x) & (1 << n))
#define set_bit(x, n) (x) |= 1 << n
#define clear_bit(x, n) (x) &= ~(1 << n)

int main(void) {
	volatile int *reg32 = (int *) 0xFF250000;
	printf("%08X\n", *reg32);

	set_bit(*reg32, 24);
	printf("%08X\n", *reg32);

	*reg32 = 0xF;
	printf("%08X\n", *reg32);

	set_bit(*reg32, 24);
	printf("%08X\n", *reg32);

	*reg32 = 0xFF000;
	printf("%08X\n", *reg32);

	while (1) {
	}

	return 0;
}
