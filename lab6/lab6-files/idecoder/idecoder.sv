module idecoder(input [15:0] ir, input [1:0] reg_sel,
                output [2:0] opcode, output [1:0] ALU_op, output [1:0] shift_op,
		output [15:0] sximm5, output [15:0] sximm8,
                output [2:0] r_addr, output [2:0] w_addr);
  // your implementation here
endmodule: idecoder
