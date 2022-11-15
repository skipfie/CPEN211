module cpu(input clk, input rst_n, input load, input start, input [15:0] instr,
           output waiting, output [15:0] out, output N, output V, output Z);
    reg [15:0] instr_reg;

    // for datapath
    

    always_ff @(posedge clk) begin
        if (load) instr_reg <= instr;
    end

endmodule: cpu
