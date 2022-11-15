module datapath(input clk, input [15:0] mdata, input [7:0] pc, input [1:0] wb_sel,
                input [2:0] w_addr, input w_en, input [2:0] r_addr, input en_A,
                input en_B, input [1:0] shift_op, input sel_A, input sel_B,
                input [1:0] ALU_op, input en_C, input en_status,
		            input [15:0] sximm8, input [15:0] sximm5,
                output [15:0] datapath_out, output Z_out, output N_out, output V_out);
  //for regfile
  reg [15:0] w_data;
  reg [15:0] r_data;

  //for shifter
  reg [15:0] shift_in;
  wire [15:0] shift_out;

  //for ALU
  reg signed [15:0] val_A, val_B, ALU_out;
  wire Z, V, N;

  //for the rest of the connections
  reg [15:0] A, C;
  assign datapath_out = C;
  reg [2:0] status;
  assign Z_out = status[2];
  assign N_out = status[1];
  assign V_out = status[0];

  //instaniation of ALU, shifter, and regfile
  ALU alu(.val_A(val_A), .val_B(val_B), .ALU_op(ALU_op), .ALU_out(ALU_out), .Z(Z), .N(N), .V(V));
  shifter shifter(.shift_in(shift_in), .shift_op(shift_op), .shift_out(shift_out));
  regfile regfile(.w_data(w_data), .w_addr(w_addr), .w_en(w_en), .r_addr(r_addr), .clk(clk), .r_data(r_data));

  //mux #6,7,9
  always_comb begin 
    if (sel_A == 1)
      val_A = 16'b0;
    else 
      val_A = A;
    
    if (sel_B == 1)
      val_B = {sximm5};
    else 
      val_B = shift_out;

    case (wb_sel)
      2'b00: w_data = C;
      2'b01: w_data = {8'b0, pc};
      2'b10: w_data = sximm8;
      2'b11: w_data = mdata;
    endcase
  end
  //registers with enable
  always_ff @(posedge clk) begin
    if (en_A) A <= r_data; //A
    if (en_B) shift_in <= r_data; //B
    if (en_C) C <= ALU_out; //C
    if (en_status) begin //status
        status <= {Z,N,V};
    end
  end
endmodule: datapath
