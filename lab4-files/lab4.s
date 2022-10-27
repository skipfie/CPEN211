.globl binary_search
binary_search:
// int *numbers: r0 , int key: r1 , int length: r2
  mov r3,#0         // int startIndex = 0
  sub r4,r2,#1      // int endIndex = length - 1
  lsr r5,r4,#1      // int middleIndex = endIndex/2
  mov r6,#-1


  str r0, []
  mov pc,lr