module controller(input clk, input rst_n, input [2:0] opcode, input [1:0] ALU_op,
                  output reg load_pc, output reg load_ir, output reg load_addr, //waiting in lab6
                  output reg ram_w_en, output reg sel_addr, output reg clear_pc, 
                  output reg [1:0] reg_sel, output reg [1:0] wb_sel, output reg w_en,
                  output reg en_A, output reg en_B, output reg en_C, output reg en_status,
                  output reg sel_A, output reg sel_B);
    
    // define the name of each state, fd == fetch & decode, fdr == fd & reset
    enum reg [4:0] {fd, fdr, halt, mov1, mov_1, mov_2, mov_3, mvn1, mvn2, mvn3, 
                    add1, add2, add3, add4, cmp1, cmp2, cmp3, and1, and2, and3, and4} state;

    // for state transition
    always_ff @(posedge clk) begin
        if (~rst_n) state <= fdr; //active low reset to fetch 
        else begin 
            case (state)
            fd: begin
                if (opcode == 3'b101 && ALU_op == 2'b00) state <= add1;
                else if (opcode == 3'b101 && ALU_op == 2'b01) state <= cmp1;
                else if (opcode == 3'b101 && ALU_op == 2'b10) state <= and1;
                else if (opcode == 3'b101 && ALU_op == 2'b11) state <= mvn1;

                else if (opcode == 3'b110 && ALU_op == 2'b10) state <= mov1;
                else if (opcode == 3'b110 && ALU_op == 2'b00) state <= mov_1;
                else if (opcode == 3'b111) state <= halt;
                else state <= fd;
            end
            mov1: state <= fd;
            mov_1: state <= mov_2;
            mov_2: state <= mov_3;
            mov_3: state <= fd;

            add1: state <= add2;
            add2: state <= add3;
            add3: state <= add4;
            add4: state <= fd;

            cmp1: state <= cmp2;
            cmp2: state <= cmp3;
            cmp3: state <= fd;

            and1: state <= and2;
            and2: state <= and3;
            and3: state <= and4;
            and4: state <= fd;

            mvn1: state <= mvn2;
            mvn2: state <= mvn3;
            mvn3: state <= fd;

            halt: state <= halt;
            default: state <= fd;
            endcase
        end
    end

    // for output logic
    assign en_A = (state == add1) ? 1'b1 :
                   (state == cmp1) ? 1'b1 :
                   (state == and1) ? 1'b1 : 1'b0;

    assign en_B = (state == add2) ? 1'b1 :
                   (state == cmp2) ? 1'b1 :
                   (state == and2) ? 1'b1 :
                   (state == mvn1) ? 1'b1 :
                   (state == mov_1) ? 1'b1 : 1'b0;

    assign en_C = (state == add3) ? 1'b1 :
                   (state == and3) ? 1'b1 :
                   (state == mvn2) ? 1'b1 :
                   (state == mov_2) ? 1'b1 : 1'b0;

    assign en_status = (state == cmp3) ? 1'b1 : 1'b0;

    assign sel_A = (state == mvn2) ? 1'b1 :
                    (state == mov_2) ? 1'b1 : 1'b0;

    assign sel_B = 1'b0;

    assign w_en = (state == add4) ? 1'b1 :
                   (state == mvn3) ? 1'b1 :
                   (state == and4) ? 1'b1 :
                   (state == mov1) ? 1'b1 :
                   (state == mov_3) ? 1'b1 : 1'b0;
    
    assign reg_sel = (state == add1) ? 2'b10 :
                      (state == cmp1) ? 2'b10 :
                      (state == and1) ? 2'b10 :
                      (state == mov1) ? 2'b10 :
                      (state == add4) ? 2'b01 :
                      (state == and4) ? 2'b01 :
                      (state == mvn3) ? 2'b01 :
                      (state == mov_3) ? 2'b01 : 2'b00;
    
    assign wb_sel = (state == mov1) ? 2'b10 : 2'b00;

    assign load_ir = (state == fdr) ? 1'b1 :
                     (state == fd) ? 1'b1 :
                     (state == add4) ? 1'b1 : 
                     (state == cmp3) ? 1'b1 :
                     (state == and4) ? 1'b1 :
                     (state == mvn3) ? 1'b1 :
                     (state == mov1) ? 1'b1 :
                     (state == mov_3) ? 1'b1 : 1'b0; 

    assign load_pc = (state == fdr) ? 1'b1 :
                     (state == add1) ? 1'b1 : 
                     (state == cmp1) ? 1'b1 :
                     (state == and1) ? 1'b1 :
                     (state == mvn1) ? 1'b1 :
                     (state == mov1) ? 1'b1 :
                     (state == mov_1) ? 1'b1 : 1'b0; 

    assign clear_pc = (state == fdr) ? 1'b1 : 1'b0;

    //assign ram_w_en = (state)

    assign sel_addr = (state == fd) ? 1'b1 :
                      (state == fdr) ? 1'b1 : 1'b0; 

    //assign load_addr = (state == )

endmodule: controller