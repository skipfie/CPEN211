// adapted from: Intel Quartus Prime Standard Edition User Guide, 18.1, sec. 2.4.1

// DO NOT MODIFY THIS FILE

module ram(input clk, input ram_w_en, input [7:0] ram_r_addr, input [7:0] ram_w_addr,
           input [15:0] ram_w_data, output reg [15:0] ram_r_data);
    reg [15:0] m[255:0];
    always_ff @(posedge clk) begin
        if (ram_w_en) m[ram_w_addr] <= ram_w_data;
        ram_r_data <= m[ram_r_addr];
    end
    initial $readmemb("ram_init.txt", m);
endmodule: ram
