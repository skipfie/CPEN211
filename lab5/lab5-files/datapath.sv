module datapath(input clk, input [15:0] datapath_in, input wb_sel,
                input [2:0] w_addr, input w_en, input [2:0] r_addr, input en_A,
                input en_B, input [1:0] shift_op, input sel_A, input sel_B,
                input [1:0] ALU_op, input en_C, input en_status,
                output [15:0] datapath_out, output Z_out);
  reg datapath_out;
  
  always_comb begin 
    if (wb_sel == 1)
      w_data = datapath_in;
    else 
      w_data = 

  end

  always_ff @(posedge clk) begin
    
  end

  always_comb begin
    
  end


endmodule: datapath
