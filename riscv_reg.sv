`timescale 1ns / 1ps


module riscv_reg #(
    parameter ADDR_WIDTH = 5,
    parameter DATA_WIDTH = 32,
    parameter REG_COUNT = 32
)(
    input   logic                       clk,
    input   logic                       nrst,
    input   logic                       wr_en,
    input   logic   [ADDR_WIDTH - 1:0]  wr_addr,
    input   logic   [DATA_WIDTH - 1:0]  wr_data,
    input   logic   [ADDR_WIDTH - 1:0]  rd_addrA,
    input   logic   [ADDR_WIDTH - 1:0]  rd_addrB,
    output  logic   [DATA_WIDTH - 1:0]  rd_dataA,
    output  logic   [DATA_WIDTH - 1:0]  rd_dataB
    );
    
    integer i;
    logic [DATA_WIDTH - 1:0] regfile [0:REG_COUNT - 1];
    
    
    always_comb begin
        if(rd_addrA == 5'b0) begin
            rd_dataA <= 32'b0;
        end    
        else begin
            rd_dataA <= regfile[rd_addrA];
        end
    end
    
    always_comb begin 
        if(rd_addrB == 5'b0) begin
            rd_dataB <= 32'b0;
        end
        else begin
            rd_dataB <= regfile[rd_addrB];
        end
    end    
    
    always_ff @ (negedge clk or negedge nrst) begin
        if(!nrst) begin
            for(i = 0; i < 32; i = i+1 ) begin
                regfile[i] <= 32'b0;
            end
        end
        else begin
            if(wr_en)begin
                regfile[wr_addr] <= wr_data;
            end
            else begin
                regfile[5'b0] <= 32'b0;
            end
        end
    end
    
endmodule
