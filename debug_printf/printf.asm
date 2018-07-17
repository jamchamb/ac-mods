.text

b start

; print string to console
osReport:
        stwu      r1, -0xC(r1)
        mfspr     r0, LR
        stw       r0, 0x10(r1)
        stw       r8, 0x8(r1)

        crclr     4*cr1+eq

        lis       r8, OS_REPORT@h
        ori       r8, r8, OS_REPORT@l
        mtctr     r8
        bctrl

        lwz       r8, 0x8(r1)
        lwz       r0, 0x10(r1)
        mtspr     LR, r0
        addi      r1, r1, 0xC
        blr

memcpy:
        stwu      r1, -0xC(r1)
        mfspr     r0, LR
        stw       r0, 0x10(r1)
        stw       r8, 0x8(r1)

        lis       r8, MEMCPY@h
        ori       r8, r8, MEMCPY@l
        mtctr     r8
        bctrl

        lwz       r8, 0x8(r1)
        lwz       r0, 0x10(r1)
        mtspr     LR, r0
        addi      r1, r1, 0xC
        blr

addOutputString:
        stwu      r1, -0x18(r1)
        mfspr     r0, LR
        stw       r0, 0x1C(r1)
        stw       r3, 0x08(r1)
        stw       r4, 0x0C(r1)
        stw       r5, 0x10(r1)
        stw       r6, 0x14(r1)

        ; length
        mr        r5, r4

        ; source = input string ptr
        mr        r4, r3

        ; get debug2 buf position
        lwz       r6, 0x18(r1)

        ; dst = debug buffer + (0x2C * index)
        lis       r3, DEBUG2_BUF@ha
        ori       r3, r3, DEBUG2_BUF@l
        add       r3, r3, r6

        bl memcpy

        ; update debug2 buf position
        lwz       r6, 0x18(r1)  ; memcpy overwrites r6
        addi      r6, r6, 0x2C
        stw       r6, 0x18(r1)

        ; Update number of lines to display
        lis       r3, DEBUG2_COUNT@ha
        ori       r3, r3, DEBUG2_COUNT@l
        lhz       r4, 0(r3)
        addi      r4, r4, 1
        sth       r4, 0(r3)

        lwz       r3, 0x08(r1)
        lwz       r4, 0x0C(r1)
        lwz       r5, 0x10(r1)
        lwz       r6, 0x14(r1)
        lwz       r0, 0x1C(r1)
        mtspr     LR, r0
        addi      r1, r1, 0x18
        blr

start:
        ; prologue
        stwu      r1, -0x20(r1)
        ; not called from loader hook; save LR
        mfspr     r0, LR
        stw       r0, 0x24(r1)
        stw       r3, 0x08(r1)
        stw       r4, 0x0C(r1)
        stw       r5, 0x10(r1)
        stw       r6, 0x14(r1)
        stw       r7, 0x18(r1)
        stw       r8, 0x1C(r1)

        ; intro log message
        lis       r3, (START_ADDR+startmsg)@ha
        addi      r3, r3, (START_ADDR+startmsg)@l
        bl osReport

        ; Initialize debug2 buffer input position
        li        r8, 0
        stw       r8, 0(r1)

        ; Get message address
        lis       r3, (START_ADDR+helloworld)@ha
        ori       r3, r3, (START_ADDR+helloworld)@l

        ; Message length
        li        r4, 17

        ; Update message color using current time second value
        lis       r6, COMMON_DATA@h
        ori       r6, r6, COMMON_DATA@l
        addis     r6, r6, 2
        lbz       r7, 0x6120(r6)
        clrlwi.   r7, r7, 28
        stb       r7, 0x2(r3)

        ; Copy hello world message to debug2 buffer
        bl addOutputString

        ; Add another message
        lis       r3, (START_ADDR+secondmsg)@ha
        ori       r3, r3, (START_ADDR+secondmsg)@l
        li        r4, 19
        bl addOutputString

        ; Set print flag bit 30
        lis       r3, DEBUG_PRINT_FLAG@ha
        ori       r3, r3, DEBUG_PRINT_FLAG@l
        lwz       r4, 0(r3)
        ori       r4, r4, 2
        stw       r4, 0(r3)

        ; outro log message
        lis       r3, (START_ADDR+endmsg)@ha
        addi      r3, r3, (START_ADDR+endmsg)@l
        bl osReport

        ; epilogue
        lwz       r3, 0x08(r1)
        lwz       r4, 0x0C(r1)
        lwz       r5, 0x10(r1)
        lwz       r6, 0x14(r1)
        lwz       r7, 0x18(r1)
        lwz       r8, 0x1C(r1)
        lwz       r0, 0x24(r1)
        mtspr     LR, r0
        addi      r1, r1, 0x20

        ; do what hooked location did before Debug_mode_output
        mr        r3, r29

        blr

        ; Hook code
        bl START_ADDR - HOOK_LOC

startmsg:
        .string "***STARTING DEBUG_PRINTF CODE***\0"

endmsg:
        .string "***ENDING DEBUG_PRINTF CODE***\0"

helloworld:
        .string "\x0C\x0C\x07Hello world!\0"

secondmsg:
        .string "\x0C\x0E\x07Even more text!\0"

.data
HOOK_LOC = 0x80404E20

START_ADDR = 0x80002000
OS_REPORT = 0x8005A750
MEMCPY = 0x80003490
DEBUG_MODE_OUTPUT = 0x8039816C

; Adjusted data pointers for Dolphin
;DEBUG_PRINT_FLAG = 0x81166230
DEBUG_PRINT_FLAG = 0x81294010
;DEBUG2_BUF = 0x81166238
DEBUG2_BUF = 0x81294018
;DEBUG2_COUNT = 0x81166234
DEBUG2_COUNT = 0x81294014

; Dolphin addr of common_data
COMMON_DATA = 0x81266400
