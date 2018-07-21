ENTRY(__entry)
SECTIONS
{
        . = 0x80002000;
        .text . : {
               *(.text.__entry);
               *(.text*);
        }

        OSReport = 0x8005A750;
}
