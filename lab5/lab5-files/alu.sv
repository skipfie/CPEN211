module ALU(input [15:0] val_A, input [15:0] val_B, input [1:0] ALU_op, output [15:0] ALU_out, output Z);
    reg Z;
    reg [15:0] nout;

    always_comb begin
        if (nout == 16'd0) begin
            Z = 1'b1;
        end else begin
            Z = 0'b1;
        end
    end

    always_comb begin
        case (ALU_op) 
        2'b00: nout = val_A + val_B;
        2'b01: nout = val_A - val_B;
        2'b10: nout = val_A & val_B;
        2'b11: nout = ~val_B;
        endcase
    end
endmodule: ALU
