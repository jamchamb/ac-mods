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
    // Initialize offset into debug print2 buffer to 0 each call
    buffer_pos = 0;

    // Add OSGetTime display
    char timestr[40];
    int64_t time = OSGetTime();
    snprintf(timestr, sizeof(timestr), "time: %lld", time);
    addString(timestr, 1, 26, 0x6);

    // Add debug printf strings
    addString("Hello world!", 0xC, 0xC, 0x7);
    addString("Even more text!", 0xC, 0xE, 0x7);

    // Set print flag bit to enable debug_print2
    debug_print_flg |= 2;

    // Prints to in-game debug console (press Z with zuru mode enabled)
    JUTReportConsole("added a console message\n");
    JUTReportConsole_f("time: %lld\n", time);

    // Prints direct to screen
    JUTReport(0x20, 0x30, 1, "JUTReport %u", 1337);

    // Do the original function call
    Debug_mode_output(arg1);
}
