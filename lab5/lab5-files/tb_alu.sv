module tb_ALU(output err);
  reg [15:0] val_A;
  reg [15:0] val_B;
  reg [1:0] ALU_op;
  reg nerr;
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
    assert(ALU_out === 16'd2) $display("[PASS] correct output"); 
    else begin
      $error("[FAIL] incorrect output");
      nerr = 1;
    end
    assert(Z === 1'b0) $display("[PASS] Z = 0"); 
    else begin
      $error("[FAIL] incorrect Z");
      nerr = 1;
    end
    
    val_A = 16'd69; //A = 69
    val_B = 16'd69; //B = 69
    #5;
    assert(ALU_out === 16'd138) $display("[PASS] correct output"); 
    else begin
      $error("[FAIL] incorrect output");
      nerr = 1;
    end
    assert(Z === 1'b0) $display("[PASS] Z = 0"); 
    else begin
      $error("[FAIL] incorrect Z");
      nerr = 1;
    end

    val_A = 16'd6969; //A = 6969
    val_B = 16'd6969; //B = 6969
    #5;
    assert(ALU_out === 16'd13938) $display("[PASS] correct output"); 
    else begin
      $error("[FAIL] incorrect output");
      nerr = 1;
    end
    assert(Z === 1'b0) $display("[PASS] Z = 0"); 
    else begin
      $error("[FAIL] incorrect Z");
      nerr = 1;
    end

    val_A = 16'd29; //A = 29
    val_B = 16'd284; //B = 284
    #5;
    assert(ALU_out === 16'd313) $display("[PASS] correct output"); 
    else begin
      $error("[FAIL] incorrect output");
      nerr = 1;
    end
    assert(Z === 1'b0) $display("[PASS] Z = 0"); 
    else begin
      $error("[FAIL] incorrect Z");
      nerr = 1;
    end

    val_A = 16'd1; //A = -1
    val_B = 16'd1; //B = -1
    #5;
    assert(ALU_out === 16'b) $display("[PASS] correct output"); 
    else begin
      $error("[FAIL] incorrect output");
      nerr = 1;
    end
    assert(Z === 1'b0) $display("[PASS] Z = 0"); 
    else begin
      $error("[FAIL] incorrect Z");
      nerr = 1;
    end

    val_A = 16'd1; //A = 1
    val_B = 16'd1; //B = 1
    #5;
    assert(ALU_out === 16'd2) $display("[PASS] correct output"); 
    else begin
      $error("[FAIL] incorrect output");
      nerr = 1;
    end
    assert(Z === 1'b0) $display("[PASS] Z = 0"); 
    else begin
      $error("[FAIL] incorrect Z");
      nerr = 1;
    end

    val_A = 16'd1; //A = 1
    val_B = 16'd1; //B = 1
    #5;
    assert(ALU_out === 16'd2) $display("[PASS] correct output"); 
    else begin
      $error("[FAIL] incorrect output");
      nerr = 1;
    end
    assert(Z === 1'b0) $display("[PASS] Z = 0"); 
    else begin
      $error("[FAIL] incorrect Z");
      nerr = 1;
    end

    //testing subtraction

    $stop;
  end

endmodule: tb_ALU
