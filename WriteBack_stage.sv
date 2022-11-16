`timescale 1ns / 1ps

module WriteBack_stage(
    input                   clk,
    input                   nrst,
    input           [31:0]  ALUResultM,
    input           [31:0]  dmem_data_out,
    input           [4:0]   RdM,
    input           [31:0]  PCPlus4M,
    input           [3:0]   CtrlM,
    output logic    [31:0]  ALUResultW,
    output logic    [31:0]  ReadDataW,
    output logic    [4:0]   RdW,
    output logic    [31:0]  PCPlus4W,
    output logic    [2:0]   CtrlW
    );
    
    wire [2:0] control_line;
    assign control_line = CtrlM[3:1];
    
    always_ff@(posedge clk or negedge nrst) begin
        if(!nrst) begin
            ALUResultW  <= 32'b0;  
            ReadDataW   <= 32'b0;
            RdW         <= 5'b0;
            PCPlus4W    <= 32'b0;
            CtrlW       <= 3'b0;
        end   
        else begin
            ALUResultW  <=  ALUResultM;  
            ReadDataW   <=  dmem_data_out;
            RdW         <=  RdM;
            PCPlus4W    <=  PCPlus4M;
            CtrlW       <=  control_line;
        end 
    end
    
endmodule
