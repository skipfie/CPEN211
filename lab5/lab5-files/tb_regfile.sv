module tb_regfile(output err);
    reg n_err;
    assign err = n_err;

    reg [15:0] w_data;
    reg [2:0] w_addr, r_addr;
    reg clk, w_en;

    wire [15:0] r_data;

    regfile dut(.w_data(w_data), .w_addr(w_addr), .w_en(w_en), .r_addr(r_addr), .clk(clk), .r_data(r_data));

    initial begin
        clk <= 1'b1;
        forever #5 clk = ~clk;
    end

    initial begin
        n_err = 1'b0;

        w_en = 1'b0;

        w_data = 16'd6969;
        w_addr = 3'd0;
        r_addr = 3'd0;
        #10
        assert (r_data !== 16'd6969) $display("[PASS] 6969 not written to r0 when w_en is false");
        else begin
            $error("[FAIL] 6969 not written to r0 when w_en is false");
            n_err = 1'b1;
        end
        
        w_data = 16'd6969;
        w_addr = 3'd1;
        r_addr = 3'd1;
        #10
        assert (r_data !== 16'd6969) $display("[PASS] 6969 not written to r1 when w_en is false");
        else begin
            $error("[FAIL] 6969 not written to r1 when w_en is false");
            n_err = 1'b1;
        end

        w_data = 16'd6969;
        w_addr = 3'd2;
        r_addr = 3'd2;
        #10
        assert (r_data !== 16'd6969) $display("[PASS] 6969 not written to r2 when w_en is false");
        else begin
            $error("[FAIL] 6969 not written to r2 when w_en is false");
            n_err = 1'b1;
        end

        w_data = 16'd6969;
        w_addr = 3'd3;
        r_addr = 3'd3;
        #10
        assert (r_data !== 16'd6969) $display("[PASS] 6969 not written to r3 when w_en is false");
        else begin
            $error("[FAIL] 6969 not written to r3 when w_en is false");
            n_err = 1'b1;
        end

        w_data = 16'd6969;
        w_addr = 3'd4;
        r_addr = 3'd4;
        #10
        assert (r_data !== 16'd6969) $display("[PASS] 6969 not written to r4 when w_en is false");
        else begin
            $error("[FAIL] 6969 not written to r4 when w_en is false");
            n_err = 1'b1;
        end

        w_data = 16'd6969;
        w_addr = 3'd5;
        r_addr = 3'd5;
        #10
        assert (r_data !== 16'd6969) $display("[PASS] 6969 not written to r5 when w_en is false");
        else begin
            $error("[FAIL] 6969 not written to r5 when w_en is false");
            n_err = 1'b1;
        end

        w_data = 16'd6969;
        w_addr = 3'd6;
        r_addr = 3'd6;
        #10
        assert (r_data !== 16'd6969) $display("[PASS] 6969 not written to r6 when w_en is false");
        else begin
            $error("[FAIL] 6969 not written to r6 when w_en is false");
            n_err = 1'b1;
        end

        w_data = 16'd6969;
        w_addr = 3'd7;
        r_addr = 3'd7;
        #10
        assert (r_data !== 16'd6969) $display("[PASS] 6969 not written to r7 when w_en is false");
        else begin
            $error("[FAIL] 6969 not written to r7 when w_en is false");
            n_err = 1'b1;
        end

        w_en = 1'b0; // WRITE ENABLED



        w_data = 16'd6969;
        w_addr = 3'd0;
        r_addr = 3'd0;
        #10
        assert (r_data === 16'd6969) $display("[PASS] 6969 is written to r0 when w_en is true");
        else begin
            $error("[FAIL] 6969 is written to r0 when w_en is true");
            n_err = 1'b1;
        end
        
        w_data = 16'd6969;
        w_addr = 3'd1;
        r_addr = 3'd1;
        #10
        assert (r_data === 16'd6969) $display("[PASS] 6969 is written to r1 when w_en is true");
        else begin
            $error("[FAIL] 6969 is written to r1 when w_en is true");
            n_err = 1'b1;
        end

        w_data = 16'd6969;
        w_addr = 3'd2;
        r_addr = 3'd2;
        #10
        assert (r_data === 16'd6969) $display("[PASS] 6969 is written to r2 when w_en is true");
        else begin
            $error("[FAIL] 6969 is written to r2 when w_en is true");
            n_err = 1'b1;
        end

        w_data = 16'd6969;
        w_addr = 3'd3;
        r_addr = 3'd3;
        #10
        assert (r_data === 16'd6969) $display("[PASS] 6969 is written to r3 when w_en is true");
        else begin
            $error("[FAIL] 6969 is written to r3 when w_en is true");
            n_err = 1'b1;
        end

        w_data = 16'd6969;
        w_addr = 3'd4;
        r_addr = 3'd4;
        #10
        assert (r_data === 16'd6969) $display("[PASS] 6969 is written to r4 when w_en is true");
        else begin
            $error("[FAIL] 6969 is written to r4 when w_en is true");
            n_err = 1'b1;
        end

        w_data = 16'd6969;
        w_addr = 3'd5;
        r_addr = 3'd5;
        #10
        assert (r_data === 16'd6969) $display("[PASS] 6969 is written to r5 when w_en is true");
        else begin
            $error("[FAIL] 6969 is written to r5 when w_en is true");
            n_err = 1'b1;
        end

        w_data = 16'd6969;
        w_addr = 3'd6;
        r_addr = 3'd6;
        #10
        assert (r_data === 16'd6969) $display("[PASS] 6969 is written to r6 when w_en is true");
        else begin
            $error("[FAIL] 6969 is written to r6 when w_en is true");
            n_err = 1'b1;
        end

        w_data = 16'd6969;
        w_addr = 3'd7;
        r_addr = 3'd7;
        #10
        assert (r_data === 16'd6969) $display("[PASS] 6969 is written to r7 when w_en is true");
        else begin
            $error("[FAIL] 6969 is written to r7 when w_en is true");
            n_err = 1'b1;
        end
    end

endmodule: tb_regfile
