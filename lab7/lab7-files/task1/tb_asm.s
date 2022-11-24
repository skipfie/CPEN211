    mov r0, #69
    mov r1, #-69

    mov r7, r0
    mov r2, r0, LSL#1

    add r7, r0, r1

    mov r0, r0, LSL#1

    cmp r0, r2

    add r0, r0, r2, LSL#1

    cmp r2, r0

    mov r6, #127

    add r0, r0, r6, LSL#1

    mov r6, r0, LSL#1

    mov r0, r6, LSL#1

    mov r6, r0, LSL#1

    mov r0, r6, LSL#1

    mov r6, r0, LSL#1

    mov r0, r6

    mvn r5, r6

    mov r7, #1
    add r5, r5, r7

    cmp r6, r5

    cmp r5, r6

    mov r3, #111
    mov r4, #170
    and r7, r3, r4

    and r7, r6, r5

    halt