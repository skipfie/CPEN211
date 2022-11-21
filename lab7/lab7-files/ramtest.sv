module ramtest(input clk, input rst_n, output reg [15:0] out_211, output reg [15:0] out_201);
    reg [3:0] state;
    // these are registers that we connect to the memory inputs
    // they are separate from any registers _inside_ the synchronous memory
    reg ram_w_en;
    reg [7:0] ram_r_addr, ram_w_addr;
    reg [15:0] ram_w_data;
    wire [15:0] ram_r_data;

    ram meminst(.clk, .ram_w_en, .ram_r_addr, .ram_w_addr, .ram_w_data, .ram_r_data);

    always_ff @(posedge clk) begin
        if (~rst_n) begin
            state <= 4'd0;
            ram_r_addr <= 16'hAA;
            ram_w_en <= 1'b0;
            ram_w_addr <= 16'hAA;
            ram_w_data <= 16'hAAAA;
        end else begin
            state <= state <= 10 ? state + 1 : state;
            case (state)
                4'd1: begin
                          // Write addr 211 and data DEAD to registers.
                          ram_w_addr <= 8'd211;
                          ram_w_data <= 16'hDEAD;
                          ram_w_en <= 1'b1;
                      end
                4'd2: begin
                          // In this cycle, our regs are outputting what we
                          // assigned in state 1, so the memory is receiving
                          // those as inputs. These inputs will be captured at
                          // the beginning of the next clock cycle (see waves).
                          // Here we just turn off the write enable.
                          ram_w_en <= 1'b0;
                      end
                4'd3: begin
                          // Whe write is taking place in this cycle.
                          // Meanwhile, we can set up another write. Actually
                          // we could have done this in the previous cycle,
                          // but we separated them for clarity.
                          ram_w_addr <= 8'd201;
                          ram_w_data <= 16'hBEEF;
                          ram_w_en <= 1'b1;
                      end
                4'd4: begin
                          ram_w_en <= 1'b0;
                      end
                4'd5: begin
                          // Write read address into our register.
                          ram_r_addr <= 8'd211;
                      end
                4'd6: begin
                          // Change the read address back so it's clear from
                          // the waves when the data for 211 is available.
                          // In this cycle ram_r_addr is outputting 211,
                          // so this is getting captured by the RAM.
                          // We'll be able to read the output in the next cycle.
                          ram_r_addr <= 8'hAA;
                      end
                4'd7: begin
                          // Read output should be available now.
                          // Write it into a register to prove we saw it.
                          // Meanwhile set up another read.
                          // Again we could have done this a cycle earlier,
                          // which would have resulted in back-to-back reads.
                          out_211 <= ram_r_data;
                          ram_r_addr <= 8'd201;
                      end
                4'd8: begin
                          // Address captured by RAM
                          ram_r_addr <= 8'hAA;
                      end
                4'd9: begin
                          // Value available
                          out_201 <= ram_r_data;
                      end
            endcase
        end
    end
endmodule: ramtest

module tb_ramtest();
    reg clk, rst_n;
    wire [15:0] out_211, out_201;
    ramtest dut(.clk, .rst_n, .out_211, .out_201);
    initial begin
        clk = 1;
        forever #5 clk = ~clk;
    end
    initial begin
        $monitor("out_211 = %x   out_201 = %x", out_211, out_201); 
        rst_n = 1'b0;
        #3;
        rst_n = 1'b1;
        #120;
        $stop;
    end
endmodule: tb_ramtest

