module ALU(input [15:0] val_A, input [15:0] val_B, input [1:0] ALU_op, output [15:0] ALU_out, output Z);
    reg nZ;
    reg [15:0] nout;
    //reg [16:0] nand

    assign Z = nZ;
    assign ALU_out = nout;

    always_comb begin
        //nand = val_A
        if (nout == 16'd0) begin
            nZ = 1'b1;
        end else nZ = 1'b0;
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