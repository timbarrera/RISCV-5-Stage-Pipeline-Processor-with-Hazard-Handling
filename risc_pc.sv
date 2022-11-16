`timescale 1ns / 1ps

module risc_pc(
    input                   clk,
    input                   nrst,
    input                   dis,
    input           [31:0]  PCFp,
    output logic    [31:0]  PCF,
    output logic    [31:0]  PCPlus4F 
    );

    always_ff@(posedge clk or negedge nrst) begin
        if(!nrst) begin
            PCF <= 32'b0;        
        end
        else begin
            if(!dis) begin //normal
                PCF <= PCFp;
            end
        end
    end
    
    assign PCPlus4F = PCF + 32'd4;       
    
endmodule
