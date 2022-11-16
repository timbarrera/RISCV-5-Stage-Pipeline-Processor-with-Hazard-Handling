`timescale 1ns / 1ps

module riscv_core#(
    parameter WORD_WIDTH        = 32,
    parameter REG_ADDR_WIDTH    = 5
)(
    // Clocks and resets
    input   logic clk,
    input   logic nrst,
    
    // Signals for the instruction memory
    input   logic [WORD_WIDTH-1:0] imem_data,
    output  logic [WORD_WIDTH-1:0] imem_addr,
    
    // Signals for the data memory
    output  logic [WORD_WIDTH-1:0] dmem_addr,
    output  logic [WORD_WIDTH-1:0] dmem_data_in,
    output  logic                  dmem_wr_en,
    input   logic [WORD_WIDTH-1:0] dmem_data_out,
    
    // Output signals meant for monitoring
    output  logic [6:0]                 opcode,   
    output  logic [2:0]                 funct3, 
    output  logic [6:0]                 funct7, 
    output  logic [WORD_WIDTH-1:0]      imm_ext,
    output  logic [REG_ADDR_WIDTH-1:0]  reg_src1,
    output  logic [REG_ADDR_WIDTH-1:0]  reg_src2,
    output  logic [REG_ADDR_WIDTH-1:0]  reg_dst,
    output  logic [WORD_WIDTH-1:0]      wr_data,
    output  logic [WORD_WIDTH-1:0]      rd_dataA,
    output  logic [WORD_WIDTH-1:0]      rd_dataB,
    output  logic                       wr_en,
    output  logic                       alu_src,
    output  logic                       pc_src,
    output  logic [2:0]                 alu_op,
    output  logic [1:0]                 imm_src,
    output  logic                       mem_write,
    output  logic [1:0]                 mem_to_reg,
    output  logic [WORD_WIDTH-1:0]      alu_out,
    output  logic                       zero
);

    logic [31:0] opB; 
    
    risc_pc ProgramCounter(
        .clk(clk),
        .nrst(nrst),
        .pc_src(pc_src),
        .addr_offset(imm_ext),
        .addr_out(imem_addr)         
    );
    
    risc_alu ALU(
        .operandA(rd_dataA),
        .operandB(opB),
        .alu_op(alu_op),
        .alu_out(alu_out),
        .zero(zero)
    );
    
    risc_imm ImmediateGen(
        .imm_src(imm_src),
        .imm_input(imem_data),
        .imm_output(imm_ext)
    );
    
    risc_comb_controller Controlla(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .zero(zero),
        .wr_en(wr_en),
        .alu_src(alu_src),
        .alu_op(alu_op),
        .pc_src(pc_src),
        .imm_src(imm_src),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg)
    );
    
    riscv_reg RegisterFile(
        .clk(clk),
        .nrst(nrst),
        .wr_en(wr_en),
        .wr_addr(reg_dst),
        .wr_data(wr_data),
        .rd_addrA(reg_src1),
        .rd_addrB(reg_src2),
        .rd_dataA(rd_dataA),
        .rd_dataB(rd_dataB)
    );
    
    
    
    
    assign opcode = imem_data[6:0];
    assign funct3 = imem_data[14:12];
    assign funct7 = imem_data[31:25];
    assign dmem_addr = alu_out;
    assign dmem_data_in = rd_dataB;
    assign dmem_wr_en = mem_write;
    assign reg_src1 = imem_data[19:15];
    assign reg_src2 = imem_data[24:20];
    assign reg_dst = imem_data[11:7];
    
    always_comb begin //mem_to_reg_mux
        case(mem_to_reg)
            2'b00: wr_data <= alu_out;
            2'b01: wr_data <= dmem_data_out;
            2'b10: wr_data <= imem_addr + 32'd4;
            default: wr_data <= alu_out;
        endcase
    end
    

    
    always_comb //alu_src_mux
        case(alu_src)
            1'b0: opB <= rd_dataB;
            1'b1: opB <= imm_ext;
            default: opB <= rd_dataB;
        endcase

	// Do not change anything from the riscv core ports.
	// Insert your code in here.
	// This is where you place all other instances, wires, and MUXes.
	// You are allowed to use the predefined output signals as wires for monitoring.
	// Make sure these signals are connected to the output.
	
endmodule
