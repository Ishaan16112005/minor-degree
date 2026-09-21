module dmem #(
  parameter depth = 65536
  )(
    input logic clk,
    input logic mem_write,
    input logic [15:0] addr,
    input logic [15:0] wd,
    output logic [15:0] rd
  );

  logic [15:0] mem [0:depth-1];

  assign rd = mem[addr];

  always_ff @(posedge clk) begin
    if(mem_write) begin 
      mem[addr] <= wd;
    end 
  end
endmodule
