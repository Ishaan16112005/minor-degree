module tb_cpu;
    logic        clk;
    logic        reset;
    logic [15:0] pc_out;
    logic [15:0] instruction_in;

    // 16-slot Instruction ROM for the test program
    logic [15:0] rom [0:15];

    // Continuously fetch instruction based on the current PC
    assign instruction_in = rom[pc_out[3:0]];

    // Instantiate your CPU Top Level
    cpu_top u_cpu (
        .clk            (clk),
        .reset          (reset),
        .pc_out         (pc_out),
        .instruction_in (instruction_in)
    );

    // Clock Generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Generate waveform file for GTKWave
        $dumpfile("cpu_waves.vcd");
        $dumpvars(0, tb_cpu);

        // ------------------------------------------------------------------
        // MACHINE CODE PROGRAM
        // Format: [15:12] OPCODE | [11] IMM_FLAG | [10:8] RD | [7:5] RS1 | [4:0] IMM5 
        //         [15:12] OPCODE | [11] IMM_FLAG | [10:8] RD | [7:5] RS1 | [4:2] RS2 | [1:0] X
        // ------------------------------------------------------------------
        
        // PC 0: MOV R1, 5 (Load immediate 5 into Register 1)
        // OP_MOV (0010), Imm=1, RD=001, RS1=000, IMM=00101
        rom[0] = 16'b0010_1_001_000_00101; 
        
        // PC 1: MOV R2, 10 (Load immediate 10 into Register 2)
        // OP_MOV (0010), Imm=1, RD=010, RS1=000, IMM=01010
        rom[1] = 16'b0010_1_010_000_01010;
        
        // PC 2: ADD R3, R1, R2 (Add R1 and R2, store in R3)
        // OP_ADD (0000), Imm=0, RD=011, RS1=001, RS2=010, Pad=00
        rom[2] = 16'b0000_0_011_001_010_00; 

        // PC 3: JMP 2 (Jump back to address 2 to repeat the ADD forever)
        // OP_JMP (1011), Imm=1, RD=000, RS1=000(Assuming R0 is 0), IMM=00010
        rom[3] = 16'b1011_1_000_000_00010; 

        // ------------------------------------------------------------------
        // TEST SEQUENCE
        // ------------------------------------------------------------------
        clk = 0;
        reset = 1; // Hold CPU in reset
        
        #15;
        reset = 0; // Release reset, start execution
        
        #60;       // Let the CPU run for 6 clock cycles
        
        $display("Simulation complete. Open cpu_waves.vcd in GTKWave.");
        $finish;
    end
endmodule
