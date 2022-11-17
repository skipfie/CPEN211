module tb_controller(output err);
  reg nerr = 1'b0;
  assign err = nerr;
  integer failed = 0;
  integer passed = 0;

  reg clk, rst_n, start, Z, V, N;
  reg [1:0] ALU_op, shift_op;
  reg [2:0] opcode;

  //controller input
  wire waiting, en_A, en_B, en_C, en_status, sel_A, sel_B, w_en;
  wire [1:0] reg_sel, wb_sel; 

  controller dut. (.clk(clk), .rst_n(rst_n), .start(start),
                   .opcode(opcode), .ALU_op(ALU_op), .shift_op(shift_op), 
                   .Z(Z), .N(N), .V(V),
                   .waiting(waiting),
                   .reg_sel(reg_sel), .wb_sel(wb_sel), .w_en(w_en),
                   .en_A(en_A), );

endmodule: tb_controller
