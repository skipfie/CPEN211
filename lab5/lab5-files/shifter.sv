module shifter(input [15:0] shift_in, input [1:0] shift_op, output reg [15:0] shift_out);
    reg nout;
    assign shift_out = nout;

    always_comb begin
        case (shift_op) 
            2'b00: nout = ;
            2'b01: nout = ;
            2'b10: nout = ;
            2'b11: nout = ;
        endcase
    end
endmodule: shifter
