module tb_controller(output err);
  reg nerr = 1'b0;
  assign err = nerr;
  integer failed = 0;
  integer passed = 0;

  //controller input
  reg _waiting, _en_A, _en_B, _en_C, _en_status, _sel_A, _sel_B, _w_en;
  reg [1:0] _reg_sel, _wb_sel; 

  controller dut. (.clk(clk), .rst_n(rst_n), .start(start), .opcode(opcode), .ALU_op(ALU_op), .shift_op(shift_op), );

endmodule: tb_controller
