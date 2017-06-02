#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define get_bit(x, n) ((x) & (1 << n))
#define set_bit(x, n) (x) |= 1 << n
#define clear_bit(x, n) (x) &= ~(1 << n)

int main(void) {
	volatile int *rc4 = (int *) 0xFF240000;

	const char *key = "Key";
	size_t keylength = 3; // strlen(key);
	
	printf("%02X %02X %02X\n", key[0], key[1], key[2]);

	set_bit(*rc4, 25); // set_bit(*rc4, 25);
	*rc4 = (1 << 24) | ((int) keylength);
	// set_bit(*rc4, 24);
	*rc4 = (1 << 24) | ((int) key[0]);
	// set_bit(*rc4, 24);
	*rc4 = (1 << 24) | ((int) key[1]);
	// set_bit(*rc4, 24);
	*rc4 = (1 << 24) | ((int) key[2]);
	// set_bit(*rc4, 24);

	int rc4_value;
	int count = 0;
	unsigned char wait;

	rc4_value = *rc4;
	printf("%08X\n", rc4_value);

	while (1) {
		if (count < 9) {
			set_bit(*rc4, 24);

			do {
				rc4_value = *rc4;
			} while (!get_bit(rc4_value, 24));
			printf("%08X\n", rc4_value);

			count = count + 1;
		}
	}

	return 0;
}
