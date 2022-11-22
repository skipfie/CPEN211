module ALU(input [15:0] val_A, input [15:0] val_B, input [1:0] ALU_op, 
           output reg [15:0] ALU_out, output reg Z, output reg N, output reg V);
    always_comb begin
        Z = (ALU_out == 16'd0);
        N = (ALU_out[15] == 1'b1);
    end

    always_comb begin
        case (ALU_op) 
            2'b00: begin
                ALU_out = val_A + val_B;
                V = (val_A[15] & val_B[15] & ~ALU_out[15]) | (~val_A[15] & ~val_B[15] & ALU_out[15]);
            end
            2'b01: begin
                ALU_out = val_A - val_B;
                V = (val_A[15] & ~val_B[15] & ~ALU_out[15]) | (~val_A[15] & val_B[15] & ALU_out[15]);
            end
            2'b10: begin
                ALU_out = val_A & val_B;
                V = 1'b0;
            end
            2'b11: begin
                ALU_out = ~val_B;
                V = 1'b0;
            end
        endcase
    end
endmodule: ALU