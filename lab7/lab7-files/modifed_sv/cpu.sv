module cpu(input clk, input rst_n, input [7:0] start_pc, input [15:0] ram_r_data,
           output [15:0] out, 
           output reg ram_w_en, output reg [7:0] ram_addr, output wire [15:0] ram_w_data);
    
    reg [15:0] instr_reg;
    reg [7:0] program_counter, data_addr_reg;

    // mux
    reg [7:0] next_pc;

    // for instruction decoder
    wire [1:0] ALU_op, shift_op;
    wire [2:0] opcode, r_addr, w_addr;
    wire [15:0] sximm5, sximm8;

    // for controller fsm
    wire w_en, en_A, en_B, sel_A, sel_B, en_C, en_status, sel_addr;
    wire [1:0] reg_sel, wb_sel;

    wire load_pc, clear_pc, load_ir;

    // for datapath
    assign out = ram_w_data;
    wire N, V, Z;    

    datapath datapath(.clk(clk), .mdata(ram_r_data), .pc(program_counter), .wb_sel(wb_sel),
                      .w_addr(w_addr), .w_en(w_en), .r_addr(r_addr), .en_A(en_A),
                      .en_B(en_B), .shift_op(shift_op), .sel_A(sel_A), .sel_B(sel_B),
                      .ALU_op(ALU_op), .en_C(en_C), .en_status(en_status),
                      .sximm8(sximm8), .sximm5(sximm5),
                      .datapath_out(out), .Z_out(Z), .N_out(N), .V_out(V));

    idecoder idecoder(.ir(instr_reg), .reg_sel(reg_sel),
                      .opcode(opcode), .ALU_op(ALU_op), .shift_op(shift_op),
                      .sximm5(sximm5), .sximm8(sximm8),
                      .r_addr(r_addr), .w_addr(w_addr));

    controller controller(.clk(clk), .rst_n(rst_n), .load_ir(load_ir)
                          .opcode(opcode), .ALU_op(ALU_op), .shift_op(shift_op),
                          .Z(Z), .N(N), .V(V),
                          .waiting(waiting),
                          .reg_sel(reg_sel), .wb_sel(wb_sel), .w_en(w_en),
                          .en_A(en_A), .en_B(en_B), .en_C(en_C), .en_status(en_status),
                          .sel_A(sel_A), .sel_B(sel_B));

    // muxes
    always_comb begin
        if (clear_pc) next_pc = start_pc;
        else next_pc = program_counter + 1;

        if (sel_addr) ram_addr = program_counter;
        else ram_addr = data_addr_reg;
    end
    
    // register with enable
    always_ff @(posedge clk) begin
        if (load_ir) instr_reg <= ram_r_data;
        if (load_pc) program_counter <= next_pc;
        if (load_addr) data_addr_reg <= out[7:0];
    end

endmodule: cpu
