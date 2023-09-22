module calc(input clk, input rst_n, input [4:0] instr, output [7:0] display);
    reg en_x, en_y, sel_x, sel_y, en_op, sel_display;
    reg [7:0] entry;

    calc_dp datapath(.clk(clk), .en_x(en_x), .sel_x(sel_x),
                     .en_y(en_y), .sel_y(sel_y), .en_op(en_op),
                     .sel_display(sel_display),
                     .entry(entry),
                     .display(display));

    enum reg [2:0] {rst1, fo, so, add, sub, eq} state;

    assign sel_display = (state == so) ? 1'b1 : 1'b0;

    always_comb begin
        case (state)
        rst1: begin // write 0 to x and y
            en_x = 1'b1;
            en_y = 1'b1;
            sel_x = 1'b1;
            sel_y = 1'b1;
            en_op = 1'b0;
            entry = 8'd0; 
        end

        fo: begin
            if (instr[4] == 1'b1) en_x = 1'b1;
            else en_x = 1'b0;
            en_y = 1'b0;
            sel_x = 1'b1;
            sel_y = 1'b1;
            en_op = 1'b0;
            entry = {4'b0, instr[3:0]};
        end

        so: begin
            en_x = 1'b0;
            if (instr[4] == 1'b1) en_y = 1'b1;
            else en_y = 1'b0;
            sel_x = 1'b1;
            sel_y = 1'b1;
            en_op = 1'b0;
            entry = {4'd0, instr[3:0]};
        end

        add: begin
            en_x = 1'b0;
            en_y = 1'b1;
            sel_x = 1'b1;
            sel_y = 1'b0;
            en_op = 1'b1;
            entry = {7'd0, 1'b0};
        end

        sub: begin
            en_x = 1'b0;
            en_y = 1'b1;
            sel_x = 1'b1;
            sel_y = 1'b0;
            en_op = 1'b1;
            entry = {7'd0, 1'b1};
        end

        eq: begin
            en_x = 1'b1;
            en_y = 1'b0;
            sel_x = 1'b0;
            sel_y = 1'b1;
            en_op = 1'b0;
            entry = 8'd0;
        end
        endcase
    end

    always_ff @(posedge clk) begin
        if (~rst_n) state <= rst1;
        else begin
            case (state)
            rst1: state <= fo;

            fo: begin
                if (instr == 5'b00010) state <= add;
                else if (instr == 5'b00011) state <= sub;
                else state <= fo;
            end

            so: begin
                if (instr == 5'b00001) state <= eq;
                else if (instr == 5'b00010) state <= add;
                else if (instr == 5'b00011) state <= sub;
                else state <= so;
            end
            
            add: state <= so;
            sub: state <= so;
            eq: state <= fo;
            endcase
        end
    end

endmodule: calc
