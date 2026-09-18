import cpu_pkg::* ;

module alu(
  input logic [15:0] a,
  input logic [15:0] b,
  input opcode_t alu_ctrl,
  output logic [15:0] result,
  output logic zero
  );

  always_comb begin 
    result = 16'b0;
    zero = 1'b0;

    case(alu_ctrl) 
      OP_ADD: result = a + b;
      OP_SUB:  result = a - b;
      OP_MOV:  result = b;       
      OP_AND:  result = a & b;
      OP_OR:   result = a | b;
      OP_XOR:  result = a ^ b;
      OP_CMP:  result = a - b;  
      OP_SHL:  result = a << (b & 16'h000F); 
      OP_SHR:  result = a >> (b & 16'h000F);
      OP_LD, OP_ST: result = a + b;

      default: result = 16'b0;
    endcase 
    zero = (result == 16'b0) ? 1'b1 : 1'b0;
  end 
endmodule
