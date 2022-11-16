# RISCV-5-Stage-Pipeline-Processor-with-Hazard-Handling
- realized in system verilog
- supports 32-bit riscv instructions 
- 32 general use registers with 32-bit data
- instructions: ADD, SUB, AND, OR, SLL, SRL, ADDI, ANDI, ORI, SLLI, SRLI, LW, SW, BEQ, BNE, JAL
- hazard controller supports forwarding for RAW hazards, stalling for lw, flushing for branching and jumping

Changes to single cycle modules are referring to previous single cycle processor modules found here: https://github.com/timbarrera/Single-Cycle-RISCV-Processor.git

some notes on modules:

Unchanged modules from single cycle
- Register File: riscv_reg.sv
- Immediate Generator: riscv_imm
- ALU: risc_alu.sv
- ALU Source MUX: ALUSrc_mux.sv (only made into separate module)
- Mem to Register MUX: ResultW_mux.sv (only made into separate module)

Core
riscv_pipeline_core.sv - topmost, all modules instantiated here (except memories and tb)

Testbench
tb_riscv_core_pipeline.sv - main testbench for core module

Pipeline Registers
- (risc_pc.sv), Decode_stage.sv, Execute_stage.sv, Mem_stage.sv, WriteBack_stage.sv
- all stages have inputs and outputs according to datapath
- control signals are received as an array of control signals and are passed to the next register by truncating the signals that won't be needed anymore
- decode and execute stage registers have a clear signal for flushing. all outputs are to be zero when hazard unit detects a lw stall or branch or jump
- instruction fetch (PC) and decode stage register have negetive-enable signal dis. when enable is 0 (or dis is 1) the data in the register will not update. used for stalling

Program Counter
risc_pc.sv - removed built in mux from single cycle, simply updates to the next address when enabled
- added built in adder, outputs PC+4 to be passed onto the decode stage

Instruction Slicer
Inst_slicer.sv - slices intruction; when there is no rs2 in the instruction encoding (lw type or i type), rs2 is hardcoded to 0

Controller
risc_controller_pipeline.sv 
- rearranged control signals such that it matches the arrangement of signals in the datapath (ImmSrcD is bit 1 and 0)
- removed PCSrc from single cycle; PCSrc is now a separate logic determined in the execute stage as PCSrcE
- added two signals: branch and jump, determined by opcode

Hazard Unit
HAZARD_control.sv - inputs and outputs is same in datapath
- control logic the same in spec sheet except stalling would also require that either rs1D or rs2D is not 0

MUXs and logics
- MUXs to support forwarding: SrcAE_mux.sv, SrcBE_mux.sv
- MUXs to support branching or jumping: PCF_mux.sv; PCF_mux.sv has built in adder for target PC in branching or jumping 







