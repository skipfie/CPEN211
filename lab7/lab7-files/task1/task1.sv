module task1(input clk, input rst_n, input [7:0] start_pc, output [15:0] out);
    // to ram
    wire ram_w_en;
    wire [7:0] ram_addr;
    wire [15:0] ram_w_data, ram_r_data;

    cpu cpu(.clk(clk), .rst_n(rst_n), .start_pc(start_pc), .ram_r_data(ram_r_data),
            .out(out), 
            .ram_w_en(ram_w_en), .ram_addr(ram_addr), .ram_w_data(ram_w_data));

    ram ram(.clk(clk), .ram_w_en(ram_w_en), 
            .ram_r_addr(ram_addr), .ram_w_addr(ram_addr), 
            .ram_w_data(ram_w_data), .ram_r_data(ram_r_data));
endmodule: task1

module cpu(input clk, input rst_n, input [7:0] start_pc, input [15:0] ram_r_data,
           output [15:0] out, 
           output ram_w_en, output reg [7:0] ram_addr, output [15:0] ram_w_data);
    
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

    wire load_pc, clear_pc, load_ir, load_addr;

    // for datapath
    assign ram_w_data = out;
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

    controller controller(.clk(clk), .rst_n(rst_n), .opcode(opcode), .ALU_op(ALU_op),
                          .load_pc(load_pc), .load_ir(load_ir), .load_addr(load_addr),
                          .ram_w_en(ram_w_en), .sel_addr(sel_addr), .clear_pc(clear_pc),
                          .reg_sel(reg_sel), .wb_sel(wb_sel), .w_en(w_en),
                          .en_A(en_A), .en_B(en_B), .en_C(en_C), .en_status(en_status),
                          .sel_A(sel_A), .sel_B(sel_B));

    // muxes
    always_comb begin
        if (clear_pc) next_pc = start_pc;
        else next_pc = program_counter + 8'd1;

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

