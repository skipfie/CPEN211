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
        start_pc = 'h00; // run prg from from 00 to 1a
        #7; 
        reset;
        #10000;
        $stop;
    end
endmodule: tb_task3
