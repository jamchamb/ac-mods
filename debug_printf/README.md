# debug_printf

This uses the built-in debug print functions to print to the screen.

## Setup

`Debug_mode_output` is originally called at `80404E24`

- Rewrite this to call into hook code at `80002000`
- Set debug print flag and line count, and fill text buffer
- Continue call to `Debug_mode_output`

## Printing text

- OR `debug_print_flag` with 2 (bit 30 must be set for `Debug_Print2_output`)
- Set `debug_print2_count` to number of lines to print
- Text buffer pointer is in `debug_print2_buffer`
  - Has `0xDC0` bytes of space
  - Each entry is `0x2C` (44) bytes
  - Fits a total of 80 entries

### Text line format

The first three bytes define position and color:

    [8bit column] [8bit row] [8bit color] [text...]
