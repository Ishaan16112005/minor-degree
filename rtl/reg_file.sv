module reg_file(
  input logic clk,
  input logic we,
  input logic [2:0] rs1,
  input logic [2:0] rs2,
  input logic [2:0] rd,
  input logic [15:0] wd,
  output logic [15:0] rd1,
  output logic [15:0] rd2
  );

  logic [15:0] regfile [7:0];

  initial begin 
    for(int i = 0; i < 8; i = i + 1) begin 
      regfile[i] <= 16'b0;
    end 
  end 

  assign rd1 = regfile[rs1];
  assign rd2 = regfile[rs2];

  always_ff @(posedge clk) begin 
    if (we) begin 
      regfile[rd] <= wd;
    end 
  end 

endmodule
