module regfile(input logic clk, input logic [15:0] w_data, input logic [2:0] w_addr, input logic w_en, input logic [2:0] r_addr, output logic [15:0] r_data);
    logic [15:0] m[0:7];
    assign r_data = m[r_addr];
    always_ff @(posedge clk) if (w_en) m[w_addr] <= w_data;
endmodule: regfile

