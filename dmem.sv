`timescale 1ns / 1ps

module dmem #(
    parameter ADDR_WIDTH = 32,
    parameter BYTE_WIDTH = 8,
    parameter DATA_WIDTH = 32,
    parameter TOTAL_DATA = 4096
)(  
    input  logic                       clk,
    input  logic    [ADDR_WIDTH - 1:0] dmem_addr,
    input  logic    [DATA_WIDTH - 1:0] dmem_data_in,
    input  logic                       dmem_wr_en,
    output logic    [DATA_WIDTH - 1:0] dmem_data_out
);
    
    logic [BYTE_WIDTH - 1:0] dmem_memory [0:TOTAL_DATA-1]; 
    
    initial begin
        $readmemh("data_memory.mem", dmem_memory);
    end
    
    always_ff @ (posedge clk) begin
        if (dmem_wr_en) begin
            {
             dmem_memory[dmem_addr + 32'd3],
             dmem_memory[dmem_addr + 32'd2],
             dmem_memory[dmem_addr + 32'd1],
             dmem_memory[dmem_addr]                                              
            } <= dmem_data_in; 
        end
    end
    
    assign dmem_data_out = {
                            dmem_memory[dmem_addr + 32'd3],
                            dmem_memory[dmem_addr + 32'd2],
                            dmem_memory[dmem_addr + 32'd1],
                            dmem_memory[dmem_addr]                                              
                           };

endmodule
