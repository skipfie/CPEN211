`timescale 1 ps/ 1 ps
module tb_task3(output err);
    // tb vars
    reg nerr = 1'b0;
    assign err = nerr;

    integer failed = 0;
    integer passed = 0;

    // task1 i/o
    reg clk, rst_n;
    reg [7:0] start_pc;
    wire [15:0] out;

    task3 dut(.clk(clk), .rst_n(rst_n), .start_pc(start_pc), .out(out));

    task reset; rst_n = 1'b0; #10; rst_n = 1'b1; #10; endtask

    task check_output(integer expected_out, string msg);
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
        start_pc = 'h1b; // run prg from from 00 to 1a
        #7; 
        reset;
        #200; // more than enough time to complete execution
        check_output(69, "mov r3, r0");

        #200;
        check_output(69, "nothing changes in HALT");

        start_pc = 'h1f;
        reset;
        #200;
        check_output(50, "add r3, r0, r1, LSL#1 (72+(-11*2)");

        start_pc = 'h23;
        #200;
        check_output(50, "start pc changed does not change execution");
        reset;
        #200;
        check_output(16'b0000_0000_0001_0000, "and r3, r0, r1 (50 & 20)");

        start_pc = 'h27;
        reset;
        #150;
        check_output(16'b1111_1111_1001_0000, "mvn r1, r0 (~0000 0000 0110 1111)");

        //ldr instr
        start_pc = 'h2a;
        reset;
        #250;
        check_output(255, "ldr r1, [r0, #1] (254+1) being tested");

        start_pc = 'h2e;
        reset;
        #300;
        check_output(6969, "ldr r1, [r0, #1] (testing data inside)");

        //insert tests for str
        start_pc = 'h33;
        reset;
        #250;
        check_output(69, "str r1, [r0, #1] (254+1) (write tested)");

        start_pc = 'h38;
        reset;
        #400;
        check_output(69, "str r1, [r0, #1] (checking data inside is written)");

        start_pc = 'h3f;
        reset;
        #450;
        check_output(13, "check if prog counter is fucked up")

        #10;

        $display("err is %b", err);
        $display("Total number of tests failed is: %d", failed);
        $display("Total number of tests passed is: %d", passed);
        $stop;
    end
endmodule: tb_task3
