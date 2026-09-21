# 16-Bit Single-Cycle RISC Processor

A custom 16-bit, synthesizable, single-cycle RISC processor implemented in SystemVerilog. This project features a Harvard architecture, a custom instruction set, and a dedicated hardware stack for rapid subroutine execution. 

## Architecture Overview
* **Data & Instruction Width:** 16-bit
* **Execution:** Single-cycle datapath (verified at 10ns clock period)
* **Memory Architecture:** Harvard (Separate Instruction and Data memory interfaces)
* **Addressing:** Word-addressable (16-bit words)
* **Registers:** 8 General-Purpose Registers (16-bit)
* **Subroutine Handling:** Hardware-level Return Address Register embedded directly within the Fetch Unit to preserve general-purpose registers during `CALL`/`RET` operations.

## Instruction Set Architecture (ISA)
The CPU uses a custom 16-bit instruction format supporting both register-to-register and immediate operations.

**Standard Register Format:**
`[15:12] Opcode` | `[11] Imm_Flag = 0` | `[10:8] RD` | `[7:5] RS1` | `[4:2] RS2` | `[1:0] Pad`

**Immediate Format:**
`[15:12] Opcode` | `[11] Imm_Flag = 1` | `[10:8] RD` | `[7:5] RS1` | `[4:0] IMM5`

**Supported Opcodes:**
* **Arithmetic:** `ADD`, `SUB`, `CMP`
* **Logical:** `AND`, `OR`, `XOR`
* **Data Transfer:** `MOV`, `LD`, `ST` (Utilizes Base + Offset addressing)
* **Shifts:** `SHL`, `SHR`
* **Control Flow:** `JMP`, `JEQ`, `JNE`, `CALL`, `RET`

## Module Structure
* `cpu_pkg.sv`: Defines the `opcode_t` enum and global ISA constants.
* `fetch.sv`: Manages the Program Counter (PC), jump/branch multiplexing, and the hardware return address register.
* `reg_file.sv`: 8x16-bit general-purpose register file featuring two asynchronous read ports and one synchronous write port.
* `alu.sv`: Executes arithmetic, logical, and shift operations, and generates a dynamic `zero_flag` for conditional branching.
* `extend.sv`: 5-bit to 16-bit immediate extension unit (supports dynamic switching between zero and sign extension).
* `dmem.sv`: Synchronous write, asynchronous read Data Memory block.
* `control_unit.sv`: Purely combinational instruction decoder that orchestrates all datapath routing and write-enable signals.
* `cpu_top.sv`: Top-level structural wrapper that wires the datapath components together.

## Simulation & Testing
This design is verified using **Icarus Verilog (iverilog)** and **GTKWave**. The included testbench (`tb_cpu.sv`) contains a simulated Instruction ROM running a machine code loop to prove single-cycle timing resolution.

**1. Compilation**
Ensure your folder structure separates `rtl` and `tb` files, then compile using the SystemVerilog 2012 standard:
```bash
iverilog -g2012 rtl/cpu_pkg.sv rtl/alu.sv rtl/control_unit.sv rtl/dmem.sv rtl/extend.sv rtl/fetch.sv rtl/reg_file.sv rtl/cpu_top.sv tb/tb_cpu.sv
