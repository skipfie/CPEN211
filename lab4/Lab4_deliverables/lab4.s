.globl binary_search
binary_search:
// int *numbers: r0 , int key: r1 , int length: r2
        mov r3,#0           // int startIndex = 0
        sub r4,r2,#1        // int endIndex = length - 1
        lsr r5,r4,#1        // int middleIndex = endIndex/2
        mov r6,#-1          // int keyIndex = -1
        mov r7,#-1          // int NumIters = -1
        mov r8,#0           // int x
        mov r9,#0           // int y
        
L1:     cmn r6,#1 // while (keyIndex == -1)
        bne Break
        
        cmp r3,r4 // if (startIndex > endIndex)
        bgt Break
        
        ldr r8,[r0,r5,LSL#2] // x == numbers [ middleIndex ]
        cmp r8,r1 // else if (numbers [ middleIndex ] == key)
        moveq r6,r5 // keyIndex = middleIndex

        subgt r4,r5,#1 // else if (numbers [ middleIndex ] > key); endIndex = middleIndex - 1

        addlt r3,r5,#1 // else; startIndex = middleIndex + 1

        str r7,[r0,r5,LSL#2] // numbers[ middleIndex ] = NumIters (we switched it to negative)

        sub r8,r4,r3 // x = endIndex - startIndex
        lsr r9,r8,#1 // y = x/2

        add r5,r3,r9 // middleIndex = startIndex + y

        sub r7,r7,#1 // NumIters--

        b L1 // while keyIndex == -1
Break:
        mov r0,r6
        mov pc,lr