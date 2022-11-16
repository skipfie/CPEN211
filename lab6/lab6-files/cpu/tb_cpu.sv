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
    wire [15:0] out

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
        instr = {8'b110_00_000, Rd, sh, Rm};
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
        load - 1'b0;
        start = 1'b1;
        #10;
        start = 1'b0;
        #30;
    endtask

    task AND(input [2:0] Rd, input [2:0] Rn, input [2:0] Rm, input [1:0] sh_op);
        instr = {5'b101_10, Rn, Rd, sh_op, Rm};
        load = 1'b1;
        #10;
        load - 1'b0;
        start = 1'b1;
        #10;
        start = 1'b0;
        #30;
    endtask

    task MVN(input [2:0] Rd, input [2:0] Rm, input [1:0] sh_op);
        instr = {8'b101_11_000, Rd, sh, Rm};
        load = 1'b1;
        #10;
        load - 1'b0;
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

        MOV(3'd2, 3'd0, 2'b00); // r2 = r0 = 69
        check_output(69, "r2=r0 (r0 = 69)");

        MOV(3'd2, 3'd0, 2'b01); // r2 = r0*2 = 138
        check_output(138, "r2=r0<<1 (r0 = 69)");
        
        

        $stop;
    end

endmodule: tb_cpu
