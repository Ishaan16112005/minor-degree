module extend(
  input  logic [4:0]  imm5,
  input  logic        sign_ext_en,
  output logic [15:0] imm16
);

  // A continuous assignment prevents the Icarus Verilog sensitivity list bug
  assign imm16 = sign_ext_en ? {{11{imm5[4]}}, imm5} : {11'b0, imm5};

endmodule
