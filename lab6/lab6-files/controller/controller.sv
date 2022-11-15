module controller(input clk, input rst_n, input start,
                  input [2:0] opcode, input [1:0] ALU_op, input [1:0] shift_op,
                  input Z, input N, input V,
                  output waiting,
                  output [1:0] reg_sel, output [1:0] wb_sel, output w_en,
                  output en_A, output en_B, output en_C, output en_status,
                  output sel_A, output sel_B);
	// define the name of each state


  // for state transition
  always_ff @(posedge clk) begin
        if (~rst_n) state <= `one; //active low reset
        else begin
            case (state)



            endcase
        end

  end 

  // for output logic
    always_comb begin
        case (state)

        
        endcase
    end

endmodule: controller
