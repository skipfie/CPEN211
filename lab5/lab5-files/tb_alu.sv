module tb_ALU(output err);
  reg [15:0] val_A;
  reg [15:0] val_B;
  reg [1:0] ALU_op;
  reg nerr = 1'b0;
  assign err = nerr;
  wire [15:0] ALU_out;
  wire Z;

  ALU dut(.val_A, .val_B, .ALU_op, .ALU_out, .Z);

  initial begin

    //testing addition & output isn't 0
    ALU_op = 2'b00;
    val_A = 16'd1; //A = 1
    val_B = 16'd1; //B = 1
    #5;
    assert(ALU_out === 16'd2) $display("[PASS] %d + %d = %d", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d + %d = %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
    end
    assert(Z === 1'b0) $display("[PASS] Z = 0"); 
    else begin
      $error("[FAIL] incorrect Z");
      nerr = 1'b1;
    end
    
    val_A = 16'd69; //A = 69
    val_B = 16'd69; //B = 69
    #5;
    assert(ALU_out === 16'd138) $display("[PASS] %d + %d = %d correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] incorrect output");
      nerr = 1'b1;
    end
    assert(Z === 1'b0) $display("[PASS] Z = 0"); 
    else begin
      $error("[FAIL] incorrect Z");
      nerr = 1'b1;
    end

    val_A = 16'd6969; //A = 6969
    val_B = 16'd6969; //B = 6969
    #5;
    assert(ALU_out === 16'd13938) $display("[PASS] %d + %d = %d correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] incorrect output");
      nerr = 1'b1;
    end
    assert(Z === 1'b0) $display("[PASS] Z = 0"); 
    else begin
      $error("[FAIL] incorrect Z");
      nerr = 1'b1;
    end

    val_A = 16'd29; //A = 29
    val_B = 16'd284; //B = 284
    #5;
    assert(ALU_out === 16'd313) $display("[PASS] %d + %d = %d correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] incorrect output");
      nerr = 1'b1;
    end
    assert(Z === 1'b0) $display("[PASS] Z = 0"); 
    else begin
      $error("[FAIL] incorrect Z");
      nerr = 1'b1;
    end

    val_A = 16'd1; //A = -1
    val_B = 16'd1; //B = -1
    #5;
    assert(ALU_out === 16'b1111111111111110) $display("[PASS] %d + %d = %d correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] incorrect output");
      nerr = 1'b1;
    end
    assert(Z === 1'b0) $display("[PASS] Z = 0"); 
    else begin
      $error("[FAIL] incorrect Z");
      nerr = 1'b1;
    end

    val_A = 16'd1; //A = -69
    val_B = 16'd1; //B = -69
    #5;
    assert(ALU_out === 16'b1111111101110110) $display("[PASS] %d + %d = %d correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] incorrect output");
      nerr = 1'b1;
    end
    assert(Z === 1'b0) $display("[PASS] Z = 0"); 
    else begin
      $error("[FAIL] incorrect Z");
      nerr = 1'b1;
    end

    val_A = 16'd1; //A = -6944
    val_B = 16'd1; //B = -2847
    #5;
    assert(ALU_out === 16'b1101100111000001) $display("[PASS] %d + %d = %d correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] incorrect output");
      nerr = 1'b1;
    end
    assert(Z === 1'b0) $display("[PASS] Z = 0"); 
    else begin
      $error("[FAIL] incorrect Z");
      nerr = 1'b1;
    end


    //testing addition & output is 0
    ALU_op = 2'b00;
    val_A = 16'd1; //A = 0
    val_B = 16'd0; //B = 0
    #5;
    assert(ALU_out === 16'd1) $display("[PASS] %d + %d = %d", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d + %d = %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
    end
    assert(Z === 1'b1) $display("[PASS] Z = 1"); 
    else begin
      $error("[FAIL] incorrect Z");
      nerr = 1'b1;
    end


    //testing subtraction & output isn't 0
    ALU_op = 2'b01;
    val_A = 16'd1; //A = 2
    val_B = 16'd2; //B = 1
    #5;
    assert(ALU_out === 16'd1) $display("[PASS] %d + %d = %d", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d + %d = %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
    end
    assert(Z === 1'b0) $display("[PASS] Z = 0"); 
    else begin
      $error("[FAIL] incorrect Z");
      nerr = 1'b1;
    end

    val_A = 16'd1; //A = 70
    val_B = 16'd2; //B = 1
    #5;
    assert(ALU_out === 16'd69) $display("[PASS] %d + %d = %d", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d + %d = %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
    end
    assert(Z === 1'b0) $display("[PASS] Z = 0"); 
    else begin
      $error("[FAIL] incorrect Z");
      nerr = 1'b1;
    end

    val_A = 16'd13812; //A = 13812
    val_B = 16'd6843; //B = 6843
    #5;
    assert(ALU_out === 16'd6969) $display("[PASS] %d + %d = %d", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d + %d = %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
    end
    assert(Z === 1'b0) $display("[PASS] Z = 0"); 
    else begin
      $error("[FAIL] incorrect Z");
      nerr = 1'b1;
    end

    val_A = 16'd1; //A = 2
    val_B = 16'd2; //B = 1
    #5;
    assert(ALU_out === 16'd1) $display("[PASS] %d + %d = %d", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d + %d = %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
    end
    assert(Z === 1'b0) $display("[PASS] Z = 0"); 
    else begin
      $error("[FAIL] incorrect Z");
      nerr = 1'b1;
    end

    val_A = 16'd1; //A = 1
    val_B = 16'd2; //B = 2
    #5;
    assert(ALU_out === 16'd1111111111111111) $display("[PASS] %d + %d = %d", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d + %d = %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
    end
    assert(Z === 1'b0) $display("[PASS] Z = 0"); 
    else begin
      $error("[FAIL] incorrect Z");
      nerr = 1'b1;
    end

    







    $stop;
  end

endmodule: tb_ALU
