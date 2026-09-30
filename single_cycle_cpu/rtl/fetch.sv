module fetch(
  input logic clk,
  input logic reset,
  input logic jump_en,
  input logic call_en,
  input logic ret_en,
  input logic [15:0] jump_target,
  output logic [15:0] pc
  );

  logic [15:0] next_pc;
  logic [15:0] return_addr;

  always_comb begin 
    if (ret_en) begin 
      next_pc = return_addr;
    end else if (jump_en || call_en) begin 
      next_pc = jump_target;
    end else begin 
      next_pc = pc + 1;
    end 
  end 

  always_ff @(posedge clk or posedge reset) begin 
    if(reset) begin 
      pc <= 16'b0;
      return_addr <=  16'b0;
    end else begin 
      pc <= next_pc;
      if (call_en) begin 
        return_addr <= pc+1;
      end 
    end 
  end 
endmodule 