module ALU(input [15:0] val_A, input [15:0] val_B, input [1:0] ALU_op, 
           output reg [15:0] ALU_out, output reg Z, output reg N, output reg V);
    always_comb begin
        Z = (ALU_out == 16'd0);
        N = (ALU_out[15] == 1'b1);
    end

    always_comb begin
        case (ALU_op) 
            2'b00: begin
                ALU_out = val_A + val_B;
                V = (val_A[15] & val_B[15] & ~ALU_out[15]) | (~val_A[15] & ~val_B[15] & ALU_out[15]);
            end
            2'b01: begin
                ALU_out = val_A - val_B;
                V = (val_A[15] & ~val_B[15] & ~ALU_out[15]) | (~val_A[15] & val_B[15] & ALU_out[15]);
            end
            2'b10: begin
                ALU_out = val_A & val_B;
                V = 1'b0;
            end
            2'b11: begin
                ALU_out = ~val_B;
                V = 1'b0;
            end
        endcase
    end
endmodule: ALU

module datapath(input clk, input [15:0] mdata, input [7:0] pc, input [1:0] wb_sel,
                input [2:0] w_addr, input w_en, input [2:0] r_addr, input en_A,
                input en_B, input [1:0] shift_op, input sel_A, input sel_B,
                input [1:0] ALU_op, input en_C, input en_status,
		            input [15:0] sximm8, input [15:0] sximm5,
                output [15:0] datapath_out, output Z_out, output N_out, output V_out);
  //for regfile
  reg [15:0] w_data;
  reg [15:0] r_data;

  //for shifter
  reg [15:0] shift_in;
  wire [15:0] shift_out;

  //for ALU
  reg signed [15:0] val_A, val_B, ALU_out;
  wire Z, V, N;

  //for the rest of the connections
  reg [15:0] A, C;
  assign datapath_out = C;
  reg [2:0] status;
  assign Z_out = status[2];
  assign N_out = status[1];
  assign V_out = status[0];

  //instaniation of ALU, shifter, and regfile
  ALU alu(.val_A(val_A), .val_B(val_B), .ALU_op(ALU_op), .ALU_out(ALU_out), .Z(Z), .N(N), .V(V));
  shifter shifter(.shift_in(shift_in), .shift_op(shift_op), .shift_out(shift_out));
  regfile regfile(.w_data(w_data), .w_addr(w_addr), .w_en(w_en), .r_addr(r_addr), .clk(clk), .r_data(r_data));

  //mux #6,7,9
  always_comb begin 
    if (sel_A == 1'b1)
      val_A = 16'b0;
    else 
      val_A = A;
    
    if (sel_B == 1'b1)
      val_B = sximm5;
    else 
      val_B = shift_out;
    case (wb_sel)
      2'b00: w_data = C;
      2'b01: w_data = {8'b0, pc};
      2'b10: w_data = sximm8;
      2'b11: w_data = mdata;
    endcase
  end
  //registers with enable
  always_ff @(posedge clk) begin
    if (en_A) A <= r_data; //A
    if (en_B) shift_in <= r_data; //B
    if (en_C) C <= ALU_out; //C
    if (en_status) begin //status
        status <= {Z,N,V};
    end
  end
endmodule: datapath

module idecoder(input [15:0] ir, input [1:0] reg_sel,
                output [2:0] opcode, output [1:0] ALU_op, output [1:0] shift_op,
		        output [15:0] sximm5, output [15:0] sximm8,
                output [2:0] r_addr, output [2:0] w_addr);
    reg [2:0] nr_addr, nw_addr;
    assign r_addr = nr_addr;
    assign w_addr = nw_addr;

    assign opcode = ir[15:13];
    assign ALU_op = ir[12:11];
    assign shift_op = ir[4:3];
    assign sximm5 = { {11{ir[4]}}, ir[4:0] };
    assign sximm8 = { {8{ir[7]}}, ir[7:0] };

    wire [2:0] Rm, Rd, Rn;
    assign Rm = ir[2:0];
    assign Rd = ir[7:5];
    assign Rn = ir[10:8];

    always_comb begin
        case (reg_sel)
            2'b00: begin
                nr_addr = Rm;
                nw_addr = Rm;
            end
            2'b01: begin
                nr_addr = Rd;
                nw_addr = Rd;
            end
            2'b10: begin
                nr_addr = Rn;
                nw_addr = Rn;
            end
            default: begin
                nr_addr = 3'b000;
                nw_addr = 3'b000;
            end // 11 is unused
        endcase
    end
endmodule: idecoder

module shifter(input [15:0] shift_in, input [1:0] shift_op, output reg [15:0] shift_out);
    reg [15:0] nout;
    assign shift_out = nout;

    always_comb begin
        case (shift_op) 
            2'b00: nout = shift_in;
            2'b01: nout = shift_in << 1;
            2'b10: nout = shift_in >> 1;
            2'b11: nout = $signed(shift_in) >>> 1;
        endcase
    end
endmodule: shifter

module controller(input clk, input rst_n, input [2:0] opcode, input [1:0] ALU_op,
                  output reg load_pc, output reg load_ir, output reg load_addr, //waiting in lab6
                  output reg ram_w_en, output reg sel_addr, output reg clear_pc, 
                  output reg [1:0] reg_sel, output reg [1:0] wb_sel, output reg w_en,
                  output reg en_A, output reg en_B, output reg en_C, output reg en_status,
                  output reg sel_A, output reg sel_B);
    
    // define the name of each state, fd == fetch & decode, fdr == fd & reset
    enum reg [4:0] {fdr, fd, halt, stall1, stall2, mov1, mov_1, mov_2, mov_3, mvn1, mvn2, mvn3, 
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

            fdr: state <= stall1;

            mov1: state <= stall1;

            stall1: state <= stall2;
            stall2: state <= fd;
            
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
                     (state == stall1) ? 1'b1 :
                     (state == stall2) ? 1'b1 :
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
                      (state == fdr) ? 1'b1 : 1'b1; 

    //assign load_addr = (state == )

endmodule: controller