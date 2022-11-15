module ALU(input [15:0] val_A, input [15:0] val_B, input [1:0] ALU_op, 
           output [15:0] ALU_out, output reg Z, output reg N, output reg V);
    always_comb begin
        if (out == 16'd0)
            Z = 1'b1;
        else Z = 1'b0;
        if (out [15] == 1)
            N = 1'b1;
        else N = 1'b0;
        if (val_A ^ val_B[15])
            V = 1'b1;
        else V = 1'b0;
    end

    always_comb begin
        case (ALU_op) 
            2'b00: out = val_A + val_B;
            2'b01: out = val_A - val_B;
            2'b10: out = val_A & val_B;
            2'b11: out = ~val_B;
        endcase
    end
endmodule: ALU
