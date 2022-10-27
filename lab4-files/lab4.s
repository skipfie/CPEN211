.globl binary_search
binary_search:
// int *numbers: r0 , int key: r1 , int length: r2
        mov r3,#0           // int startIndex = 0
        sub r4,r2,#1        // int endIndex = length - 1
        lsr r5,r4,#1        // int middleIndex = endIndex/2
        mov r6,#-1          // int keyIndex = -1
        mov r7,#1           // int NumIters = 1
        mov r8,#0           // int x
        

L1:     cmn r6,#1 // while (keyIndex == -1)
        bne Break
        
        cmp r3,r4 // if (startIndex > endIndex)
        bhi Break
        
        ldr r8,[r0,r5] // x = = numbers [ middleIndex ]
        cmp r8,r1 // else if (numbers [ middleIndex ] == key)
        moveq r6,r5 // keyIndex = middleIndex

        subhi r6,r5,1 // else if (numbers [ middleIndex ] > key); keyIndex = middleIndex - 1

        addlo r6,r5,1 // else; keyIndex = middleIndex + 1

        
        
        b L1 // while keyIndex == -1
Break:
        str r0, []
        mov pc,lr