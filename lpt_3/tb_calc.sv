module tb_calc();

logic clk;
logic rst_n;
logic [4:0] instr;
logic [7:0] display;

calc dut(.clk, .rst_n, .instr, .display);

initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial begin
    instr = 0;
    rst_n = 1'b0;
    #3;
    #10;
    rst_n = 1'b1;
    #20;

    instr = 5'b10001;
    #10;

    instr = 5'b00010;
    #10;

    instr = 5'b10010;
    #10;

    instr = 5'b00001;
    #10;
    
    assert (display === 8'd3) $display("[PASS] 1+2= display is 3");
    else $display("[FAIL] 1+2= display not 3");
    assert (dut.datapath.x === 8'd3) $display("[PASS] 1+2= x is 3");
    else $display("[FAIL] 1+2= x not 3");
    assert (dut.datapath.y === 8'd2) $display("[PASS] 1+2= y is 2");
    else $display("[FAIL] 1+2= y not 2");

    $stop;
end

endmodule: tb_calc
