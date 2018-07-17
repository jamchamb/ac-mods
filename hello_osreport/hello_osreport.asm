.text

b start

; basic function that demonstrates calling convention
; this calls OSReport, which prints to the log
osReport:
        ; prologue
        ; need a minimum of 8 bytes of new stack.
        ; don't store within the first 8 bytes because a called
        ; function may overwrite that area.
        stwu      r1, -0xC(r1)
        mfspr     r0, LR
        ; save LR at offset +4 of new stack
        stw       r0, 0x10(r1)
        ; save register that will be used to branch
        stw       r8, 0x8(r1)

        ; this always appears before OSReport
        crclr     4*cr1+eq

        lis       r8, OS_REPORT@h
        ori       r8, r8, OS_REPORT@l
        mtctr     r8
        bctrl

        ; restore register used to branch
        lwz       r8, 0x8(r1)

        ; epilogue
        ; restore LR
        lwz       r0, 0x10(r1)
        mtspr     LR, r0
        ; shrink stack
        addi      r1, r1, 0xC
        ; return to caller
        blr

start:
        ; prologue
        stwu      r1, -0x20(r1)
        ; r0 is passed from loader hook
        ;mfspr    r0, LR
        stw       r0, 0x24(r1)

        ; call OSReport(msg)
        lis       r3, (START_ADDR+msg)@ha
        addi      r3, r3, (START_ADDR+msg)@l
        bl        osReport

        ; epilogue
        lwz       r0, 0x24(r1)
        mtspr     LR, r0
        addi      r1, r1, 0x20
        blr

msg:
        .string "Hello, world!\0"

.data
START_ADDR = 0x80002000
OS_REPORT = 0x8005A750
