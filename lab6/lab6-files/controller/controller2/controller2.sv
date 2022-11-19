module controller2(input clk, input rst_n, input start,
                  input [2:0] opcode, input [1:0] ALU_op, input [1:0] shift_op,
                  input Z, input N, input V,
                  output waiting,
                  output [1:0] reg_sel, output [1:0] wb_sel, output w_en,
                  output en_A, output en_B, output en_C, output en_status,
                  output sel_A, output sel_B, output reg [1:0] test_port1, output reg [4:0] test_port2);
    //assign test_port1 = 2'b10;
    assign test_port2 = 4'b0110;

    reg _waiting, _en_A, _en_B, _en_C, _en_status, _sel_A, _sel_B, _w_en;
    reg [1:0] _reg_sel, _wb_sel; 
    assign waiting = _waiting; //if the ctl is busy computing, waiting is 0, otherwise waiting is 1
    assign en_A = _en_A;
    assign en_B = _en_B;
    assign en_C = _en_C;
    assign en_status = _en_status;
    assign sel_A = _sel_A;
    assign sel_B = _sel_B;
    assign w_en = _w_en;
    assign reg_sel = _reg_sel;
    assign wb_sel = _wb_sel;
    
    // define the name of each state
    enum reg [4:0] {Wait, mov1, mov_1, mov_2, mov_3, mvn1, mvn2, mvn3, 
                    add1, add2, add3, add4, cmp1, cmp2, cmp3, cmp4, and1, and2, and3, and4} state;

    // for state transition
    always_ff @(posedge clk) begin
        if (~rst_n) state <= Wait; //active low reset
        else begin 
            case (state)
            Wait: begin
                if (start && opcode == 3'b101 && ALU_op == 2'b00) state <= add1;
                else if (start && opcode == 3'b101 && ALU_op == 2'b01) state <= cmp1;
                else if (start && opcode == 3'b101 && ALU_op == 2'b10) state <= and1;
                else if (start && opcode == 3'b101 && ALU_op == 2'b11) state <= mvn1;

                else if (start && opcode == 3'b110 && ALU_op == 2'b10) state <= mov1;
                else if (start && opcode == 3'b110 && ALU_op == 2'b00) state <= mov_1;
                else state <= Wait;
            end 
            mov1: state <= Wait;
            mov_1: state <= mov_2;
            mov_2: state <= mov_3;
            mov_3: state <= Wait;

            add1: state <= add2;
            add2: state <= add3;
            add3: state <= add4;
            add4: state <= Wait;

            cmp1: state <= cmp2;
            cmp2: state <= cmp3;
            cmp3: state <= cmp4;
            cmp4: state <= Wait;

            and1: state <= and2;
            and2: state <= and3;
            and3: state <= and4;
            and4: state <= Wait;

            mvn1: state <= mvn2;
            mvn2: state <= mvn3;
            mvn3: state <= Wait;
            default: state <= Wait;
            endcase
        end
    end

    // for output logic
    assign _waiting = (state == Wait) ? 1'b1 : 1'b0 ;

    assign _en_A = (state == add1) ? 1'b1 :
                   (state == cmp1) ? 1'b1 :
                   (state == and1) ? 1'b1 : 1'b0 ;

    assign _en_B = (state == add2) ? 1'b1 :
                   (state == cmp2) ? 1'b1 :
                   (state == and2) ? 1'b1 :
                   (state == mvn1) ? 1'b1 :
                   (state == mov_1) ? 1'b1 : 1'b0 ;

    assign _en_C = (state == add3) ? 1'b1 :
                   (state == and3) ? 1'b1 :
                   (state == mvn2) ? 1'b1 :
                   (state == mov_2) ? 1'b1 : 1'b0 ;

    assign _en_status = (state == cmp4) ? 1'b1 : 1'b0 ;

    assign _sel_A = (state == mvn2) ? 1'b1 :
                    (state == mov_2) ? 1'b1 : 1'b0 ;

    assign _sel_B = 1'b0;

    assign _w_en = (state == add4) ? 1'b1 :
                   (state == mvn3) ? 1'b1 :
                   (state == and4) ? 1'b1 :
                   (state == mov1) ? 1'b1 :
                   (state == mov_3) ? 1'b1 : 1'b0 ;
    
    assign _reg_sel = (state == add1) ? 2'b10 :
                      (state == cmp1) ? 2'b10 :
                      (state == and1) ? 2'b10 :
                      (state == mov1) ? 2'b10 :
                      (state == add4) ? 2'b01 :
                      (state == and4) ? 2'b01 :
                      (state == mvn3) ? 2'b01 :
                      (state == mov_3) ? 2'b01 : 2'b00 ;
    
    assign _wb_sel = (state == mov1) ? 2'b10 : 2'b00 ;

   /*always_comb begin
        case (state)
            Wait: begin 
                _waiting = 1'b1;
                _en_A = 1'b0;
                _en_B = 1'b0;
                _en_C = 1'b0;
                _en_status = 1'b0;
                _sel_A = 1'b0;
                _sel_B = 1'b0;
                _w_en = 1'b0;
                _reg_sel = 2'b00;
                _wb_sel = 2'b00;
                test_port1 = 2'b11;
            end
            
            add1: begin
                _waiting = 1'b0;
                _en_A = 1'b1;
                _en_B = 1'b0;
                _en_C = 1'b0;
                _en_status = 1'b0;
                _sel_A = 1'b0;
                _sel_B = 1'b0;
                _w_en = 1'b0;
                _reg_sel = 2'b10;
                _wb_sel = 2'b00;
                test_port1 = 2'b00;
            end 
            add2: begin
                _waiting = 1'b0;
                _en_A = 1'b0;
                _en_B = 1'b1;
                _en_C = 1'b0;
                _en_status = 1'b0;
                _sel_A = 1'b0;
                _sel_B = 1'b0;
                _w_en = 1'b0;
                _reg_sel = 2'b00;
                _wb_sel = 2'b00;
                test_port1 = 2'b11;
            end 
            add3: begin
                _waiting = 1'b0;
                _en_A = 1'b0;
                _en_B = 1'b0;
                _en_C = 1'b1;
                _en_status = 1'b0;
                _sel_A = 1'b0;
                _sel_B = 1'b0;
                _w_en = 1'b0;
                _reg_sel = 2'b00;
                _wb_sel = 2'b00;
                test_port1 = 2'b00;
            end 
            add4: begin
                _waiting = 1'b0;
                _en_A = 1'b0;
                _en_B = 1'b0;
                _en_C = 1'b0;
                _en_status = 1'b0;
                _sel_A = 1'b0;
                _sel_B = 1'b0;
                _w_en = 1'b1;
                _reg_sel = 2'b01;
                _wb_sel = 2'b00;
                test_port1 = 2'b11;
            end 

            cmp1: begin
                _waiting = 1'b0;
                _en_A = 1'b1;
                _en_B = 1'b0;
                _en_C = 1'b0;
                _en_status = 1'b0;
                _sel_A = 1'b0;
                _sel_B = 1'b0;
                _w_en = 1'b0;
                _reg_sel = 2'b10;
                _wb_sel = 2'b00;
                test_port1 = 2'b00;
            end
            cmp2: begin
                _waiting = 1'b0;
                _en_A = 1'b0;
                _en_B = 1'b1;
                _en_C = 1'b0;
                _en_status = 1'b0;
                _sel_A = 1'b0;
                _sel_B = 1'b0;
                _w_en = 1'b0;
                _reg_sel = 2'b00;
                _wb_sel = 2'b00;
                test_port1 = 2'b11;
            end
            cmp3: begin
                _waiting = 1'b0;
                _en_A = 1'b0;
                _en_B = 1'b0;
                _en_C = 1'b0;
                _en_status = 1'b0;
                _sel_A = 1'b0;
                _sel_B = 1'b0;
                _w_en = 1'b0;
                _reg_sel = 2'b00;
                _wb_sel = 2'b00;
                test_port1 = 2'b00;
            end
            cmp4: begin
                _waiting = 1'b0;
                _en_A = 1'b0;
                _en_B = 1'b0;
                _en_C = 1'b0;
                _en_status = 1'b1;
                _sel_A = 1'b0;
                _sel_B = 1'b0;
                _w_en = 1'b0;
                _reg_sel = 2'b00;
                _wb_sel = 2'b00;
                test_port1 = 2'b11;
            end

            and1: begin
                _waiting = 1'b0;
                _en_A = 1'b1;
                _en_B = 1'b0;
                _en_C = 1'b0;
                _en_status = 1'b0;
                _sel_A = 1'b0;
                _sel_B = 1'b0;
                _w_en = 1'b0;
                _reg_sel = 2'b10;
                _wb_sel = 2'b00;
                test_port1 = 2'b00;
            end 
            and2: begin
                _waiting = 1'b0;
                _en_A = 1'b0;
                _en_B = 1'b1;
                _en_C = 1'b0;
                _en_status = 1'b0;
                _sel_A = 1'b0;
                _sel_B = 1'b0;
                _w_en = 1'b0;
                _reg_sel = 2'b00;
                _wb_sel = 2'b00;
                test_port1 = 2'b11;
            end 
            and3: begin
                _waiting = 1'b0;
                _en_A = 1'b0;
                _en_B = 1'b0;
                _en_C = 1'b1;
                _en_status = 1'b0;
                _sel_A = 1'b0;
                _sel_B = 1'b0;
                _w_en = 1'b0;
                _reg_sel = 2'b00;
                _wb_sel = 2'b00;
                test_port1 = 2'b00;
            end 
            and4: begin
                _waiting = 1'b0;
                _en_A = 1'b0;
                _en_B = 1'b0;
                _en_C = 1'b0;
                _en_status = 1'b0;
                _sel_A = 1'b0;
                _sel_B = 1'b0;
                _w_en = 1'b1;
                _reg_sel = 2'b01;
                _wb_sel = 2'b00;
                test_port1 = 2'b11;
            end 

            mvn1: begin
                _waiting = 1'b0;
                _en_A = 1'b0;
                _en_B = 1'b1;
                _en_C = 1'b0;
                _en_status = 1'b0;
                _sel_A = 1'b0;
                _sel_B = 1'b0;
                _w_en = 1'b0;
                _reg_sel = 2'b00;
                _wb_sel = 2'b00;
                test_port1 = 2'b00;
            end
            mvn2: begin
                _waiting = 1'b0;
                _en_A = 1'b0;
                _en_B = 1'b0;
                _en_C = 1'b1;
                _en_status = 1'b0;
                _sel_A = 1'b1;
                _sel_B = 1'b0;
                _w_en = 1'b0;
                _reg_sel = 2'b00;
                _wb_sel = 2'b00;
                test_port1 = 2'b11;
            end
            mvn3: begin
                _waiting = 1'b0;
                _en_A = 1'b0;
                _en_B = 1'b0;
                _en_C = 1'b0;
                _en_status = 1'b0;
                _sel_A = 1'b0;
                _sel_B = 1'b0;
                _w_en = 1'b1;
                _reg_sel = 2'b01;
                _wb_sel = 2'b00;
                test_port1 = 2'b100;
            end

            mov1: begin
                _waiting = 1'b0;
                _en_A = 1'b0;
                _en_B = 1'b0;
                _en_C = 1'b0;
                _en_status = 1'b0;
                _sel_A = 1'b0;
                _sel_B = 1'b0;
                _w_en = 1'b1;
                _reg_sel = 2'b10;
                _wb_sel = 2'b10; // select sximm8
                test_port1 = 2'b11;
            end

            mov_1: begin
                _waiting = 1'b0;
                _en_A = 1'b0;
                _en_B = 1'b1;
                _en_C = 1'b0;
                _en_status = 1'b0;
                _sel_A = 1'b0;
                _sel_B = 1'b0;
                _w_en = 1'b0;
                _reg_sel = 2'b00;
                _wb_sel = 2'b00;
                test_port1 = 2'b00;
            end
            mov_2: begin
                _waiting = 1'b0;
                _en_A = 1'b0;
                _en_B = 1'b0;
                _en_C = 1'b1;
                _en_status = 1'b0;
                _sel_A = 1'b1;
                _sel_B = 1'b0;
                _w_en = 1'b0;
                _reg_sel = 2'b00;
                _wb_sel = 2'b00;
                test_port1 = 2'b11;
            end
            mov_3: begin
                _waiting = 1'b0;
                _en_A = 1'b0;
                _en_B = 1'b0;
                _en_C = 1'b0;
                _en_status = 1'b0;
                _sel_A = 1'b0;
                _sel_B = 1'b0;
                _w_en = 1'b1;
                _reg_sel = 2'b01;
                _wb_sel = 2'b00;
                test_port1 = 2'b00;
            end
            default: begin
                _waiting = 1'b1;
                _en_A = 1'b0;
                _en_B = 1'b0;
                _en_C = 1'b0;
                _en_status = 1'b0;
                _sel_A = 1'b0;
                _sel_B = 1'b0;
                _w_en = 1'b0;
                _reg_sel = 2'b00;
                _wb_sel = 2'b00;
                test_port1 = 2'b11;
            end
        endcase
    end*/
endmodule: controller2