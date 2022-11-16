`timescale 1ns / 1ps

module riscv_pipeline_core#(
    parameter WORD_WIDTH        = 32,
    parameter REG_ADDR_WIDTH    = 5,
    parameter CTRL_WIDTH        = 10,
    parameter CTRL_WIDTH_2      = 4,
    parameter CTRL_WIDTH_3      = 3
)(
    // Clocks and resets
    input   logic                       clk,
    input   logic                       nrst,
    
    // Signals for the instruction memory
    input   logic [WORD_WIDTH-1:0]      imem_data,//done
    output  logic [WORD_WIDTH-1:0]      imem_addr,//done
    
    // Signals for the data memory
    output  logic [WORD_WIDTH-1:0]      dmem_addr, //done
    output  logic [WORD_WIDTH-1:0]      dmem_data_in, //done
    output  logic                       dmem_wr_en,//done
    input   logic [WORD_WIDTH-1:0]      dmem_data_out,//done
    
    // Output signals meant for monitoring control
    output  logic                       monitor_ctrl_reg_wr_en_d,//done
    output  logic [1:0]                 monitor_ctrl_result_src_d,//done
    output  logic                       monitor_ctrl_reg_wr_en_e,//
    output  logic [1:0]                 monitor_ctrl_result_src_e,//
    output  logic                       monitor_ctrl_reg_wr_en_m,//
    output  logic [1:0]                 monitor_ctrl_result_src_m,//
    output  logic                       monitor_ctrl_reg_wr_en_w,//done
    
    // Output signals meant for hazard control
    output  logic [1:0]                 monitor_hazard_fwd_src_1,//done
    output  logic [1:0]                 monitor_hazard_fwd_src_2,//done
    output  logic                       monitor_hazard_stall_f,//done
    output  logic                       monitor_hazard_stall_d, //done
    output  logic                       monitor_hazard_flush_d,//done
    output  logic                       monitor_hazard_flush_e,//done

    // Output signals meant for monitoring data
    output  logic [WORD_WIDTH-1:0]      monitor_pc_f,//done
    output  logic [WORD_WIDTH-1:0]      monitor_pc_plus4_f,//done
    output  logic [WORD_WIDTH-1:0]      monitor_pc_d,//done
    output  logic [WORD_WIDTH-1:0]      monitor_pc_plus4_d,//
    output  logic [REG_ADDR_WIDTH-1:0]  monitor_reg_src_1_d,//
    output  logic [REG_ADDR_WIDTH-1:0]  monitor_reg_src_2_d,//
    output  logic [REG_ADDR_WIDTH-1:0]  monitor_reg_dst_d,//
    output  logic [WORD_WIDTH-1:0]      monitor_pc_plus4_e,//
    output  logic [REG_ADDR_WIDTH-1:0]  monitor_reg_src_1_e,//
    output  logic [REG_ADDR_WIDTH-1:0]  monitor_reg_src_2_e,//
    output  logic [REG_ADDR_WIDTH-1:0]  monitor_reg_dst_e,//
    output  logic [WORD_WIDTH-1:0]      monitor_alu_result_e,//
    output  logic [WORD_WIDTH-1:0]      monitor_pc_plus4_m,//
    output  logic [REG_ADDR_WIDTH-1:0]  monitor_reg_dst_m,//
    output  logic [WORD_WIDTH-1:0]      monitor_alu_result_m,//done
    output  logic [REG_ADDR_WIDTH-1:0]  monitor_reg_dst_w,//done
    output  logic [WORD_WIDTH-1:0]      monitor_result_w//done
);


    wire                                     ALUSrcD, MemWriteD, BranchD, JumpD;
    wire                                     PCSrcE, ZeroE;
    wire    [1:0]                            ImmSrcD;
    wire    [2:0]                            ALUControlD, funct3;
    wire    [6:0]                            opcode, funct7;
    wire    [WORD_WIDTH-1:0]                 PCFp;
    wire    [WORD_WIDTH-1:0]                 InstD, RD1D, RD2D, ImmExtD;
    wire    [WORD_WIDTH-1:0]                 PCE, RD1E, RD2E, SrcAE, WriteDataE, SrcBE, ImmExtE;
    wire    [WORD_WIDTH-1:0]                 ALUResultW, ReadDataW, PCPlus4W, ResultW;
    wire    [11:0]                           control_line;
    wire    [CTRL_WIDTH-1:0]                 CtrlE;
    wire    [CTRL_WIDTH_2-1:0]               CtrlM;
    wire    [CTRL_WIDTH_3-1:0]               CtrlW;
    
    assign  dmem_addr                    =   monitor_alu_result_m;
    assign  dmem_wr_en                   =   CtrlM[0];
    assign  imem_addr                    =   monitor_pc_f;
    assign  control_line                 =   {monitor_ctrl_reg_wr_en_d, monitor_ctrl_result_src_d, MemWriteD, JumpD, BranchD, ALUControlD, ALUSrcD, ImmSrcD};    
    assign  monitor_ctrl_reg_wr_en_e     =   CtrlE[9];
    assign  monitor_ctrl_result_src_e    =   CtrlE[8:7];
    assign  monitor_ctrl_reg_wr_en_m     =   CtrlM[3];
    assign  monitor_ctrl_result_src_m    =   CtrlM[2:1];
    assign  monitor_ctrl_reg_wr_en_w     =   CtrlW[2];

    //FETCH
    PCF_mux PC_mux1(
        .PCPlus4F       (monitor_pc_plus4_f             ),
        .PCE            (PCE                            ),    
        .ImmExtE        (ImmExtE                        ),
        .PCSrcE         (PCSrcE                         ), 
        .PCFp           (PCFp                           )
    );
    
    risc_pc PC1(
        .clk            (clk                            ),
        .nrst           (nrst                           ),
        .dis            (monitor_hazard_stall_f         ), 
        .PCFp           (PCFp                           ),
        .PCF            (monitor_pc_f                   ),
        .PCPlus4F       (monitor_pc_plus4_f             )
    );
    
    //DECODE
    Decode_stage decode_pipeline(
        .clk            (clk                            ),
        .nrst           (nrst                           ),
        .imem_data      (imem_data                      ),
        .PCF            (monitor_pc_f                   ),
        .PCPlus4F       (monitor_pc_plus4_f             ),
        .dis            (monitor_hazard_stall_d         ),
        .clr            (monitor_hazard_flush_d         ),
        .InstD          (InstD                          ),
        .PCD            (monitor_pc_d                   ),
        .PCPlus4D       (monitor_pc_plus4_d             )
    );
    
    Inst_slicer Slicer1(
        .inst           (InstD                          ),
        .opcode         (opcode                         ),
        .funct3         (funct3                         ),
        .funct7         (funct7                         ),
        .Rs1D           (monitor_reg_src_1_d            ),
        .Rs2D           (monitor_reg_src_2_d            ),
        .RdD            (monitor_reg_dst_d              )
    );    
    
    risc_pipeline_controller ControllaControlla(    
        .opcode         (opcode                         ),
        .funct3         (funct3                         ),
        .funct7         (funct7                         ),
        .RegWriteD      (monitor_ctrl_reg_wr_en_d       ),
        .ALUSrcD        (ALUSrcD                        ),
        .ALUControlD    (ALUControlD                    ),
        .ImmSrcD        (ImmSrcD                        ),
        .MemWriteD      (MemWriteD                      ),
        .ResultSrcD     (monitor_ctrl_result_src_d      ),
        .JumpD          (JumpD                          ),
        .BranchD        (BranchD                        )
    );
    
    riscv_reg RegisterFile(
        .clk            (clk                            ),
        .nrst           (nrst                           ),
        .wr_en          (monitor_ctrl_reg_wr_en_w       ),
        .wr_addr        (monitor_reg_dst_w              ),
        .wr_data        (ResultW                        ),
        .rd_addrA       (monitor_reg_src_1_d            ),
        .rd_addrB       (monitor_reg_src_2_d            ),
        .rd_dataA       (RD1D                           ),
        .rd_dataB       (RD2D                           )
    );
    
    risc_imm ImmGenerator(
        .imm_src        (ImmSrcD                        ),      
        .imm_input      (InstD                          ),                    
        .imm_output     (ImmExtD                        )
    );
    
    //EXECUTE
    Execute_stage execute_pipeline(
        .clk            (clk                            ),
        .nrst           (nrst                           ),
        .RD1D           (RD1D                           ),
        .RD2D           (RD2D                           ),
        .PCD            (monitor_pc_d                   ),
        .Rs1D           (monitor_reg_src_1_d            ),
        .Rs2D           (monitor_reg_src_2_d            ),
        .RdD            (monitor_reg_dst_d              ),
        .ImmExtD        (ImmExtD                        ),
        .PCPlus4D       (monitor_pc_plus4_d             ),
        .CtrlD          (control_line                   ),
        .clr            (monitor_hazard_flush_e         ),
        .RD1E           (RD1E                           ),
        .RD2E           (RD2E                           ),
        .PCE            (PCE                            ),
        .Rs1E           (monitor_reg_src_1_e            ),
        .Rs2E           (monitor_reg_src_2_e            ),
        .RdE            (monitor_reg_dst_e              ),
        .ImmExtE        (ImmExtE                        ),
        .PCPlus4E       (monitor_pc_plus4_e             ),
        .CtrlE          (CtrlE                          )
    );
    
    SrcAE_mux SrcAMUX(
        .RD1E           (RD1E                           ),
        .ResultW        (ResultW                        ),
        .ALUResultM     (monitor_alu_result_m           ),
        .ForwardAE      (monitor_hazard_fwd_src_1       ),
        .SrcAE          (SrcAE                          )
    );
    
    SrcBE_mux SrcBMUX(
        .RD2E           (RD2E                           ),
        .ResultW        (ResultW                        ),
        .ALUResultM     (monitor_alu_result_m           ),
        .ForwardBE      (monitor_hazard_fwd_src_2       ),
        .SrcBE          (WriteDataE                     )
    );
    
    ALUSrc_mux ALUSrcMUX(
        .WriteDataE     (WriteDataE                     ),
        .ImmExtE        (ImmExtE                        ),
        .ALUSrcE        (CtrlE[0]                       ),
        .SrcBE          (SrcBE                          )
    );
        
    risc_alu ALU1(
        .operandA       (SrcAE                          ),
        .operandB       (SrcBE                          ),
        .alu_op         (CtrlE[3:1]                     ),
        .alu_out        (monitor_alu_result_e           ),
        .zero           (ZeroE                          )
    );
        
    PCSrcE_logic PCSrcLogicBlock(
        .JumpE          (CtrlE[5]                       ),
        .BranchE        (CtrlE[4]                       ),
        .ZeroE          (ZeroE                          ),
        .PCSrcE         (PCSrcE                         )
    );
    
    //MEMORY ACCESS
    Mem_stage memory_pipeline(
        .clk            (clk                            ), 
        .nrst           (nrst                           ),
        .ALUResultE     (monitor_alu_result_e           ),
        .WriteDataE     (WriteDataE                     ),
        .RdE            (monitor_reg_dst_e              ),
        .PCPlus4E       (monitor_pc_plus4_e             ),
        .CtrlE          (CtrlE                          ),
        .ALUResultM     (monitor_alu_result_m           ),
        .WriteDataM     (dmem_data_in                   ),
        .RdM            (monitor_reg_dst_m              ),
        .PCPlus4M       (monitor_pc_plus4_m             ),
        .CtrlM          (CtrlM                          )
    );   
    
    //WRITE BACK
    WriteBack_stage writeback_pipeline(
        .clk            (clk                            ),
        .nrst           (nrst                           ),
        .ALUResultM     (monitor_alu_result_m           ),
        .dmem_data_out  (dmem_data_out                  ),
        .RdM            (monitor_reg_dst_m              ),
        .PCPlus4M       (monitor_pc_plus4_m             ),
        .CtrlM          (CtrlM                          ),
        .ALUResultW     (monitor_result_w               ),
        .ReadDataW      (ReadDataW                      ),
        .RdW            (monitor_reg_dst_w              ),
        .PCPlus4W       (PCPlus4W                       ),
        .CtrlW          (CtrlW                          )
    );
        
    ResultW_mux MemToRegMUX(
        .ALUResultW     (monitor_result_w               ),
        .ReadDataW      (ReadDataW                      ),
        .PCPlus4W       (PCPlus4W                       ),
        .ResultSrcW     (CtrlW[1:0]                     ),
        .ResultW        (ResultW                        )
    );
    
    //HAZARD UNIT
    HAZARD_control HazardUnit(
        .Rs1D           (monitor_reg_src_1_d            ),    
        .Rs2D           (monitor_reg_src_2_d            ),
        .Rs1E           (monitor_reg_src_1_e            ),
        .Rs2E           (monitor_reg_src_2_e            ),
        .RdE            (monitor_reg_dst_e              ),
        .PCSrcE         (PCSrcE                         ),
        .ResultSrcE0    (monitor_ctrl_result_src_e[0]   ),
        .RdM            (monitor_reg_dst_m              ),
        .RegWriteM      (monitor_ctrl_reg_wr_en_m       ),
        .RdW            (monitor_reg_dst_w              ),
        .RegWriteW      (monitor_ctrl_reg_wr_en_w       ),
        .StallF         (monitor_hazard_stall_f         ),
        .StallD         (monitor_hazard_stall_d         ),
        .FlushD         (monitor_hazard_flush_d         ),
        .FlushE         (monitor_hazard_flush_e         ),
        .ForwardAE      (monitor_hazard_fwd_src_1       ),
        .ForwardBE      (monitor_hazard_fwd_src_2       )
    );

endmodule
