module regfile(input [15:0] w_data, input [2:0] w_addr, input w_en, input [2:0] r_addr, input clk, output [15:0] r_data);
  reg [15:0] m[0:7];
  assign r_data = m[r_addr];
  always_ff @(posedge clk) if (w_en) m[w_addr] <= w_data;
endmodule: regfile
