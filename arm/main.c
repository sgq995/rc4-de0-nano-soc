#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define DEBUG 1

#define RC4_BASE 0xFF240000

#define get_bit(x, n) ((x) & (1 << n))
#define set_bit(x, n) (x) |= 1 << n
#define clear_bit(x, n) (x) &= ~(1 << n)

volatile int *RC4_ADDR;

void reset() {
  set_bit(*RC4_ADDR, 25);
}

void setkey(const char *key) {
  size_t keylength = strlen(key);
  *RC4_ADDR = (1 << 24) | ((int) keylength);
  
  for (size_t i = 0; i < keylength; ++i) {
    *RC4_ADDR = (1 << 24) | ((int) key[i]);
  }
}

unsigned char pollvalue() {
  int rc4_value;
  
  do {
	set_bit(*RC4_ADDR, 24);
    rc4_value = *RC4_ADDR;
  } while (!get_bit(rc4_value, 24));
  
  return (unsigned char) (rc4_value & 0xFF);
}

int list() {
  puts("1. Set key.");
  puts("2. Encrypt text.");
  puts("3. Decrypt text.");
  
  int result, select;
  do {
    result = scanf("%i", &select);
  } while (result < 1 && (select < 1 || select > 3));
  
  return select;
}

void myprint(const char *text, size_t textlength) {
  for (size_t i = 0; i < textlength; ++i) {
    printf("%02X", text[i]);
  }
  printf("\n");
}

int main(void) {
  RC4_ADDR = (int *) RC4_BASE;

  char key[256] = "Key";
  
  char text[256];
  size_t textlength;

  int select;
  unsigned char k;

  reset();
  setkey(key);

  if (DEBUG) {
    text[0] = 'P';
    text[1] = 'l';
    text[2] = 'a';
    text[3] = 'i';
    text[4] = 'n';
    text[5] = 't';
    text[6] = 'e';
    text[7] = 'x';
    text[8] = 't';
    text[9] = '\0';
    textlength = strlen(text);
    
    for (size_t i = 0; i < textlength; ++i) {
      k = pollvalue();
      printf("Value from stream: %02X\n", k);
      text[i] = text[i] ^ k;
    }

    printf("Result: ");
    myprint(text, textlength);
  }

  reset();
  setkey(key);

  while (1) {
    select = list();
    if (DEBUG) printf("Select: %d\n", select);
    
    switch (select) {
      case 1:
        printf("New key: ");
        scanf("%255s", key);
        reset();
        setkey(key);
        break;
      case 2:
        printf("Insert text: ");
        scanf("%255s", text);
        
        textlength = strlen(text);
        printf("In hexadecimal: ");
        myprint(text, textlength);
        if (DEBUG) printf("Text length: %d\n", textlength);
        for (size_t i = 0; i < textlength; ++i) {
          k = pollvalue();
          if (DEBUG) printf("Value from stream: %02X\n", k);
          text[i] = text[i] ^ k;
        }
        
        printf("Result: ");
        myprint(text, textlength);
        break;
      case 3:
        printf("Working in decipher text... ");
        
        reset();
        setkey(key);
        
        for (size_t i = 0; i < textlength; ++i) {
          k = pollvalue();
          if (DEBUG) printf("Value from string: %02X\n", k);
          text[i] = text[i] ^ k;
        }
        printf("done!\n");
        
        printf("Result: %02X\n", text);
		printf("Result: %s\n", text);
        break;
      default:
        break;
    }  
  }

  return 0;
}
