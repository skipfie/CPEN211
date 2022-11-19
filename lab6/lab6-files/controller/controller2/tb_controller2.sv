`timescale 1 ps/ 1 ps
module tb_controller2(output err);
    reg [1:0] test_port1;
    reg [4:0] test_port2;

    reg nerr = 1'b0;
    assign err = nerr;
    integer failed = 0;

    //input
    reg clk, rst_n, start, Z, V, N;
    reg [1:0] ALU_op, shift_op;
    reg [2:0] opcode;

    //output
    wire waiting, en_A, en_B, en_C, en_status, sel_A, sel_B, w_en;
    wire [1:0] reg_sel, wb_sel; 

    controller2 dut(.clk(clk), .rst_n(rst_n), .start(start),
                   .opcode(opcode), .ALU_op(ALU_op), .shift_op(shift_op), 
                   .Z(Z), .N(N), .V(V),
                   .waiting(waiting),
                   .reg_sel(reg_sel), .wb_sel(wb_sel), .w_en(w_en),
                   .en_A(en_A), .en_B(en_B), .en_C(en_C), .en_status(en_status),
                   .sel_A(sel_A), .sel_B(sel_B), .test_port1(test_port1), .test_port2(test_port2));
    initial begin
        clk <= 1'b1;
        forever #5 clk = ~clk;
    end                   

    task reset; rst_n = 1'b0; #30; rst_n = 1'b1; #10; endtask
    task MOVimm; opcode = 3'b110; ALU_op = 2'b10; start = 1'b1; #10; start = 1'b0; endtask
    task MOV; opcode = 3'b110; ALU_op = 2'b00; start = 1'b1; #10; start = 1'b0; endtask
    
    task add; opcode = 3'b101; ALU_op = 2'b00; start = 1'b1; #10; start = 1'b0; endtask
    task cmp; opcode = 3'b101; ALU_op = 2'b01; start = 1'b1; #10; start = 1'b0; endtask
    task And; opcode = 3'b101; ALU_op = 2'b10; start = 1'b1; #10; start = 1'b0; endtask
    task mvn; opcode = 3'b101; ALU_op = 2'b11; start = 1'b1; #10; start = 1'b0; endtask
    
    initial begin
        #70;
        $display("Testing reset");
        reset;
        assert (waiting === 1'b1) $display("[PASS] The ctl is waiting");
        else begin
          $error("[FAIL] The ctl is waiting but waiting is not 1");
          nerr = 1'b1;
          failed = failed + 1;
        end

        $display("Testing add");
        add; //c1
        assert (waiting === 1'b0 && en_A === 1'b1 && en_B === 1'b0 && en_C === 1'b0 && en_status === 1'b0 && 
                sel_A === 1'b0 && sel_B === 1'b0 && w_en === 1'b0 && reg_sel === 2'b10 && wb_sel === 2'b00) 
          $display("[PASS] All the control signals are correct");
        else begin $error("[FAIL] waiting = %b, en_A = %b, en_B = %b, en_C = %b, en_status = %b, 
                           sel_A = %b, sel_B = %b, w_en = %b, reg_sel = %b, wb_sel = %b", waiting, en_A
                           , en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel, wb_sel);
          nerr = 1'b1;
          failed = failed + 1;
        end
        #10; //c2
        assert (waiting === 1'b0 && en_A === 1'b0 && en_B === 1'b1 && en_C === 1'b0 && en_status === 1'b0 && 
                sel_A === 1'b0 && sel_B === 1'b0 && w_en === 1'b0 && reg_sel === 2'b0 && wb_sel === 2'b00) 
          $display("[PASS] All the control signals are correct");
        else begin $error("[FAIL] waiting = %b, en_A = %b, en_B = %b, en_C = %b, en_status = %b, 
                           sel_A = %b, sel_B = %b, w_en = %b, reg_sel = %b, wb_sel = %b", waiting, en_A
                           , en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel, wb_sel);
          nerr = 1'b1;
          failed = failed + 1;
        end
        #10; //c3
        assert (waiting === 1'b0 && en_A === 1'b0 && en_B === 1'b0 && en_C === 1'b1 && en_status === 1'b0 && 
                sel_A === 1'b0 && sel_B === 1'b0 && w_en === 1'b0 && reg_sel === 2'b00 && wb_sel === 2'b00) 
          $display("[PASS] All the control signals are correct");
        else begin $error("[FAIL] waiting = %b, en_A = %b, en_B = %b, en_C = %b, en_status = %b, 
                           sel_A = %b, sel_B = %b, w_en = %b, reg_sel = %b, wb_sel = %b", waiting, en_A
                           , en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel, wb_sel);
          nerr = 1'b1;
          failed = failed + 1;
        end
        #10; //c4
        assert (waiting === 1'b0 && en_A === 1'b0 && en_B === 1'b0 && en_C === 1'b0 && en_status === 1'b0 && 
                sel_A === 1'b0 && sel_B === 1'b0 && w_en === 1'b1 && reg_sel === 2'b01 && wb_sel === 2'b00) 
          $display("[PASS] All the control signals are correct");
        else begin $error("[FAIL] waiting = %b, en_A = %b, en_B = %b, en_C = %b, en_status = %b, 
                           sel_A = %b, sel_B = %b, w_en = %b, reg_sel = %b, wb_sel = %b", waiting, en_A
                           , en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel, wb_sel);
          nerr = 1'b1;
          failed = failed + 1;
        end

        #10;
        $display("Testing cmp");
        cmp; //c1
        assert (waiting === 1'b0 && en_A === 1'b1 && en_B === 1'b0 && en_C === 1'b0 && en_status === 1'b0 && 
                sel_A === 1'b0 && sel_B === 1'b0 && w_en === 1'b0 && reg_sel === 2'b10 && wb_sel === 2'b00) 
          $display("[PASS] All the control signals are correct");
        else begin $error("[FAIL] waiting = %b, en_A = %b, en_B = %b, en_C = %b, en_status = %b, 
                           sel_A = %b, sel_B = %b, w_en = %b, reg_sel = %b, wb_sel = %b", waiting, en_A
                           , en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel, wb_sel);
          nerr = 1'b1;
          failed = failed + 1;
        end
        #10; //c2
        assert (waiting === 1'b0 && en_A === 1'b0 && en_B === 1'b1 && en_C === 1'b0 && en_status === 1'b0 && 
                sel_A === 1'b0 && sel_B === 1'b0 && w_en === 1'b0 && reg_sel === 2'b00 && wb_sel === 2'b00) 
          $display("[PASS] All the control signals are correct");
        else begin $error("[FAIL] waiting = %b, en_A = %b, en_B = %b, en_C = %b, en_status = %b, 
                           sel_A = %b, sel_B = %b, w_en = %b, reg_sel = %b, wb_sel = %b", waiting, en_A
                           , en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel, wb_sel);
          nerr = 1'b1;
          failed = failed + 1;
        end
        #10; //c3
        assert (waiting === 1'b0 && en_A === 1'b0 && en_B === 1'b0 && en_C === 1'b0 && en_status === 1'b0 && 
                sel_A === 1'b0 && sel_B === 1'b0 && w_en === 1'b0 && reg_sel === 2'b00 && wb_sel === 2'b00) 
          $display("[PASS] All the control signals are correct");
        else begin $error("[FAIL] waiting = %b, en_A = %b, en_B = %b, en_C = %b, en_status = %b, 
                           sel_A = %b, sel_B = %b, w_en = %b, reg_sel = %b, wb_sel = %b", waiting, en_A
                           , en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel, wb_sel);
          nerr = 1'b1;
          failed = failed + 1;
        end
        #10; //c4
        assert (waiting === 1'b0 && en_A === 1'b0 && en_B === 1'b0 && en_C === 1'b0 && en_status === 1'b1 && 
                sel_A === 1'b0 && sel_B === 1'b0 && w_en === 1'b0 && reg_sel === 2'b00 && wb_sel === 2'b00) 
          $display("[PASS] All the control signals are correct");
        else begin $error("[FAIL] waiting = %b, en_A = %b, en_B = %b, en_C = %b, en_status = %b, 
                           sel_A = %b, sel_B = %b, w_en = %b, reg_sel = %b, wb_sel = %b", waiting, en_A
                           , en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel, wb_sel);
          nerr = 1'b1;
          failed = failed + 1;
        end

        #10;
        $display("Testing And");
        And; //c1
        assert (waiting === 1'b0 && en_A === 1'b1 && en_B === 1'b0 && en_C === 1'b0 && en_status === 1'b0 && 
                sel_A === 1'b0 && sel_B === 1'b0 && w_en === 1'b0 && reg_sel === 2'b10 && wb_sel === 2'b00) 
          $display("[PASS] All the control signals are correct");
        else begin $error("[FAIL] waiting = %b, en_A = %b, en_B = %b, en_C = %b, en_status = %b, 
                           sel_A = %b, sel_B = %b, w_en = %b, reg_sel = %b, wb_sel = %b", waiting, en_A
                           , en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel, wb_sel);
          nerr = 1'b1;
          failed = failed + 1;
        end
        #10; //c2
        assert (waiting === 1'b0 && en_A === 1'b0 && en_B === 1'b1 && en_C === 1'b0 && en_status === 1'b0 && 
                sel_A === 1'b0 && sel_B === 1'b0 && w_en === 1'b0 && reg_sel === 2'b00 && wb_sel === 2'b00) 
          $display("[PASS] All the control signals are correct");
        else begin $error("[FAIL] waiting = %b, en_A = %b, en_B = %b, en_C = %b, en_status = %b, 
                           sel_A = %b, sel_B = %b, w_en = %b, reg_sel = %b, wb_sel = %b", waiting, en_A
                           , en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel, wb_sel);
          nerr = 1'b1;
          failed = failed + 1;
        end
        #10; //c3
        assert (waiting === 1'b0 && en_A === 1'b0 && en_B === 1'b0 && en_C === 1'b1 && en_status === 1'b0 && 
                sel_A === 1'b0 && sel_B === 1'b0 && w_en === 1'b0 && reg_sel === 2'b00 && wb_sel === 2'b00) 
          $display("[PASS] All the control signals are correct");
        else begin $error("[FAIL] waiting = %b, en_A = %b, en_B = %b, en_C = %b, en_status = %b, 
                           sel_A = %b, sel_B = %b, w_en = %b, reg_sel = %b, wb_sel = %b", waiting, en_A
                           , en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel, wb_sel);
          nerr = 1'b1;
          failed = failed + 1;
        end
        #10; //c4
        assert (waiting === 1'b0 && en_A === 1'b0 && en_B === 1'b0 && en_C === 1'b0 && en_status === 1'b0 && 
                sel_A === 1'b0 && sel_B === 1'b0 && w_en === 1'b1 && reg_sel === 2'b01 && wb_sel === 2'b00) 
          $display("[PASS] All the control signals are correct");
        else begin $error("[FAIL] waiting = %b, en_A = %b, en_B = %b, en_C = %b, en_status = %b, 
                           sel_A = %b, sel_B = %b, w_en = %b, reg_sel = %b, wb_sel = %b", waiting, en_A
                           , en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel, wb_sel);
          nerr = 1'b1;
          failed = failed + 1;
        end

        #10;
        $display("Testing mvn");
        mvn; //c1
        assert (waiting === 1'b0 && en_A === 1'b0 && en_B === 1'b1 && en_C === 1'b0 && en_status === 1'b0 && 
                sel_A === 1'b0 && sel_B === 1'b0 && w_en === 1'b0 && reg_sel === 2'b00 && wb_sel === 2'b00) 
          $display("[PASS] All the control signals are correct");
        else begin $error("[FAIL] waiting = %b, en_A = %b, en_B = %b, en_C = %b, en_status = %b, 
                           sel_A = %b, sel_B = %b, w_en = %b, reg_sel = %b, wb_sel = %b", waiting, en_A
                           , en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel, wb_sel);
          nerr = 1'b1;
          failed = failed + 1;
        end
        #10; //c2
        assert (waiting === 1'b0 && en_A === 1'b0 && en_B === 1'b0 && en_C === 1'b1 && en_status === 1'b0 && 
                sel_A === 1'b1 && sel_B === 1'b0 && w_en === 1'b0 && reg_sel === 2'b00 && wb_sel === 2'b00) 
          $display("[PASS] All the control signals are correct");
        else begin $error("[FAIL] waiting = %b, en_A = %b, en_B = %b, en_C = %b, en_status = %b, 
                           sel_A = %b, sel_B = %b, w_en = %b, reg_sel = %b, wb_sel = %b", waiting, en_A
                           , en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel, wb_sel);
          nerr = 1'b1;
          failed = failed + 1;
        end
        #10; //c3
        assert (waiting === 1'b0 && en_A === 1'b0 && en_B === 1'b0 && en_C === 1'b0 && en_status === 1'b0 && 
                sel_A === 1'b0 && sel_B === 1'b0 && w_en === 1'b1 && reg_sel === 2'b01 && wb_sel === 2'b00) 
          $display("[PASS] All the control signals are correct");
        else begin $error("[FAIL] waiting = %b, en_A = %b, en_B = %b, en_C = %b, en_status = %b, 
                           sel_A = %b, sel_B = %b, w_en = %b, reg_sel = %b, wb_sel = %b", waiting, en_A
                           , en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel, wb_sel);
          nerr = 1'b1;
          failed = failed + 1;
        end
       
        #10;
        $display("Testing MOVimm");
        MOVimm; //c1
        assert (waiting === 1'b0 && en_A === 1'b0 && en_B === 1'b0 && en_C === 1'b0 && en_status === 1'b0 && 
                sel_A === 1'b0 && sel_B === 1'b0 && w_en === 1'b1 && reg_sel === 2'b10 && wb_sel === 2'b10) 
          $display("[PASS] All the control signals are correct");
        else begin $error("[FAIL] waiting = %b, en_A = %b, en_B = %b, en_C = %b, en_status = %b, 
                           sel_A = %b, sel_B = %b, w_en = %b, reg_sel = %b, wb_sel = %b", waiting, en_A
                           , en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel, wb_sel);
          nerr = 1'b1;
          failed = failed + 1;
        end

        #10;
        $display("Testing MOV");
        MOV; //c1
        assert (waiting === 1'b0 && en_A === 1'b0 && en_B === 1'b1 && en_C === 1'b0 && en_status === 1'b0 && 
                sel_A === 1'b0 && sel_B === 1'b0 && w_en === 1'b0 && reg_sel === 2'b00 && wb_sel === 2'b00) 
          $display("[PASS] All the control signals are correct");
        else begin $error("[FAIL] waiting = %b, en_A = %b, en_B = %b, en_C = %b, en_status = %b, 
                           sel_A = %b, sel_B = %b, w_en = %b, reg_sel = %b, wb_sel = %b", waiting, en_A
                           , en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel, wb_sel);
          nerr = 1'b1;
          failed = failed + 1;
        end
        #10; //c2
        assert (waiting === 1'b0 && en_A === 1'b0 && en_B === 1'b0 && en_C === 1'b1 && en_status === 1'b0 && 
                sel_A === 1'b1 && sel_B === 1'b0 && w_en === 1'b0 && reg_sel === 2'b00 && wb_sel === 2'b00) 
          $display("[PASS] All the control signals are correct");
        else begin $error("[FAIL] waiting = %b, en_A = %b, en_B = %b, en_C = %b, en_status = %b, 
                           sel_A = %b, sel_B = %b, w_en = %b, reg_sel = %b, wb_sel = %b", waiting, en_A
                           , en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel, wb_sel);
          nerr = 1'b1;
          failed = failed + 1;
        end
        #10; //c3
        assert (waiting === 1'b0 && en_A === 1'b0 && en_B === 1'b0 && en_C === 1'b0 && en_status === 1'b0 && 
                sel_A === 1'b0 && sel_B === 1'b0 && w_en === 1'b1 && reg_sel === 2'b01 && wb_sel === 2'b00) 
          $display("[PASS] All the control signals are correct");
        else begin $error("[FAIL] waiting = %b, en_A = %b, en_B = %b, en_C = %b, en_status = %b, 
                           sel_A = %b, sel_B = %b, w_en = %b, reg_sel = %b, wb_sel = %b", waiting, en_A
                           , en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel, wb_sel);
          nerr = 1'b1;
          failed = failed + 1;
        end

        #10;
		    $display("Testing reset during computing");
		    $display("Testing MOV");
        MOV; //c1
        assert (waiting === 1'b0 && en_A === 1'b0 && en_B === 1'b1 && en_C === 1'b0 && en_status === 1'b0 && 
                sel_A === 1'b0 && sel_B === 1'b0 && w_en === 1'b0 && reg_sel === 2'b00 && wb_sel === 2'b00) 
          $display("[PASS] All the control signals are correct");
        else begin $error("[FAIL] waiting = %b, en_A = %b, en_B = %b, en_C = %b, en_status = %b, 
                           sel_A = %b, sel_B = %b, w_en = %b, reg_sel = %b, wb_sel = %b", waiting, en_A
                           , en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel, wb_sel);
          nerr = 1'b1;
          failed = failed + 1;
        end
        #10; //c2
        assert (waiting === 1'b0 && en_A === 1'b0 && en_B === 1'b0 && en_C === 1'b1 && en_status === 1'b0 && 
                sel_A === 1'b1 && sel_B === 1'b0 && w_en === 1'b0 && reg_sel === 2'b00 && wb_sel === 2'b00) 
          $display("[PASS] All the control signals are correct");
        else begin $error("[FAIL] waiting = %b, en_A = %b, en_B = %b, en_C = %b, en_status = %b, 
                           sel_A = %b, sel_B = %b, w_en = %b, reg_sel = %b, wb_sel = %b", waiting, en_A
                           , en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel, wb_sel);
          nerr = 1'b1;
          failed = failed + 1;
        end
		    reset;
		    assert (waiting === 1'b1) $display("[PASS] The ctl is waiting");
        else begin
          $error("[FAIL] The ctl is waiting but waiting is not 1");
          nerr = 1'b1;
          failed = failed + 1;
        end

        $display("err is %b", err);
        $display("Total number of tests failed is: %d", failed);
	        $stop;
    end
endmodule: tb_controller2
