module tb_datapath(output err);
    reg nerr = 1'b0;
    assign err = nerr;

    reg [7:0] failed = 8'd0;
    reg [7:0] passed = 8'd0;

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
        #20;
        datapath_in = -16'd6969;
        w_addr = 3'd1;
        #20;
        datapath_in = 16'd1024;
        w_addr = 3'd2;
        #20;
        datapath_in = -16'd1024;
        w_addr = 3'd3;
        #20;
        datapath_in = 16'd0;
        w_addr = 3'd4;
        #20;
        datapath_in = 16'd15;
        w_addr = 3'd5;
        #20;
        datapath_in = -16'd15;
        w_addr = 3'd6;
        #20;

        wb_sel = 1'b0;
        w_en = 1'b0; // prevent garbage data from being written

        // write 6969 to A and B
        r_addr = 3'd0;
        en_A = 1'b1;
        en_B = 1'b1;
        #20;

        en_A = 1'b0;
        en_B = 1'b0;

        r_addr = 3'd2; // this should not update A or B

        shift_op = 2'b00; // don't shift

        sel_A = 1'b0;
        sel_B = 1'b0;

        ALU_op = 2'b00; // ADD

        en_status = 1'b1;
        en_C = 1'b1;
        #20; //add more time for netlist to update
        
        assert (datapath_out === 16'd13938) begin
            $display("[PASS] r0 + r0 = 13938; r0 = 6969; en_C true");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] r0 + r0 = 13938; r0 = 6969; en_C true");
            nerr = 1'b1;
            failed = failed + 1;
        end

        assert (Z_out === 1'b0) begin
            $display("[PASS] Z_out is zero when alu output is 13938 and en_status is true");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] Z_out is zero when alu output is 13938 and en_status is true");
            nerr = 1'b1;
            failed = failed + 1;
        end

        wb_sel = 1'b0; //write output to r7
        w_addr = 3'd7;
        w_en = 1'b1;
        #20;

        w_en = 1'b0;

        ALU_op = 2'b01; // SUBTRACT

        en_status = 1'b0;
        en_C = 1'b0;
        #20;

        assert (datapath_out === 16'd13938) begin
            $display("[PASS] en_C false, retaining last output");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] en_C false, retaining last output");
            failed = failed + 1;
            nerr = 1'b1;
        end

        assert (Z_out === 1'b0) $display("[PASS] en_status false, retaining last output");
        else begin
            $error("[FAIL] en_status false, retaining last output");
            nerr = 1'b1;
            failed = failed + 1;
        end

        en_status = 1'b1;
        en_C = 1'b1;
        #20; //add more time for netlist to update

        assert (datapath_out === 16'd0) begin
            $display("[PASS] r0 - r0 = 0; r0 = 6969; en_C is true");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] r0 - r0 = 0; r0 = 6969; en_C is true");
            nerr = 1'b1;
            failed = failed + 1;
        end

        assert (Z_out === 1'b1) begin
            $display("[PASS] Z_out is one when alu output is 0 and en_status is true");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] Z_out is one when alu output is 0 and en_status is true");
            nerr = 1'b1;
            failed = failed + 1;
        end

        sel_A = 1'b1;
        sel_B = 1'b1;

        ALU_op = 2'b00;

        datapath_in[4:0] = 5'd31;

        en_C = 1'b1;
        #20;

        assert (datapath_out === 16'd31) begin
            $display("[PASS] datapath_out equals immediate value of 31, sel_A and sel_B working");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] datapath_out equals immediate value of 31, sel_A and sel_B working");
            nerr = 1'b1;
            failed = failed + 1;
        end

        r_addr = 3'd7; // write r7 into register B

        en_B = 1'b1; 
        sel_B = 1'b0;
        #30;

        assert (datapath_out === 16'd13938) begin
            $display("[PASS] datapath_out equals r7 value of 13938");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] datapath_out equals r7 value of 13938");
            nerr = 1'b1;
            failed = failed + 1;
        end

        shift_op = 2'b01;
        r_addr = 3'd6;
        #30;

        assert (datapath_out === -16'd30) begin
            $display("[PASS] datapath_out equals r6 * 2 = -30 (left shift one bit)");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] datapath_out equals r6 * 2 = -30 (left shift one bit)");
            nerr = 1'b1;
            failed = failed + 1;
        end

        sel_B = 1'b1;
        datapath_in[4:0] = 5'd10;
        #20;

        assert (datapath_out === 16'd10) begin
            $display("[PASS] datapath_out equals immediate value 10, should be unaffected by shifter");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] datapath_out equals immediate value 10, should be unaffected by shifter");
            nerr = 1'b1;
            failed = failed + 1;
        end

        sel_B = 1'b0;
        shift_op = 2'b11;
        #20;

        assert (datapath_out === -16'd8) begin
            $display("[PASS] datapath_out equals r6 >>> 1 = (-8)");
            passed = passed + 1;
        end
        else begin
            $error("[FAIL] datapath_out equals r6 >>> 1 = (-8)");
            nerr = 1'b1;
            failed = failed + 1;
        end

        #5;
        $display("err is %b", err);
        $display("Total number of tests failed is: %d", failed);
        $display("Total number of tests passed is: %d", passed);
        $stop;
    end

endmodule: tb_datapath
