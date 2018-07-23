#include <stdio.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include "aclib.h"

extern uint32_t debug_print_flg;
extern uint16_t debug_print2_count;
extern char *debug_print2_buffer;

#define MAX_LINES 80
#define LINE_LEN 44

size_t buffer_pos;

void addString(const char* string, char column, char row, char color) {
    if (debug_print2_count >= MAX_LINES) return;

    size_t length = strlen(string);
    if (length > 40) return;

    char *dest = (void*)&debug_print2_buffer + buffer_pos;

    snprintf(dest, LINE_LEN, "%c%c%c%s", column, row, color, string);

    buffer_pos += LINE_LEN;

    debug_print2_count += 1;
}

/*
 * Hooks call to Debug_mode_output at 0x80404E24
 */
void __entry(void *arg1) {
    OSReport("DEBUG PRINT FUNCTION START");

    buffer_pos = 0;

    addString("Hello world!", 0xC, 0xC, 0x7);
    addString("Even more text!", 0xC, 0xE, 0x7);

    debug_print_flg |= 2;

    Debug_mode_output(arg1);

    OSReport("DEBUG PRINT FUNCTION END");
}
