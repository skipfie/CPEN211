module tb_idecoder(output err);
    reg nerr = 1'b0;
    assign err = nerr;

    reg [7:0] failed = 8'd0;
    reg [7:0] passed = 8'd0;

    wire [1:0] ALU_op, shift_op;
    wire [2:0] opcode, r_addr, w_addr;
    wire [15:0] sximm5, sximm8;

    reg [15:0] ir;
    reg [1:0] reg_sel;

    idecoder dut(.ir(ir), .reg_sel(reg_sel),
                 .opcode(opcode), .ALU_op(ALU_op), .shift_op(shift_op),
                 .sximm5(sximm5), .sximm8(sximm8),
                 .r_addr(r_addr), .w_addr(w_addr));

    initial begin
        ir = 16'b1010111010011001;
        reg_sel = 2'b00;

        #10;

        assert (r_addr === ir[2:0]) begin
            $display("[PASS] r_addr is Rm (ir[2:0])");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] r_addr is Rm (ir[2:0])");
            nerr = 1'b1;
            failed = failed + 1;
        end

        assert (w_addr === ir[2:0]) begin
            $display("[PASS] w_addr is Rm (ir[2:0])");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] w_addr is Rm (ir[2:0])");
            nerr = 1'b1;
            failed = failed + 1;
        end

        reg_sel = 2'b01;
        #10;

        assert (r_addr === ir[7:5]) begin
            $display("[PASS] r_addr is Rd (ir[7:5])");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] r_addr is Rd (ir[7:5])");
            nerr = 1'b1;
            failed = failed + 1;
        end

        assert (w_addr === ir[7:5]) begin
            $display("[PASS] w_addr is Rd (ir[7:5])");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] w_addr is Rd (ir[7:5])");
            nerr = 1'b1;
            failed = failed + 1;
        end

        reg_sel = 2'b10;
        #10;
        
        assert (r_addr === ir[10:8]) begin
            $display("[PASS] r_addr is Rn (ir[10:8])");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] r_addr is Rn (ir[10:8])");
            nerr = 1'b1;
            failed = failed + 1;
        end

        assert (w_addr === ir[10:8]) begin
            $display("[PASS] w_addr is Rn (ir[10:8])");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] w_addr is Rn (ir[10:8])");
            nerr = 1'b1;
            failed = failed + 1;
        end

        assert (opcode === 3'b101) begin
            $display("[PASS] opcode is 101 (ir[15:13])");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] opcode is 101 (ir[15:13])");
            nerr = 1'b1;
            failed = failed + 1;
        end

        assert (ALU_op === 2'b01) begin
            $display("[PASS] alu_op is 01 (ir[12:11])");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] alu_op is 01 (ir[12:11])");
            nerr = 1'b1;
            failed = failed + 1;
        end

        assert (shift_op === 2'b11) begin
            $display("[PASS] shift_op is 11 (ir[4:3])");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] shift_op is 11 (ir[4:3])");
            nerr = 1'b1;
            failed = failed + 1;
        end

        // imm8 = 10011001
        // imm5 = 11001
        assert (sximm8 === 16'b1111111110011001) begin
            $display("[PASS] sximm8 is 1111111110011001");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] sximm8 is 1111111110011001");
            nerr = 1'b1;
            failed = failed + 1;
        end

        assert (sximm5 === 16'b1111111111111001) begin
            $display("[PASS] sximm5 is 1111111111111001");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] sximm5 is 1111111111111001");
            nerr = 1'b1;
            failed = failed + 1;
        end

        // imm8 = 01001001
        // imm5 = 01001
        ir = 16'b1010111001001001;
        #10;

        assert (sximm8 === 16'b0000000001001001) begin
            $display("[PASS] sximm8 is 0000000001001001");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] sximm8 is 0000000001001001");
            nerr = 1'b1;
            failed = failed + 1;
        end

        assert (sximm5 === 16'b0000000000001001) begin
            $display("[PASS] sximm5 is 0000000000001001");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] sximm5 is 0000000000001001");
            nerr = 1'b1;
            failed = failed + 1;
        end

        $display("err is %b", err);
        $display("Total number of tests failed is: %d", failed);
        $display("Total number of tests passed is: %d", passed);
        $stop;
    end
endmodule: tb_idecoder
