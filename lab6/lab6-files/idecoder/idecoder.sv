module idecoder(input [15:0] ir, input [1:0] reg_sel,
                output [2:0] opcode, output [1:0] ALU_op, output [1:0] shift_op,
		        output [15:0] sximm5, output [15:0] sximm8,
                output [2:0] r_addr, output [2:0] w_addr);

    reg [2:0] nr_addr, nw_addr;
    assign r_addr = nr_addr;
    assign w_addr = nw_addr;

    assign opcode = ir[15:13];
    assign ALU_op = ir[12:11];
    assign shift_op = ir[4:3];
    assign sximm5 = { {11{ir[4]}}, ir[4:0] };
    assign sximm8 = { {8{ir[7]}}, ir[7:0] };

    wire [2:0] Rm, Rd, Rn;
    assign Rm = ir[2:0];
    assign Rd = ir[7:5];
    assign Rn = ir[10:8];

    always_comb begin
        case (reg_sel)
            2'b00: begin
                nr_addr = Rm;
                nw_addr = Rm;
            end
            2'b01: begin
                nr_addr = Rd;
                nw_addr = Rd;
            end
            2'b10: begin
                nr_addr = Rn;
                nw_addr = Rn;
            end
            default: begin
            end // 11 is unused
        endcase
    end

endmodule: idecoder
