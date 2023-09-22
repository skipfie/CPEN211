/* This files provides address values that exist in the system */

/* Memory */
        .equ  DDR_BASE,             0x00000000
        .equ  DDR_END,              0x3FFFFFFF
        .equ  A9_ONCHIP_BASE,       0xFFFF0000
        .equ  A9_ONCHIP_END,        0xFFFFFFFF
        .equ  SDRAM_BASE,           0xC0000000
        .equ  SDRAM_END,            0xC3FFFFFF
        .equ  FPGA_ONCHIP_BASE,     0xC8000000
        .equ  FPGA_ONCHIP_END,      0xC803FFFF
        .equ  FPGA_CHAR_BASE,       0xC9000000
        .equ  FPGA_CHAR_END,        0xC9001FFF

/* Cyclone V FPGA devices */
        .equ  LEDR_BASE,             0xFF200000
        .equ  HEX3_HEX0_BASE,        0xFF200020
        .equ  HEX5_HEX4_BASE,        0xFF200030
        .equ  SW_BASE,               0xFF200040
        .equ  KEY_BASE,              0xFF200050
        .equ  JP1_BASE,              0xFF200060
        .equ  JP2_BASE,              0xFF200070
        .equ  PS2_BASE,              0xFF200100
        .equ  PS2_DUAL_BASE,         0xFF200108
        .equ  JTAG_UART_BASE,        0xFF201000
        .equ  JTAG_UART_2_BASE,      0xFF201008
        .equ  IrDA_BASE,             0xFF201020
        .equ  TIMER_BASE,            0xFF202000
        .equ  TIMER_2_BASE,          0xFF202020
        .equ  AV_CONFIG_BASE,        0xFF203000
        .equ  PIXEL_BUF_CTRL_BASE,   0xFF203020
        .equ  CHAR_BUF_CTRL_BASE,    0xFF203030
        .equ  AUDIO_BASE,            0xFF203040
        .equ  VIDEO_IN_BASE,         0xFF203060
        .equ  ADC_BASE,              0xFF204000

/* Cyclone V HPS devices */
        .equ   HPS_GPIO1_BASE,       0xFF709000
        .equ   I2C0_BASE,            0xFFC04000
        .equ   I2C1_BASE,            0xFFC05000
        .equ   I2C2_BASE,            0xFFC06000
        .equ   I2C3_BASE,            0xFFC07000
        .equ   HPS_TIMER0_BASE,      0xFFC08000
        .equ   HPS_TIMER1_BASE,      0xFFC09000
        .equ   HPS_TIMER2_BASE,      0xFFD00000
        .equ   HPS_TIMER3_BASE,      0xFFD01000
        .equ   FPGA_BRIDGE,          0xFFD0501C

/* ARM A9 MPCORE devices */
        .equ   PERIPH_BASE,          0xFFFEC000   /* base address of peripheral devices */
        .equ   MPCORE_PRIV_TIMER,    0xFFFEC600   /* PERIPH_BASE + 0x0600 */

        /* Interrupt controller (GIC) CPU interface(s) */
        .equ   MPCORE_GIC_CPUIF,     0xFFFEC100   /* PERIPH_BASE + 0x100 */
        .equ   ICCICR,               0x00         /* CPU interface control register */
        .equ   ICCPMR,               0x04         /* interrupt priority mask register */
        .equ   ICCIAR,               0x0C         /* interrupt acknowledge register */
        .equ   ICCEOIR,              0x10         /* end of interrupt register */
        /* Interrupt controller (GIC) distributor interface(s) */
        .equ   MPCORE_GIC_DIST,      0xFFFED000   /* PERIPH_BASE + 0x1000 */
        .equ   ICDDCR,               0x00         /* distributor control register */
        .equ   ICDISER,              0x100        /* interrupt set-enable registers */
        .equ   ICDICER,              0x180        /* interrupt clear-enable registers */
        .equ   ICDIPTR,              0x800        /* interrupt processor targets registers */
        .equ   ICDICFR,              0xC00        /* interrupt configuration registers */

.text
.globl _start
_start:
        ldr r4,=SW_BASE
        ldr r5,=KEY_BASE 
        ldr r6,=LEDR_BASE

        // Initializing values for r0 and r1
redo:
        ldr r7,[r4]             // Read SW0-SW9 into r7      
        ldr r8,[r5]             // Read KEY0-KEY3 into r8
        mov r0,r7               // 1st argument in r0 = value 1 --> Provided by r7
        mov r1,r8               // 2nd argument in r1 = value 2 --> Provided by r8

        // Caller saving registers
        push {r4-r12,r14}       // Save to stack
        ldr r3,=mystackptr 
        str sp,[r3]             // Saving value of stack pointer to mystackptr 

        bl hcf
        str r0,[r6]             // Display result on LEDR0-LEDR9 (check your result!)
	  
        // caller restoring registers, starting with stack pointer
        ldr r3, =mystackptr
        ldr sp,[r3]
        pop  {r4-r12,r14}
	
        // setting r4, r5, r6, r8 back to non-garbage values
        ldr r4,=SW_BASE
        ldr r5,=KEY_BASE 
        ldr r6,=LEDR_BASE
     
	b redo                 // Redo the hcf function

mystackptr:
.word 0

//------ DO NOT EDIT ANY LINES ABOVE THIS LINE --------//
//------ DO NOT EDIT ANY LINES ABOVE THIS LINE --------//
//-------------------- LPT-2 --------------------------//
//---------------- HCF FUNCTION -----------------------//

hcf:
//------ DO NOT EDIT ANY LINES ABOVE THIS LINE --------//
//------ DO NOT EDIT ANY LINES ABOVE THIS LINE --------//
//------ DO NOT EDIT ANY LINES ABOVE THIS LINE --------//
        cmp r0, #0
        beq zero
        cmp r1, #0
        beq zero             // if (r0 == 0 || r1 == 0) return;

        cmp r0, r1          
        beq rtn             // else if (r0 == r1)

        bgt gt              // else if (r0 > r1)
        blt lt              // else

        b rtn // return
zero:
        mov r0, #0
        mov r1, #0
        b rtn
lt:
        sub r1, r1, r0
        b hcf

gt:
        sub r0, r0, r1
        b hcf
rtn:
        mov pc,lr              // Return to the caller