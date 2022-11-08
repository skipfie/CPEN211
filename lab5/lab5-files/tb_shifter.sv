module tb_shifter(output err);
    reg nerr;
    assign err = nerr;

    reg [15:0] shift_in;
    reg [1:0] shift_op;

    wire [15:0] shift_out;

    shifter dut(.shift_in(shift_in), .shift_op(shift_op), .shift_out(shift_out));

    initial begin
        shift_in = 16'b1010010001010101;
        shift_op = 2'b00;
        #10;
        assert (shift_out === 16'b1010010001010101) $display("[PASS] B unchanged operation 00");
        else begin
            $error("[FAIL] B unchanged operation 00");
            nerr = 1'b1;
        end
        

        shift_in = 16'b1010010001010101;
        shift_op = 2'b01;
        #10;
        assert (shift_out === 16'b0100100010101010) $display("[PASS] B left shift one bit operation 01");
        else begin
            $error("[FAIL] B left shift one bit operation 01");
            nerr = 1'b1;
        end
        

        shift_in = 16'b1010010001010101;
        shift_op = 2'b10;
        #10;
        assert (shift_out === 16'b0101001000101010) $display("[PASS] B logical right shift one bit where MSB was 1, operation 10");
        else begin
            $error("[FAIL] B logical right shift one bit where MSB was 1, operation 10");
            nerr = 1'b1;
        end
        

        shift_in = 16'b0010010001010101;
        shift_op = 2'b10;
        #10;
        assert (shift_out === 16'b0001001000101010) $display("[PASS] B logical right shift one bit where MSB was 0, operation 10");
        else begin
            $error("[FAIL] B logical right shift one bit where MSB was 0, operation 10");
            nerr = 1'b1;
        end
        

        shift_in = 16'b1010010001010101;
        shift_op = 2'b11;
        #10;
        assert (shift_out === 16'b1101001000101010) $display("[PASS] B arithmetic right shift one bit where MSB was 1, operation 11");
        else begin
            $error("[FAIL] B arithmetic right shift one bit where MSB was 1, operation 11");
            nerr = 1'b1;
        end
        

        shift_in = 16'b0010010001010101;
        shift_op = 2'b11;
        #10;
        assert (shift_out === 16'b0001001000101010) $display("[PASS] B arithmetic right shift one bit where MSB was 0, operation 11");
        else begin
            $error("[FAIL] B arithmetic right shift one bit where MSB was 0, operation 11");
            nerr = 1'b1;
        end

        $stop;
    end
endmodule: tb_shifter
