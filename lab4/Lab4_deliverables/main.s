// INSTRUCTIONS: To use this file with your "lab4.s" 
// ensure the first two lines in binary_search contain the
// following two lines but without "//" at the beginning:
//
// .globl binary_search
// binary_search:
//
// Then, add main.s to your project and compile as normal.
// If you defined your own "_start" function in lab4.s
// then rename it to something else like "_mystart" to avoid
// compilation errors.
//
// The code below uses KEY3, KEY0, SW0-SW9 and LEDR0-LEDR9
// to interact with your binary_search.  When started, the
// code enters a loop that continuously checks the values
// on SW0-SW9 and displays them on LEDR0-LEDR9 until you
// press KEY3.  Then, it initializes numbers and calls
// your binary_search function.  After your binary_search
// the code below will display the result on LEDR0-LEDR9 and
// wait for you to press KEY0.  After pressing KEY0 the 
// program again loops back to checking the values on SW0-SW9.

.include "address_map_arm.s"
.text
.globl _start
_start:
      ldr r4,=SW_BASE
      ldr r5,=KEY_BASE 
      ldr r6,=LEDR_BASE

      // enter the value of "key" on SW0-SW9 here, then press KEY3
wait_key3:
      ldr r7,[r4]         // Read SW0-SW9 into R7

      str r7,[r6]         // Show SW0-SW9 value on LEDR0-LEDR9
      // NOTE: str r7,[r6] is at address 0x00000010. If your 
      // binary search "jumps" to the above instruction this 
      // is likely because an LDR or STR instruction inside your 
      // binary_search function accesses an address that is NOT
      // a multiple of 4.  Using LDR or STR with such an address
      // triggers a ``Data Abort'' exception, which in turn 
      // causes the Cortex-A9 to set the PC to 0x00000010.  
      // Debug tip: Check you write -numData to the right 
      // address in memory.

      ldr r9,[r5]         // Read KEY0-KEY3 into R9 

      ands r9,r9,#8       // Is KEY3 pressed?
      // Value on KEY3 is in bit position 3 of R9.  Why 8?  
      // Remember that 8 is 1000 in binary, where the 1 is in 
      // bit position 3.  Recall that ANDS is AND that sets 
      // the status bits.  
      // 
      // If KEY3 is pressed ands r9,r9,#8 sets Z flag to 0 
      // to indicate R9 is not zero.  
      //
      // If KEY3 is NOT pressed ands r9,r9,#8 sets Z flag to 1 
      // to indicate R9 is zero.

      beq wait_key3       // Branch if Z=1 (KEY3 was NOT pressed)

      // initialize numbers array by copying array "data" to "numbers"
      ldr r0, =data
      ldr r1, =numbers
      mov r2,#100
      add r2,r0, r2, LSL #2
      bl  init_numbers

      ldr r0, =numbers    // 1st argument in R0 = numbers
      mov r1,r7           // 2nd argument in R1 = key
      mov r2,#100         // 3rd argument in R2 = length

      // caller saving registers here because we are not expecting student submissions to respect ARM calling convensions
      push {r4-r12,r14}       // save to stack
      ldr r3,=mystackptr  // 
      str sp,[r3]         // saving value of stack pointer to mystackptr 

      bl  binary_search   // call binary_search    

      // caller restoring registers, starting with stack pointer which might have been clobbered
      ldr r3, =mystackptr
      ldr sp,[r3]
      pop  {r4-r12,r14}

      // setting r4, r5, r6 back to non-garbage values
      ldr r4,=SW_BASE
      ldr r5,=KEY_BASE 
      ldr r6,=LEDR_BASE

      str r0,[r6]         // display result on LEDR0-LEDR9 (check your result!)
     
      // If not single-stepping then select "Actions>Stop" before pressing 
      // KEY0.  Then, check values in numbers array are correct by clicking on
      // the "Memory" tab in the Altera Monitor Program.  You can set the number
      // format of memory by right-clicking on the background, selecting "Number
      // format" then "Decimal".  Repeat and in the last step select "Signed 
      // representation".  If endIndex was 99, you should see something like 
      // Figure 6 in the Lab 9 handout.

wait_key0:                
      ldr  r1,[r5]        // read KEY0-KEY3
      ands r1,r1,#1       // check if KEY0 pressed
      beq  wait_key0      // wait for KEY0 to be pressed

      b wait_key3         // go back and try another search

// "init_numbers" copies array pointed at by r0 into array pointed at by r1
// The following code is NOT recursive.  It contains a loop.
init_numbers:
      ldr r3, [r0], #4
      str r3, [r1], #4
      cmp r0, r2
      blt init_numbers
      mov pc, lr

mystackptr:
.word 0

data:
.word 28
.word 37
.word 44
.word 60
.word 85
.word 99
.word 121
.word 127
.word 129
.word 138

.word 143
.word 155
.word 162
.word 164
.word 175
.word 179
.word 205
.word 212
.word 217
.word 231

.word 235
.word 238
.word 242
.word 248
.word 250
.word 258
.word 283
.word 286
.word 305
.word 311

.word 316
.word 322
.word 326
.word 351
.word 355
.word 364
.word 366
.word 376
.word 391
.word 398

.word 408
.word 410
.word 415
.word 418
.word 425
.word 437
.word 441
.word 452
.word 474
.word 488

.word 506
.word 507
.word 526
.word 532
.word 534
.word 547
.word 548
.word 583
.word 585
.word 595

.word 603
.word 621
.word 640
.word 661
.word 666
.word 690
.word 692
.word 713
.word 719
.word 750

.word 755
.word 768
.word 775
.word 776
.word 784
.word 785
.word 791
.word 797
.word 798
.word 804

.word 828
.word 842
.word 846
.word 858
.word 884
.word 887
.word 890
.word 893
.word 908
.word 936

.word 939
.word 953
.word 960
.word 970
.word 978
.word 979
.word 981
.word 990
.word 1002
.word 1007

numbers:
.fill 100,4,0xDEADBEEF   // set 100 locations to easily recognizable "bad" value
