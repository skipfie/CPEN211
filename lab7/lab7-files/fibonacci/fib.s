/* For this task, write a Potato Machine™ assembly program that (i) reads value 𝑛 from memory at address 255,
(ii) iteratively computes the 𝑛th Fibonacci number, and (iii) stores it in memory at address 254. Your program
will be started at PC = 0.

This would of course be trivial if it weren’t for the fact that we don’t have any branches, and we don’t have a
way to compute with the result of CMP. But notice that: (i) our data and instructions reside in the same memory,
and (ii) you can use arithmetic to simulate conditional operations. */
mov r6, #255 // HALT instr
mov r5, #-1
mov r7, #127
mov r7, r7, LSL#1
ldr r0, [r7, #1] // r0 = n
// start fibonacci
mov r1, #1 // a
mov r2, #1 // b
str r1, [r7]
add r0, r0, r5 // n--
str r2, [r7]
add r0, r0, r5 // n--
add r3, r1, r2 // c
mov r1, r2
mov r2, r3
str r2, [r7]
add r0, r0, r5 // n--
