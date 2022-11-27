/* For this task, write a Potato Machine™ assembly program that (i) reads value 𝑛 from memory at address 255,
(ii) iteratively computes the 𝑛th Fibonacci number, and (iii) stores it in memory at address 254. Your program
will be started at PC = 0.

This would of course be trivial if it weren’t for the fact that we don’t have any branches, and we don’t have a
way to compute with the result of CMP. But notice that: (i) our data and instructions reside in the same memory,
and (ii) you can use arithmetic to simulate conditional operations. */
mov r7, #254
ldr r0, [r7, #1] // r0 = n
mov r1, r0, LSL#1
mov r1, r1, LSL#1 // r1 = n * 4
str r7, [r1, #5] // write HALT to correct address (hopefully)

// start fibonacci
//1
mov r1, #1      // a = 1
mov r1, r1
mov r1, r1
str r1, [r7]
//2
mov r2, #1      // b = 1
mov r1, r1
mov r1, r1
str r2, [r7]
//3
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 
//4
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 
//5
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 
//6
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 
//7
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 
//8
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 
//9
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 
//10
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 
//11
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 
//12
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 
//13
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 
//14
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 
//15
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 
//16
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 
//17
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 
//18
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 
//19
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 
//20
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 
//21
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 
//22
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 
//23
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 
//24
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 
//25
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 
//26
add r3, r1, r2  // sum = a+b
mov r1, r2      // a=b
mov r2, r3      // b=sum
str r2, [r7] 