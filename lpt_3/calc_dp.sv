// DO NOT MODIFY THIS FILE
// DO NOT COPY THIS MODULE INTO calc.sv
module calc_dp(input clk, input en_x, input sel_x, input en_y, input sel_y, input en_op, input sel_display,  input [7:0] entry, output [7:0] display);
    reg [7:0] x;
    reg [7:0] y;
    reg op;
    assign display = sel_display ? y : x;
    wire [7:0] result = op ? (x - y) : (x + y);
    always_ff @(posedge clk) begin
        if (en_x) x <= sel_x ? entry : result;
        if (en_y) y <= sel_y ? entry : x;
        if (en_op) op <= entry[0];
    end
endmodule: calc_dp
