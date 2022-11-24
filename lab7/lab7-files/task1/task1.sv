module task1(input clk, input rst_n, input [7:0] start_pc, output[15:0] out);
    // to ram
    wire [7:0] ram_addr;

    ram ram(.clk(clk), .ram_w_en(ram_w_en), 
            .ram_r_addr(ram_addr), .ram_w_addr(ram_addr), 
            .ram_w_data(ram_w_data), .ram_r_data(ram_r_data));
            
endmodule: task1
