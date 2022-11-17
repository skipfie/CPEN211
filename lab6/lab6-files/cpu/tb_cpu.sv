module tb_cpu(output err);
    // tb vars
    reg nerr = 1'b0;
    assign err = nerr;

    integer failed = 0;
    integer passed = 0;

    // cpu i/o
    reg clk, rst_n, load, start;
    reg [15:0] instr;

    wire waiting, N, V, Z;
    wire [15:0] out;

    cpu dut(.clk(clk), .rst_n(rst_n), .load(load), .start(start), .instr(instr),
            .waiting(waiting), .out(out), .N(N), .V(V), .Z(Z));

    task reset; rst_n = 1'b0; #30; rst_n = 1'b1; #10; endtask

    task check_flags(integer expected_N, integer expected_V, integer expected_Z, string msg);
        #6;
        assert (waiting === 1'b1) begin
            $display("[PASS] %s: is waiting for next instruction", msg);
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] %s: is not waiting for next instruction", msg);
            nerr = 1'b1;
            failed = failed + 1;
        end

        assert (N === expected_N) begin
            $display("[PASS] %s: N is %d (expected: %d)", msg, N, expected_N);
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] %s: N is %d (expected: %d)", msg, N, expected_N);
            nerr = 1'b1;
            failed = failed + 1;
        end

        assert (V === expected_V) begin
            $display("[PASS] %s: V is %d (expected: %d)", msg, V, expected_V);
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] %s: V is %d (expected: %d)", msg, V, expected_V);
            nerr = 1'b1;
            failed = failed + 1;
        end

        assert (Z === expected_Z) begin
            $display("[PASS] %s: Z is %d (expected: %d)", msg, Z, expected_Z);
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] %s: Z is %d (expected: %d)", msg, Z, expected_Z);
            nerr = 1'b1;
            failed = failed + 1;
        end
        #4;
    endtask

    task check_output(integer expected_out, string msg);
        #6;
        assert (waiting === 1'b1) begin
            $display("[PASS] %s: is waiting for next instruction", msg);
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] %s: is not waiting for next instruction", msg);
            nerr = 1'b1;
            failed = failed + 1;
        end
        
        assert (out === expected_out) begin
            $display("[PASS] %s: output is %d (expected: %d)", msg, out, expected_out);
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] %s: output is %d (expected: %d)", msg, out, expected_out);
            nerr = 1'b1;
            failed = failed + 1;
        end
        #4;
    endtask

    task MOVimm(input [2:0] Rn, input [7:0] im8);
        instr = {5'b110_10, Rn, im8};
        load = 1'b1;
        #10;
        load = 1'b0; // cycle 2
        start = 1'b1;
        #10;
        start = 1'b0; // cycle 3-5
        #30;
    endtask

    task MOV(input [2:0] Rd, input [2:0] Rm, input [1:0] sh_op);
        instr = {8'b110_00_000, Rd, sh_op, Rm};
        load = 1'b1;
        #10;
        load = 1'b0; // cycle 2
        start = 1'b1;
        #10;
        start = 1'b0; // cycle 3-5
        #30;
    endtask

    task ADD(input [2:0] Rd, input [2:0] Rn, input [2:0] Rm, input [1:0] sh_op);
        instr = {5'b101_00, Rn, Rd, sh_op, Rm}; // cycle 1
        load = 1'b1;
        #10;
        load = 1'b0; // cycle 2
        start = 1'b1;
        #10;
        start = 1'b0; // cycle 3-5
        #30;
    endtask

    task CMP(input [2:0] Rn, input [2:0] Rm, input [1:0] sh_op);
        instr = {5'b101_01, Rn, 3'b000, sh_op, Rm};
        load = 1'b1;
        #10;
        load = 1'b0;
        start = 1'b1;
        #10;
        start = 1'b0;
        #30;
    endtask

    task AND(input [2:0] Rd, input [2:0] Rn, input [2:0] Rm, input [1:0] sh_op);
        instr = {5'b101_10, Rn, Rd, sh_op, Rm};
        load = 1'b1;
        #10;
        load = 1'b0;
        start = 1'b1;
        #10;
        start = 1'b0;
        #30;
    endtask

    task MVN(input [2:0] Rd, input [2:0] Rm, input [1:0] sh_op);
        instr = {8'b101_11_000, Rd, sh_op, Rm};
        load = 1'b1;
        #10;
        load = 1'b0;
        start = 1'b1;
        #10;
        start = 1'b0;
        #30;
    endtask

    initial begin
        clk <= 1'b1;
        forever #5 clk = ~clk;
    end

    initial begin
        #7;
        reset;

        MOVimm(3'd0, 8'd69); // r0 = 69
        MOVimm(3'd1, -8'd69); // r1 = -69

        MOV(3'd7, 3'd0, 2'b00); // r7 = r0 = 69
        check_output(69, "r7=r0 (r0 = 69)");

        MOV(3'd2, 3'd0, 2'b01); // r2 = r0*2 = 138
        check_output(138, "r2=r0<<1 (r0 = 69)");
        
        ADD(3'd7, 3'd0, 3'd1, 2'b00); // r7 = 0
        check_output(0, "r7=r0+r1 (r0 = 69, r1 = -69)");

        MOV(3'd0, 3'd0, 2'b01); // r0 = r0*2 = 138
        check_output(138, "r0=r0<<1 (r0 = 69)");

        CMP(3'd0, 3'd2, 2'b00);
        check_output(138, "CMP 138 with 138 (output discarded)");
        check_flags(0, 0, 1, "CMP 138 with 138");

        // test waiting flag in middle of execution
        instr = {5'b101_00, 3'd0, 3'd0, 2'b01, 3'd2}; // ADD r0, r0, r2, LSL#1
        load = 1'b1;
        #10;
        load = 1'b0; // cycle 2
        start = 1'b1;
        #10;
        start = 1'b0; // cycle 3-5
        assert (waiting === 1'b0) begin
            $display("[PASS] ADD r0, r0, r2, LSL#1: is not waiting for next instruction in middle of exec");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] ADD r0, r0, r2, LSL#1: is waiting for next instruction in middle of exec");
            nerr = 1'b1;
            failed = failed + 1;
        end
        #30;
        check_output(414, "ADD r0, r0, r2, LSL#1");
        check_flags(0, 0, 1, "ADD r0, r0, r2, LSL#1 (status only for CMP so should retain previous status)");

        CMP(3'd2, 3'd0, 2'b00);
        check_output(414, "CMP 138 with 414 (output discarded)");
        check_flags(1, 0, 0, "CMP 138 with 414"); // NVZ

        MOVimm(3'd6, 8'b1111_1111); // r6 = 255
        check_output(414, "MOVimm shouldn't update output (output discarded)");

        ADD(3'd0, 3'd0, 3'd6, 2'b01);
        check_output(924, "414 + 255 * 2");

        MOV(3'd6, 3'd0, 2'b01);
        check_output(1848, "r6 = 924 * 2");

        MOV(3'd0, 3'd6, 2'b01);
        check_output(3696, "r0 = 1848 * 2");

        MOV(3'd6, 3'd0, 2'b01);
        check_output(7392, "r6 = 3696 * 2");

        MOV(3'd0, 3'd6, 2'b01);
        check_output(14784, "r0 = 7392 * 2");

        MOV(3'd6, 3'd0, 2'b01);
        check_output(29568, "r6 = 14784 * 2");

        MOV(3'd0, 3'd6, 2'b00);
        check_output(29568, "r0 = 29568");

        MVN(3'd5, 3'd6, 2'b00);
        check_output(16'b1000110001111111, "r5=~r6");

        MOVimm(3'd7, 8'd1);
        ADD(3'd5, 3'd5, 3'd7, 2'b00);
        check_output(-29568, "perform two's compliment");

        // d6 = 29568
        // d5 = -29568

        CMP(3'd6, 3'd5, 2'b00);
        check_flags(1, 1, 0, "overflow case, CMP 29568, -29568");

        CMP(3'd5, 3'd6, 2'b00);
        check_flags(0, 1, 0, "underflow case, CMP -29568, 29568");

        $display("err is %b", err);
        $display("Total number of tests failed is: %d", failed);
        $display("Total number of tests passed is: %d", passed);
        $stop;
    end

endmodule: tb_cpu
