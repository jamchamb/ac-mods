#ifndef ACLIB_H
#define ACLIB_H

#include <stddef.h>

// standard C functions
// extern int memcmp(const void *ptr1, const void *ptr2, size_t num);
// extern void *memcpy(void *destination, const void *source, size_t num);
//
// extern int sprintf(char *str, const char *format, ...);
//
// extern size_t strlen(const char *str);
// extern char *strncpy(char *destination, const char *source, size_t num);

// GameCube functions
extern void OSReport(char*, ...);

// Animal Crossing functions
extern void Debug_mode_output(void *arg1);

#endif
