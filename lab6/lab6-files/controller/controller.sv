module controller(input clk, input rst_n, input start,
                  input [2:0] opcode, input [1:0] ALU_op, input [1:0] shift_op,
                  input Z, input N, input V,
                  output waiting,
                  output [1:0] reg_sel, output [1:0] wb_sel, output w_en,
                  output en_A, output en_B, output en_C, output en_status,
                  output sel_A, output sel_B);
    reg _waiting, _en_A, _en_B, _en_C, _en_status, _sel_A, _sel_B, _w_en;
    reg [1:0] _reg_sel, _wb_sel; 
    reg [4:0] state;
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
    `define Wait 5'd0
    //`define start 5'd1

    //`define move 5'd2
    `define mov1 5'd3

    `define mov_1 5'd4
    `define mov_2 5'd5
    `define mov_3 5'd6

    //`define alu 5'd7
    `define add1 5'd8
    `define add2 5'd9
    `define add3 5'd10
    `define add4 5'd11

    `define cmp1 5'd12
    `define cmp2 5'd13
    `define cmp3 5'd14
    `define cmp4 5'd15

    `define And1 5'd16
    `define And2 5'd17
    `define And3 5'd18
    `define And4 5'd19

    `define mvn1 5'd20
    `define mvn2 5'd21
    `define mvn3 5'd22

    // for state transition
    always_ff @(posedge clk) begin
        if (~rst_n) state <= `Wait; //active low reset
        else begin
            case (state)
            /*`Wait: begin
                if (start) state <= `start;
                else state <= `Wait;
            end*/
            `Wait: begin
                if (start && opcode == 3'b101 && ALU_op == 2'b00) state <= `add1;
                else if (start && opcode == 3'b101 && ALU_op == 2'b01) state <= `cmp1;
                else if (start && opcode == 3'b101 && ALU_op == 2'b10) state <= `And1;
                else if (start && opcode == 3'b101 && ALU_op == 2'b11) state <= `mov1;

                else if (start && opcode == 3'b110 && shift_op == 2'b10) state <= `mov1;
                else if (start && opcode == 3'b110 && shift_op == 2'b00) state <= `mov_1;
                else state <=`Wait;
            end 
            /*`alu: begin
                if (ALU_op == 2'b00) state <= `add1;
                else if (ALU_op == 2'b01) state <= `cmp1;
                else if (ALU_op == 2'b10) state <= `And1;
                else if (ALU_op == 2'b11) state <= `mvn1;
            end 
            `move: begin
                if (shift_op == 2'b10) state <= `mov1;
                else if (shift_op == 2'b00) state <= `mov_1;
                else state <= `move;
            end*/
            `mov1: state <= `Wait;
            `mov_1: state <= `mov_2;
            `mov_2: state <= `mov_3;
            `mov_3: state <= `Wait;

            `add1: state <= `add2;
            `add2: state <= `add3;
            `add3: state <= `add4;
            `add4: state <= `Wait;

            `cmp1: state <= `cmp2;
            `cmp2: state <= `cmp3;
            `cmp3: state <= `cmp4;
            `cmp4: state <= `Wait;

            `And1: state <= `And2;
            `And2: state <= `And3;
            `And3: state <= `And4;
            `And4: state <= `Wait;

            `mvn1: state <= `mvn2;
            `mvn2: state <= `mvn3;
            `mvn3: state <= `Wait;
            default: state <= `Wait;
            endcase
        end
    end

    // for output logic
    always_comb begin
        case (state)
            `Wait: begin 
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
            end
            /*`start: begin 
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
            end*/
            `alu: begin
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
            end
            `move: begin
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
            end

            `add1: begin
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
            end 
            `add2: begin
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
            end 
            `add3: begin
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
            end 
            `add4: begin
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
            end 

            `cmp1: begin
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
            end
            `cmp2: begin
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
            end
            `cmp3: begin
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
            end
            `cmp4: begin
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
            end

            `And1: begin
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
            end 
            `And2: begin
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
            end 
            `And3: begin
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
            end 
            `And4: begin
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
            end 

            `mvn1: begin
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
            end
            `mvn2: begin
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
            end
            `mvn3: begin
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
            end

            `mov1: begin
                _waiting = 1'b0;
                _en_A = 1'b0;
                _en_B = 1'b0;
                _en_C = 1'b0;
                _en_status = 1'b0;
                _sel_A = 1'b0;
                _sel_B = 1'b0;
                _w_en = 1'b0;
                _reg_sel = 2'b10;
                _wb_sel = 2'b10; // select sximm8
            end

            `mov_1: begin
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
            end
            `mov_2: begin
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
            end
            `mov_3: begin
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
            end
        endcase
    end
endmodule: controller