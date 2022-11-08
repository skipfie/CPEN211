module tb_datapath(output err);
   input clk, input [15:0] datapath_in, input wb_sel,
                input [2:0] w_addr, input w_en, input [2:0] r_addr, input en_A,
                input en_B, input [1:0] shift_op, input sel_A, input sel_B,
                input [1:0] ALU_op, input en_C, input en_status,
                output [15:0] datapath_out, output Z_out

    reg nerr = 1'b0;
    assign err = nerr;

    reg clk, wb_sel, w_en, en_A, en_B, sel_A, sel_B, en_C, en_status;
    reg [1:0] shift_op;
    reg [2:0] w_addr, r_addr;
    reg [15:0] datapath_in;

    wire Z_out;
    wire [15:0] datapath_out;

    
endmodule: tb_datapath
