ENTRY(__entry)
SECTIONS
{
        . = 0x80002000;
        .text . : {
               *(.text.__entry);
               *(.text*);
        }

        memcpy = 0x80003490;
        memcmp = 0x8009CFF4;

        sprintf = 0x8005CE48;
        snprintf = 0x8009D454;

        strlen = 0x8009F84C;
        strncpy = 0x8009F750;

        OSGetTime = 0x8007F6F8;
        OSReport = 0x8005A750;

        JUTReportConsole = 0x800771B0;
        JUTReportConsole_f = 0x80077124;
        JUTReport = 0x80070198;

        debug_print_flg = 0x81294010;
        debug_print2_buffer = 0x81294018;
        debug_print2_count = 0x81294014;
        Debug_mode_output = 0x8039816C;
}
