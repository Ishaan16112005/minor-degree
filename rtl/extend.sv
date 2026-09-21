module extend(
  input logic [4:0] imm5,
  input logic sign_ext_en,
  output logic [15:0] imm16
  );
  
  logic sign_bit;
  assign sign_bit = imm5[4];

  always_comb begin
    if(sign_ext_en) begin 
      imm16 = {{11{imm5[4]}}, imm5};
    end else begin 
      imm16 = {11'b0, imm5};
    end
  end
endmodule 
