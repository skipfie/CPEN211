module top_module(clk,resetn,in,out);
    input clk, resetn;
    input [1:0] in;
    output [2:0] out;

    reg [2:0] state;
    reg [2:0] n_out;
    assign out = n_out;

    `define A 3'd0
    `define B 3'd1
    `define C 3'd2
    `define D 3'd3
    `define E 3'd4

    always_ff @(posedge clk) begin
        if (~resetn) 
            state <= `A;
        else begin
            case (state) 
            `A: begin
                if (in == 2'b01) begin
                    state <= `B;
                end else begin
                    state <= `A;
                end
            end
            `B: begin
                if (in == 2'b01) begin
                    state <= `E;
                end else if (in == 2'b11) begin
                    state <= `C;
                end else begin
                    state <= `B;
                end
            end
            `C: begin
                if (in == 2'b10) begin
                    state <= `D;
                end else if (in == 2'b01) begin
                    state <= `E;
                end else begin
                    state <= `C;
                end
            end
            `D: begin
                if (in == 2'b11) begin
                    state <= `A;
                end else begin
                    state <= `D;
                end
            end
            `E: begin
                if (in == 2'b11) begin
                    state <= `A;
                end else begin
                    state <= `E;
                end
            end
            default: state <= `A; // prevent latch
            endcase
        end
    end

    always_comb begin
        case (state)
            `A: n_out = 3'b000;
            `B: n_out = 3'b001;
            `C: n_out = 3'b010;
            `D: n_out = 3'b011;
            `E: n_out = 3'b100;
            default: n_out = 3'd0; //prevent latch
        endcase
    end

endmodule: top_module