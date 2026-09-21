import cpu_pkg::*;

module control (
    input  logic [3:0] opcode,
    input  logic       imm_flag,
    input  logic       zero_flag,
    output logic       jump_en,
    output logic       call_en,
    output logic       ret_en,
    output logic       reg_we,
    output logic [3:0] alu_op,
    output logic       alu_src_sel,
    output logic       sign_ext_en,
    output logic       mem_write,
    output logic       mem_to_reg
);

    always_comb begin
        jump_en     = 1'b0;
        call_en     = 1'b0;
        ret_en      = 1'b0;
        reg_we      = 1'b0;
        mem_write   = 1'b0;
        mem_to_reg  = 1'b0;
        alu_src_sel = imm_flag;
        sign_ext_en = 1'b0;
        alu_op      = opcode;
        
        case (opcode)
            
            OP_ADD, OP_SUB: begin
                reg_we      = 1'b1;
                sign_ext_en = 1'b1;
            end

            OP_AND, OP_OR, OP_XOR: begin
                reg_we      = 1'b1;
                sign_ext_en = 1'b0;
            end

            OP_SHL, OP_SHR: begin
                reg_we      = 1'b1;
                sign_ext_en = 1'b0;
            end

            OP_CMP: begin
                reg_we      = 1'b0;
                sign_ext_en = 1'b1;
                alu_op      = OP_SUB;
            end

            OP_LD: begin
                reg_we      = 1'b1;
                mem_to_reg  = 1'b1;
                sign_ext_en = 1'b1;
                alu_op      = OP_ADD;
            end

            OP_ST: begin
                mem_write   = 1'b1;
                sign_ext_en = 1'b1;
                alu_op      = OP_ADD;
            end

            OP_JMP: begin
                jump_en     = 1'b1;
                sign_ext_en = 1'b1;
                alu_op      = OP_ADD;
            end

            OP_JEQ: begin
                jump_en     = zero_flag;
                sign_ext_en = 1'b1;
                alu_op      = OP_ADD;
            end

            OP_JNE: begin
                jump_en     = ~zero_flag;
                sign_ext_en = 1'b1;
                alu_op      = OP_ADD;
            end

            OP_CALL: begin
                call_en     = 1'b1;
                sign_ext_en = 1'b1;
                alu_op      = OP_ADD;
            end

            OP_RET: begin
                ret_en      = 1'b1;
            end
            
            default: ;
        endcase
    end

endmodule
