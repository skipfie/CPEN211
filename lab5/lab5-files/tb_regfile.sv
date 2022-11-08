module tb_regfile(output err);
    reg nerr = 1'b0;
    assign err = nerr;

    reg [15:0] w_data, r_data;
    reg [2:0] w_addr, r_addr;
    reg clk, w_en;

    regfile dut(.w_data(w_data), .w_addr(w_addr), .w_en(w_en), .r_addr(r_addr), .clk(clk), .r_data(r_data));

    initial begin
        clk <= 1'b1;
        forever #5 clk = ~clk;
    end

    initial begin
        w_en = 1'b0;

        w_data = 16'd6009;
        w_addr = 3'd0;
        r_addr = 3'd0;
        #10
        assert (r_data !== 16'd6009) $display("[PASS] 6009 not written to r0 when w_en is false");
        else begin
            $error("[FAIL] 6009 not written to r0 when w_en is false");
            nerr = 1'b1;
        end
        
        w_data = 16'd1010;
        w_addr = 3'd1;
        r_addr = 3'd1;
        #10
        assert (r_data !== 16'd1010) $display("[PASS] 1010 not written to r1 when w_en is false");
        else begin
            $error("[FAIL] 1010 not written to r1 when w_en is false");
            nerr = 1'b1;
        end

        w_data = 16'd2020;
        w_addr = 3'd2;
        r_addr = 3'd2;
        #10
        assert (r_data !== 16'd2020) $display("[PASS] 2020 not written to r2 when w_en is false");
        else begin
            $error("[FAIL] 2020 not written to r2 when w_en is false");
            nerr = 1'b1;
        end

        w_data = 16'd3030;
        w_addr = 3'd3;
        r_addr = 3'd3;
        #10
        assert (r_data !== 16'd3030) $display("[PASS] 3030 not written to r3 when w_en is false");
        else begin
            $error("[FAIL] 3030 not written to r3 when w_en is false");
            nerr = 1'b1;
        end

        w_data = 16'd4040;
        w_addr = 3'd4;
        r_addr = 3'd4;
        #10
        assert (r_data !== 16'd4040) $display("[PASS] 4040 not written to r4 when w_en is false");
        else begin
            $error("[FAIL] 4040 not written to r4 when w_en is false");
            nerr = 1'b1;
        end

        w_data = 16'd5050;
        w_addr = 3'd5;
        r_addr = 3'd5;
        #10
        assert (r_data !== 16'd5050) $display("[PASS] 5050 not written to r5 when w_en is false");
        else begin
            $error("[FAIL] 5050 not written to r5 when w_en is false");
            nerr = 1'b1;
        end

        w_data = 16'd6060;
        w_addr = 3'd6;
        r_addr = 3'd6;
        #10
        assert (r_data !== 16'd6060) $display("[PASS] 6060 not written to r6 when w_en is false");
        else begin
            $error("[FAIL] 6060 not written to r6 when w_en is false");
            nerr = 1'b1;
        end

        w_data = 16'd7070;
        w_addr = 3'd7;
        r_addr = 3'd7;
        #10
        assert (r_data !== 16'd7070) $display("[PASS] 7070 not written to r7 when w_en is false");
        else begin
            $error("[FAIL] 7070 not written to r7 when w_en is false");
            nerr = 1'b1;
        end

        w_en = 1'b1; // WRITE ENABLED



        w_data = 16'd0909;
        w_addr = 3'd0;
        r_addr = 3'd0;
        #10
        assert (r_data === 16'd0909) $display("[PASS] 0909 is written to r0 when w_en is true");
        else begin
            $error("[FAIL] 0909 is written to r0 when w_en is true");
            nerr = 1'b1;
        end
        
        w_data = 16'd1919;
        w_addr = 3'd1;
        r_addr = 3'd1;
        #10
        assert (r_data === 16'd1919) $display("[PASS] 1919 is written to r1 when w_en is true");
        else begin
            $error("[FAIL] 1919 is written to r1 when w_en is true");
            nerr = 1'b1;
        end

        w_data = 16'd2929;
        w_addr = 3'd2;
        r_addr = 3'd2;
        #10
        assert (r_data === 16'd2929) $display("[PASS] 2929 is written to r2 when w_en is true");
        else begin
            $error("[FAIL] 2929 is written to r2 when w_en is true");
            nerr = 1'b1;
        end

        w_data = 16'd3939;
        w_addr = 3'd3;
        r_addr = 3'd3;
        #10
        assert (r_data === 16'd3939) $display("[PASS] 3939 is written to r3 when w_en is true");
        else begin
            $error("[FAIL] 3939 is written to r3 when w_en is true");
            nerr = 1'b1;
        end

        w_data = 16'd4949;
        w_addr = 3'd4;
        r_addr = 3'd4;
        #10
        assert (r_data === 16'd4949) $display("[PASS] 4949 is written to r4 when w_en is true");
        else begin
            $error("[FAIL] 4949 is written to r4 when w_en is true");
            nerr = 1'b1;
        end

        w_data = 16'd5959;
        w_addr = 3'd5;
        r_addr = 3'd5;
        #10
        assert (r_data === 16'd5959) $display("[PASS] 5959 is written to r5 when w_en is true");
        else begin
            $error("[FAIL] 5959 is written to r5 when w_en is true");
            nerr = 1'b1;
        end

        w_data = 16'd6969;
        w_addr = 3'd6;
        r_addr = 3'd6;
        #10
        assert (r_data === 16'd6969) $display("[PASS] 6969 is written to r6 when w_en is true");
        else begin
            $error("[FAIL] 6969 is written to r6 when w_en is true");
            nerr = 1'b1;
        end

        w_data = 16'd7979;
        w_addr = 3'd7;
        r_addr = 3'd7;
        #10
        assert (r_data === 16'd7979) $display("[PASS] 7979 is written to r7 when w_en is true");
        else begin
            $error("[FAIL] 7979 is written to r7 when w_en is true");
            nerr = 1'b1;
        end

        $stop;
    end
endmodule: tb_regfile
