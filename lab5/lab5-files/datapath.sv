module datapath(input clk, input [15:0] datapath_in, input wb_sel,
                input [2:0] w_addr, input w_en, input [2:0] r_addr, input en_A,
                input en_B, input [1:0] shift_op, input sel_A, input sel_B,
                input [1:0] ALU_op, input en_C, input en_status,
                output [15:0] datapath_out, output Z_out);
  //for regfile
  reg [15:0] w_data;
  reg [2:0] w_addr, r_addr;
  reg w_en;
  wire [15:0] r_data;

  //for shifter
  reg [15:0] shift_in;
  reg [1:0] shift_op;
  wire [15:0] shift_out;

  //for ALU
  reg [1:0] ALU_op;
  reg signed [15:0] val_A, val_B, ALU_out;
  wire Z;

  //wb_sel mux
  always_comb begin 
    if (wb_sel == 1)
      w_data = datapath_in;
    else 
      w_data = 

  end
  //regfile instant



  //en_A & en_B & sel_A & sel_B
  always_ff @(posedge clk) begin
    
  end


  //ALU instant
  always_comb begin
    
  end

  ALU alu(.val_A(val_A), .val_B(val_B), .ALU_op(ALU_op), .ALU_out(ALU_out), .Z(Z));


  //en_C & en_status
  always_ff @(posedge clk) begin
    if (en_C == 1) C <= ALU_out;
    if (en_status == 1) Zout <= Z; 
  end

endmodule: datapath
