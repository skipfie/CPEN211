module controller(input clk, input rst_n, input start,
                  input [2:0] opcode, input [1:0] ALU_op, input [1:0] shift_op,
                  input Z, input N, input V,
                  output waiting,
                  output [1:0] reg_sel, output [1:0] wb_sel, output w_en,
                  output en_A, output en_B, output en_C, output en_status,
                  output sel_A, output sel_B);
    reg _waiting, _en_A, _en_B, _en_C, _en_status, _sel_A, _sel_B, _w_en;
    reg [1:0] reg_sel, wb_sel; 
    assign waiting = _waiting;
    assign en_A = _en_A;
    assign en_B = _en_B;
    assign en_C = _en_C;
    assign en_status = _en_status;
    assign sel_A = _sel_A;
    assign sel_B = _sel_B
    assign w_en = _w_en;
    
    // define the name of each state
    `define wait = 4'd0
    `define start = 4'd1
    `define alu = 4'd2
    `define move = 4'd3
    `define add = 4'd4
    `define cmp = 4'd5
    `define and = 4'd6
    `define mvn = 4'd7
    `define mov1 = 4'd8
    `define mov2 = 4'd9

    // for state transition
    always_ff @(posedge clk) begin
        if (~rst_n) state <= `wait //active low reset
        else begin
            case (state)
            `wait: begin
                if (start) 
                    state <= `start;
                else state <= `wait;
            end
            `start: begin
                if (opcode == 3'b101)
                    state <= `alu;
                else if (opcode == 3'b110)
                    state <= 'move;
                else state <=`start;
            end 
            `alu: begin
                if (ALU_op == 00)
                    state <= `add;
                else if (ALU_op == 01)
                    state <= `cmp;
                else if (ALU_op == 10)
                    state <= `and;
                else if (ALU_op == 11)
                    state <= `mvn;
            end 
            'add: state <= `wait;
            `cmp: state <= `wait;
            `and: state <= `wait;
            `mvn: state <= `wait;
            `mov1: state <= `wait;
            `mov2: state <= `wait;
            default: state <= `wait;
            endcase
        end

  end 

    // for output logic
    always_comb begin
        case (state)
            `wait: _waiting = 1'b1;
            `start: 
            `alu:
            `move 
        
        endcase
    end

endmodule: controller
