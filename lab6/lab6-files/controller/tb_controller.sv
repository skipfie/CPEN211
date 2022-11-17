module tb_controller(output err);
    reg nerr = 1'b0;
    assign err = nerr;
    integer failed = 0;
    integer passed = 0;

    //input
    reg clk, rst_n, start, Z, V, N;
    reg [1:0] ALU_op, shift_op;
    reg [2:0] opcode;

    //controller output
    wire waiting, en_A, en_B, en_C, en_status, sel_A, sel_B, w_en;
    wire [1:0] reg_sel, wb_sel; 

    controller dut(.clk(clk), .rst_n(rst_n), .start(start),
                   .opcode(opcode), .ALU_op(ALU_op), .shift_op(shift_op), 
                   .Z(Z), .N(N), .V(V),
                   .waiting(waiting),
                   .reg_sel(reg_sel), .wb_sel(wb_sel), .w_en(w_en),
                   .en_A(en_A), .en_B(en_B), .en_C(en_C), .en_status(en_status),
                   .sel_A(sel_A), .sel_B(sel_B));

    task reset; rst_n = 1'b0; #30; rst_n = 1'b1; #10; endtask
    task start; start = 1'b1; #10; start = 1'b0; endtask
    task MOVimm; opcode = 3'b110, ALU_op = 2'b10; start = 1'b1; #10; start = 1'b0; endtask
    task MOV; opcode = 3'b110; ALU_op = 2'b00; start = 1'b1; #10; start = 1'b0; endtask


    initial begin
        #7;


        $display("err is %b", err);
        $display("Total number of tests failed is: %d", failed);
        $display("Total number of tests passed is: %d", passed);
        $stop;
    end

endmodule: tb_controller
