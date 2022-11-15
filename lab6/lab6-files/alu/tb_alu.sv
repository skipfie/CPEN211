`timescale 1 ps/ 1 ps
module tb_ALU(output err);
  reg nerr = 1'b0;
  assign err = nerr;
  reg [7:0] failed_count = 8'd0;
  reg [1:0] ALU_op;
  reg signed [15:0] val_A, val_B, ALU_out;
  wire Z, N, V;

  ALU dut(.val_A(val_A), .val_B(val_B), .ALU_op(ALU_op), .ALU_out(ALU_out), .Z(Z), .N(N), .V(V));

  initial begin
    $display("*testing non-overflow/underflow arithmetic*");
    $display("testing addition & output isn't 0");
    ALU_op = 2'b00;
    val_A = 16'd1; //A = 1
    val_B = 16'd1; //B = 1
    #5;
    assert(ALU_out === 16'd2) $display("[PASS] %d + %d > %d | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d + %d > %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b0 & N === 1'b0 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    
    val_A = 16'd69; //A = 69
    val_B = 16'd69; //B = 69
    #5;
    assert(ALU_out === 16'd138) $display("[PASS] %d + %d > %d | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d + %d > %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b0 & N === 1'b0 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = 16'd6969; //A = 6969
    val_B = 16'd6969; //B = 6969
    #5;
    assert(ALU_out === 16'd13938) $display("[PASS] %d + %d > %d | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d + %d > %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b0 & N === 1'b0 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = 16'd29; //A = 29
    val_B = 16'd284; //B = 284
    #5;
    assert(ALU_out === 16'd313) $display("[PASS] %d + %d > %d | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d + %d > %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b0 & N === 1'b0 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = -16'd1; //A = -1
    val_B = -16'd1; //B = -1
    #5;
    assert(ALU_out === -16'd2) $display("[PASS] %d + %d > %d | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d + %d > %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b0 & N === 1'b1 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = -16'd69; //A = -69
    val_B = -16'd69; //B = -69
    #5;
    assert(ALU_out === -16'd138) $display("[PASS] %d + %d > %d | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d + %d > %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b0 & N === 1'b1 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = -16'd4097; //A = -4097
    val_B = -16'd2847; //B = -2847
    #5;
    assert(ALU_out === -16'd6944) $display("[PASS] %d + %d > %d | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d + %d > %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b0 & N === 1'b1 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end


    $display("testing addition & output is 0");
    val_A = 16'd0; //A = 0
    val_B = 16'd0; //B = 0
    #5;
    assert(ALU_out === 16'd0) $display("[PASS] %d + %d > %d | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d + %d > %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b1 & N === 1'b0 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = -16'd259; //A = -259
    val_B = 16'd259; //B = 259
    #5;
    assert(ALU_out === 16'd0) $display("[PASS] %d + %d > %d | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d + %d > %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b1 & N === 1'b0 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = 16'd3749; //A = 3749
    val_B = -16'd3749; //B = -3749
    #5;
    assert(ALU_out === 16'd0) $display("[PASS] %d + %d > %d | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d + %d > %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b1 & N === 1'b0 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end


    $display("testing subtraction & output isn't 0");
    ALU_op = 2'b01;
    val_A = 16'd2; //A = 2
    val_B = 16'd1; //B = 1
    #5;
    assert(ALU_out === 16'd1) $display("[PASS] %d - %d > %d | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d - %d > %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b0 & N === 1'b0 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = 16'd70; //A = 70
    val_B = 16'd1; //B = 1
    #5;
    assert(ALU_out === 16'd69) $display("[PASS] %d - %d > %d | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d - %d > %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b0 & N === 1'b0 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = 16'd13812; //A = 13812
    val_B = 16'd6843; //B = 6843
    #5;
    assert(ALU_out === 16'd6969) $display("[PASS] %d - %d > %d | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d - %d > %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b0 & N === 1'b0 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = 16'd6808; //A = 6808
    val_B = 16'd5739; //B = 5739
    #5;
    assert(ALU_out === 16'd1069) $display("[PASS] %d - %d > %d | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d - %d > %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b0 & N === 1'b0 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = 16'd1; //A = 1
    val_B = 16'd2; //B = 2
    #5;
    assert(ALU_out === -16'd1) $display("[PASS] %d - %d > %d | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d - %d > %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b0 & N === 1'b1 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = 16'd1; //A = 1
    val_B = 16'd70; //B = 70
    #5;
    assert(ALU_out === -16'd69) $display("[PASS] %d - %d > %d | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d - %d > %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b0 & N === 1'b1 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = -16'd1; //A = -1
    val_B = 16'd7000; //B = 7000
    #5;
    assert(ALU_out === -16'd7001) $display("[PASS] %d - %d > %d | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d - %d > %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b0 & N === 1'b1 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    $display("testing subtraction & output is 0");
    val_A = 16'd0; //A = 0
    val_B = 16'd0; //B = 0
    #5;
    assert(ALU_out === 16'd0) $display("[PASS] %d - %d > %d | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d - %d > %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b1 & N === 1'b0 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    
    val_A = 16'd69; //A = 69
    val_B = 16'd69; //B = 69
    #5;
    assert(ALU_out === 16'd0) $display("[PASS] %d - %d > %d | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d - %d > %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b1 & N === 1'b0 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = 16'd4369; //A = 4369
    val_B = 16'd4369; //B = 4369
    #5;
    assert(ALU_out === 16'd0) $display("[PASS] %d - %d > %d | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d - %d > %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b1 & N === 1'b0 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = -16'd43; //A = -43
    val_B = -16'd43; //B = -43
    #5;
    assert(ALU_out === 16'd0) $display("[PASS] %d - %d > %d | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d - %d > %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b1 & N === 1'b0 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = -16'd1969; //A = 1969
    val_B = -16'd1969; //B = 1969
    #5;
    assert(ALU_out === 16'd0) $display("[PASS] %d - %d > %d | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %d - %d > %d", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b1 & N === 1'b0 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end


    $display("testing AND & output isn't 0"); 
    ALU_op = 2'b10;
    val_A = 16'b1111111111111111; 
    val_B = 16'b0000000000000001; 
    #5;
    assert(ALU_out === 16'b0000000000000001) $display("[PASS] %b & %b > %b | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %b & %b > %b", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b0 & N === 1'b0) $display("[PASS] Z, N are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b", Z, N);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = 16'b1111111111111111; 
    val_B = 16'b0100000000000001; 
    #5;
    assert(ALU_out === 16'b0100000000000001) $display("[PASS] %b & %b > %b | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %b & %b > %b", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b0 & N === 1'b0) $display("[PASS] Z, N are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b", Z, N);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = 16'b1111111111111111; 
    val_B = 16'b1110000000000001; 
    #5;
    assert(ALU_out === 16'b1110000000000001) $display("[PASS] %b & %b > %b | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %b & %b > %b", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b0 & N === 1'b1 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b", Z, N);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = 16'b1111110111111111; 
    val_B = 16'b0000111100000001; 
    #5;
    assert(ALU_out === 16'b0000110100000001) $display("[PASS] %b & %b > %b | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %b & %b > %b", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b0 & N === 1'b0) $display("[PASS] Z, N are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b", Z, N);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

  
    $display("testing AND & output is 0");
    val_A = 16'b0000000000000000; 
    val_B = 16'b0000000000000000; 
    #5;
    assert(ALU_out === 16'd0) $display("[PASS] %b & %b > %b | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %b & %b > %b", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b1 & N === 1'b0 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b", Z, N);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = 16'b1111111111111111; 
    val_B = 16'b0000000000000000; 
    #5;
    assert(ALU_out === 16'd0) $display("[PASS] %b & %b > %b | correct output", val_A, val_B, ALU_out); 
    else begin
      $error("[FAIL] %b & %b > %b", val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b1 & N === 1'b0 & V === 1'b0) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b", Z, N);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end


    $display("testing negation & output isn't 0");
    ALU_op = 2'b11;
    val_B = 16'b0000000000000001; 
    #5;
    assert(ALU_out === 16'b1111111111111110) $display("[PASS] ~%b > %b | correct output", val_B, ALU_out); 
    else begin
      $error("[FAIL] ~%b > %b", val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b0 & N === 1'b1) $display("[PASS] Z & N are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b", Z, N);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_B = 16'b0100000000000001; 
    #5;
    assert(ALU_out === 16'b1011111111111110) $display("[PASS] ~%b > %b | correct output", val_B, ALU_out); 
    else begin
      $error("[FAIL] ~%b > %b", val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b0 & N === 1'b1) $display("[PASS] Z & N are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b", Z, N);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_B = 16'b1111000000000001; 
    #5;
    assert(ALU_out === 16'b0000111111111110) $display("[PASS] ~%b > %b | correct output", val_B, ALU_out); 
    else begin
      $error("[FAIL] ~%b > %b", val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b0 & N === 1'b0) $display("[PASS] Z & N are correct"); 
    else begin  
      $error("[FAIL] Z = %b, N = %b", Z, N);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_B = 16'b0000000001100001; 
    #5;
    assert(ALU_out === 16'b1111111110011110) $display("[PASS] ~%b > %b | correct output", val_B, ALU_out); 
    else begin
      $error("[FAIL] ~%b > %b", val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b0 & N === 1'b1) $display("[PASS] Z, N are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b", Z, N);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_B = 16'b0001100001100001; 
    #5;
    assert(ALU_out === 16'b1110011110011110) $display("[PASS] ~%b > %b | correct output", val_B, ALU_out); 
    else begin
      $error("[FAIL] ~%b > %b", val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b0 & N === 1'b1) $display("[PASS] Z, N are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end


    $display("testing negation & output is 0");
    val_B = 16'b1111111111111111; 
    #5; 
    assert(ALU_out === 16'd0) $display("[PASS] ~%b > %b | correct output", val_B, ALU_out); 
    else begin
      $error("[FAIL] ~%b > %b", val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    assert(Z === 1'b1 & N === 1'b0) $display("[PASS] Z & N are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b", Z, N);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end
    

    $display("*testing overflow/underflow arithmetic*");
    ALU_op = 2'b00;
    $display("testing overflow");
    val_A = 16'd32000; //A = 32000
    val_B = 16'd5000; //B = 5000
    #15;
    assert(V === 1'b1) $display("[PASS] V are correct"); 
    else begin
      $error("[FAIL] V = %b, V, %d + %d = %d, ALU_out MSB = %b, val_A MSB = %b, val_B MSB = %b", V, val_A, val_B, ALU_out, ALU_out [15], val_A [15], val_B [15]);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = 16'd18000; //A = 18000
    val_B = 16'd18000; //B = 18000
    #5;
    assert(V === 1'b1) $display("[PASS] V are correct"); 
    else begin
      $error("[FAIL] V = %b, V, %d + %d = %d", V, val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = 16'd60; //A = 60
    val_B = 16'd32765; //B = 32765
    #5;
    assert(V === 1'b1) $display("[PASS] V are correct"); 
    else begin
      $error("[FAIL] V = %b, V, %d + %d = %d", V, val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = 16'd16969; //A = 16969
    val_B = 16'd16969; //B = 16969
    #5;
    assert(V === 1'b1) $display("[PASS] V are correct"); 
    else begin
      $error("[FAIL] V = %b, V, %d + %d = %d", V, val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end


    $display("testing underflow");
    val_A = -16'd16969; //A = -16969
    val_B = -16'd16969; //B = -16969
    #5;
    assert(V === 1'b1) $display("[PASS] V are correct"); 
    else begin
      $error("[FAIL] V = %b, V, %d + %d = %d", V, val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = -16'd60; //A = -60
    val_B = -16'd32765; //B = -32765
    #5;
    assert(V === 1'b1) $display("[PASS] V are correct"); 
    else begin
      $error("[FAIL] V = %b, V, %d + %d = %d", V, val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = -16'd32000; //A = -32000
    val_B = -16'd769; //B = -769
    #5;
    assert(V === 1'b1) $display("[PASS] V are correct"); 
    else begin
      $error("[FAIL] V = %b, V, %d + %d = %d", V, val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = -16'd32369; //A = -32369
    val_B = -16'd6969; //B = -6969
    #5;
    assert(V === 1'b1) $display("[PASS] V are correct"); 
    else begin
      $error("[FAIL] V = %b, V, %d + %d = %d", V, val_A, val_B, ALU_out);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    val_A = -16'd10; //A = -10
    val_B = 16'd32768; //B = 32768
    #5;
    assert(Z === 1'b0 & N === 1'b0 & V === 1'b1) $display("[PASS] Z, N & V are correct"); 
    else begin
      $error("[FAIL] Z = %b, N = %b, V = %b", Z, N, V);
      nerr = 1'b1;
      failed_count = failed_count + 1;
    end

    #5;
    $display("err is %b", err);
    $display("Total number of tests failed is: %d", failed_count);
    $stop;
  end
endmodule: tb_ALU