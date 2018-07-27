#ifndef ACLIB_H
#define ACLIB_H

#include <stddef.h>
#include <stdint.h>

// standard C function prototypes are pulled from devkitpro header files

// GameCube functions
extern void OSReport(char*, ...);
extern int64_t OSGetTime();
extern void JUTReportConsole(char*);
extern void JUTReportConsole_f(char*, ...);
extern void JUTReport(int, int, int, char const *, ...);

// Animal Crossing functions
extern void Debug_mode_output(void *arg1);

#endif
