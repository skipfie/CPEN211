module tb_datapath(output err);
    reg nerr = 1'b0;
    assign err = nerr;

    reg clk, wb_sel, w_en, en_A, en_B, sel_A, sel_B, en_C, en_status;
    reg [1:0] shift_op, ALU_op;
    reg [2:0] w_addr, r_addr;
    reg [15:0] datapath_in;

    wire Z_out;
    wire [15:0] datapath_out;

    datapath dut(.clk(clk), .datapath_in(datapath_in), .wb_sel(wb_sel), 
                 .w_addr(w_addr), .w_en(w_en), .r_addr(r_addr), .en_A(en_A),
                 .en_B(en_B), .shift_op(shift_op), .sel_A(sel_A), .sel_B(sel_B),
                 .ALU_op(ALU_op), .en_C(en_C), .en_status(en_status),
                 .datapath_out(datapath_out), .Z_out(Z_out));

    initial begin
        clk <= 1'b1;
        forever #5 clk = ~clk;
    end

    initial begin
        // fill regfile with numbers
        // r0 = 6969, r1 = -6969, r2 = 1024, r3 = -1024, 
        // r4 = 0, r5 = 15, r6 = -15, r7 = X
        wb_sel = 1'b1;
        w_en = 1'b1;

        datapath_in = 16'd6969; 
        w_addr = 3'd0;
        #10;
        datapath_in = -16'd6969;
        w_addr = 3'd1;
        #10;
        datapath_in = 16'd1024;
        w_addr = 3'd2;
        #10;
        datapath_in = -16'd1024;
        w_addr = 3'd3;
        #10;
        datapath_in = 16'd0;
        w_addr = 3'd4;
        #10;
        datapath_in = 16'd15;
        w_addr = 3'd5;
        #10;
        datapath_in = -16'd15;
        w_addr = 3'd6;
        #10;

        wb_sel = 1'b0;
        w_en = 1'b0; // prevent garbage data from being written

        // write 6969 to A and B
        r_addr = 3'd0;
        en_A = 1'b1;
        en_B = 1'b1;
        #10;

        en_A = 1'b0;
        en_B = 1'b0;

        shift_op = 2'b00; // don't shift

        sel_A = 1'b0;
        sel_B = 1'b0;

        ALU_op = 2'b00; // ADD

        en_status = 1'b1;
        en_C = 1'b1;
        #10;
        
        assert (datapath_out === 16'd13938) $display("[PASS] r0 + r0 = 13938; r0 = 6969; en_C true");
        else begin
            $error("[FAIL] r0 + r0 = 13938; r0 = 6969; en_C true");
            nerr = 1'b1;
        end

        assert (Z_out === 1'b0) $display("[PASS] Z_out is zero when alu output is 13938 and en_status is true");
        else begin
            $error("[FAIL] Z_out is zero when alu output is 13938 and en_status is true");
            nerr = 1'b1;
        end

        wb_sel = 1'b0; //write 13938 to r7
        w_addr = 3'd7;
        w_en = 1'b1;
        #10;

        w_en = 1'b0;

        ALU_op = 2'b01; // SUBTRACT

        en_status = 1'b0;
        en_C = 1'b0;
        #10;

        assert (datapath_out === 16'd13938) $display("[PASS] en_C false, retaining last output");
        else begin
            $error("[FAIL] en_C false, retaining last output");
            nerr = 1'b1;
        end

        assert (Z_out === 1'b0) $display("[PASS] en_status false, retaining last output");
        else begin
            $error("[FAIL] en_status false, retaining last output");
            nerr = 1'b1;
        end

        en_status = 1'b1;
        en_C = 1'b1;
        #10;

        assert (datapath_out === 16'd0) $display("[PASS] r0 - r0 = 0; r0 = 6969; en_C is true")
        else begin
            $error("[FAIL] r0 - r0 = 0; r0 = 6969; en_C is true");
            nerr = 1'b1;
        end

        assert (Z_out === 1'b1) $display("[PASS] Z_out is one when alu output is 0 and en_status is true");
        else begin
            $error("[FAIL] Z_out is one when alu output is 0 and en_status is true");
            nerr = 1'b1;
        end

        sel_A = 1'b1;
        sel_B = 1'b1;

        ALU_op 2'b00;

        datapath_in[4:0] = 5'd31;

        en_C = 1'b1;
        #10;

        assert (datapath_out === 16'd31) $display("[PASS] datapath_out equals immediate value of 31, sel_A and sel_B working")
        else begin
            $error("[FAIL] datapath_out equals immediate value of 31, sel_A and sel_B working");
            nerr = 1'b1;
        end

        r_addr = 3'd7; // write r7 into register B

        en_B = 1'b1;
        sel_B = 1'b0;

        

        $stop;
    end

endmodule: tb_datapath
