module datapath(input clk, input [15:0] datapath_in, input wb_sel,
                input [2:0] w_addr, input w_en, input [2:0] r_addr, input en_A,
                input en_B, input [1:0] shift_op, input sel_A, input sel_B,
                input [1:0] ALU_op, input en_C, input en_status,
                output [15:0] datapath_out, output Z_out);
  //for regfile
  reg [15:0] w_data;
  reg [15:0] r_data;

  //for shifter
  reg [15:0] shift_in;
  wire [15:0] shift_out;

  //for ALU
  reg signed [15:0] val_A, val_B, ALU_out;
  wire Z;

  //for the rest of the connections
  reg [15:0] A, C;
  assign datapath_out = C;

  //instaniation of ALU, shifter, and regfile
  ALU alu(.val_A(val_A), .val_B(val_B), .ALU_op(ALU_op), .ALU_out(ALU_out), .Z(Z));
  shifter shifter(.shift_in(shift_in), .shift_op(shift_op), .shift_out(shift_out));
  regfile regfile(.w_data(w_data), .w_addr(w_addr), .w_en(w_en), .r_addr(r_addr), .clk(clk), .r_data(r_data));

  //mux #6,7,9
  always_comb begin 
    if (sel_A == 1)
      val_A = 16'b0;
    else 
      val_A = A;
    
    if (sel_B == 1)
      val_B = {11'b0, datapath_in[4:0]};
    else 
      val_B = shift_out;

    if (wb_sel == 1)
      w_data = datapath_in;
    else 
      w_data = C;
  end

  //three 16bit registers with enable
  always_ff @(posedge clk) begin
    if (en_A) A <= r_data;
    if (en_B) shift_in <= r_data;
    if (en_C) C <= ALU_out;
  end

  //1bit registers with enable
  always_ff @(posedge clk) begin
    if (en_status) Z_out <= Z;
  end
endmodule: datapath