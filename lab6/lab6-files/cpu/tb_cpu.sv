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

    task reset; rst_n = 1'b0; #20; rst_n = 1'b1; #10; endtask

    task ADD();

    endtask

    initial begin
        clk <= 1'b1;
        forever #5 clk = ~clk;
    end

    initial begin

    end

    initial begin
        reset;


        $stop;
    end

endmodule: tb_cpu
