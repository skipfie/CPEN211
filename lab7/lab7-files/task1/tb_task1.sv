module tb_task1(output err);
    // tb vars
    reg nerr = 1'b0;
    assign err = nerr;

    integer failed = 0;
    integer passed = 0;

    // task1 i/o
    reg clk, rst_n;
    reg [7:0] start_pc;
    wire [15:0] out;

    task1 dut(.clk(clk), .rst_n(rst_n), .start_pc(start_pc), .out(out));

    task reset; rst_n = 1'b0; #30; rst_n = 1'b1; #10; endtask

    task check_output(integer expected_out, string msg);
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
    endtask

    initial begin
        clk <= 1'b1;
        forever #5 clk = ~clk;
    end

    initial begin
        start_pc = 2'h00; // run prg from from 00 to 1a
        #7;
        reset;

        // r0 = 69
        // r1 = -69

        // r7 = r0 = 69
        check_output(69, "r7=r0 (r0 = 69)");

        // r2 = r0*2 = 138
        check_output(138, "r2=r0<<1 (r0 = 69)");
        
        // r7 = 0
        check_output(0, "r7=r0+r1 (r0 = 69, r1 = -69)");

        // r0 = r0*2 = 138
        check_output(138, "r0=r0<<1 (r0 = 69)");

        // CMP(3'd0, 3'd2, 2'b00);
        check_output(138, "CMP 138 with 138 (output discarded)");

        // test waiting flag in middle of execution
        // ADD r0, r0, r2, LSL#1
        check_output(414, "ADD r0, r0, r2, LSL#1");

        //CMP(3'd2, 3'd0, 2'b00);
        check_output(414, "CMP 138 with 414 (output discarded)");

        //MOVimm(3'd6, 8'b0111_1111); // r6 = 127
        check_output(414, "MOVimm shouldn't update output (output discarded)");

        //ADD(3'd0, 3'd0, 3'd6, 2'b01);
        check_output(668, "414 + 127 * 2");

        //MOV(3'd6, 3'd0, 2'b01);
        check_output(1336, "r6 = 668 * 2");

        //MOV(3'd0, 3'd6, 2'b01);
        check_output(2672, "r0 = 1336 * 2");

        //MOV(3'd6, 3'd0, 2'b01);
        check_output(5344, "r6 = 2672 * 2");

        //MOV(3'd0, 3'd6, 2'b01);
        check_output(10688, "r0 = 5344 * 2");

        //MOV(3'd6, 3'd0, 2'b01);
        check_output(21376, "r6 = 10688 * 2");

        //MOV(3'd0, 3'd6, 2'b00);
        check_output(21376, "r0 = 21376");

        //MVN(3'd5, 3'd6, 2'b00);
        check_output(16'b1010110001111111, "r5=~r6");

        //MOVimm(3'd7, 8'd1);
        //ADD(3'd5, 3'd5, 3'd7, 2'b00);
        check_output(16'b1010110010000000, "perform two's compliment");

        // d6 = 29568
        // d5 = -29568

        //CMP(3'd6, 3'd5, 2'b00);

        //CMP(3'd5, 3'd6, 2'b00);

        //MOVimm(3'd3, 8'b01101111);
        //MOVimm(3'd4, 8'b10101010);
        //AND(3'd7, 3'd3, 3'd4, 2'b00);
        check_output(16'b0000000000101010, "r7=r3 & r4");

        //AND(3'd7, 3'd6, 3'd5, 2'b00);
        check_output(16'b0000000010000000, "r7=r6 & r5");

        $display("err is %b", err);
        $display("Total number of tests failed is: %d", failed);
        $display("Total number of tests passed is: %d", passed);
        $stop;
    end

endmodule: tb_task1
