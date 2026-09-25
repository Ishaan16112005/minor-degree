import cpu_pkg::*;

module cpu_top (
    input  logic        clk,
    input  logic        reset,
    output logic [15:0] pc_out,
    input  logic [15:0] instruction_in
);

    
    // Instruction slicing
    logic [3:0]  opcode;
    logic        imm_flag;
    logic [2:0]  rd;
    logic [2:0]  rs1;
    logic [2:0]  rs2;
    logic [4:0]  imm5;

    // Control signals
    logic        jump_en;
    logic        call_en;
    logic        ret_en;
    logic        reg_we;
    opcode_t     alu_op;
    logic        alu_src_sel;
    logic        sign_ext_en;
    logic        mem_write;
    logic        mem_to_reg;

    // Datapath wires
    logic [15:0] rd1;
    logic [15:0] rd2;
    logic [15:0] imm16;
    logic [15:0] alu_b;
    logic [15:0] alu_result;
    logic        alu_zero;
    logic [15:0] dmem_rd;
    logic [15:0] reg_wd;

   
    assign opcode   = instruction_in[15:12];
    assign imm_flag = instruction_in[11];
    assign rd       = instruction_in[10:8];
    assign rs1      = instruction_in[7:5];
    assign rs2      = instruction_in[4:2];
    assign imm5     = instruction_in[4:0];

  
    assign alu_b = alu_src_sel ? imm16 : rd2;

   
    assign reg_wd = mem_to_reg ? dmem_rd : alu_result;

  
    control u_control (
        .opcode      (opcode),
        .imm_flag    (imm_flag),
        .zero_flag   (alu_zero),
        .jump_en     (jump_en),
        .call_en     (call_en),
        .ret_en      (ret_en),
        .reg_we      (reg_we),
        .alu_op      (alu_op),
        .alu_src_sel (alu_src_sel),
        .sign_ext_en (sign_ext_en),
        .mem_write   (mem_write),
        .mem_to_reg  (mem_to_reg)
    );

    fetch u_fetch (
        .clk         (clk),
        .reset       (reset),
        .jump_en     (jump_en),
        .call_en     (call_en),
        .ret_en      (ret_en),
        .jump_target (alu_result), // ALU calculates PC + Offset
        .pc          (pc_out)
    );

    regfile u_regfile (
        .clk         (clk),
        .we          (reg_we),
        .rs1         (rs1),
        .rs2         (rs2),
        .rd          (rd),
        .wd          (reg_wd),
        .rd1         (rd1),
        .rd2         (rd2)
    );

    extend u_extend (
        .imm5        (imm5),
        .sign_ext_en (sign_ext_en),
        .imm16       (imm16)
    );

    alu u_alu (
        .a           (rd1),
        .b           (alu_b),
        .alu_op      (alu_op),
        .result      (alu_result),
        .zero_flag   (alu_zero)
    );

    dmem u_dmem (
        .clk         (clk),
        .mem_write   (mem_write),
        .addr        (alu_result), // ALU calculates Base + Offset
        .wd          (rd2),        // Store instruction saves Register 2
        .rd          (dmem_rd)
    );

endmodule
