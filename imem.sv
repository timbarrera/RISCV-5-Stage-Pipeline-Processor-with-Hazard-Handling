`timescale 1ns / 1ps

module imem #(
    parameter ADDR_WIDTH = 32,
    parameter BYTE_WIDTH = 8,
    parameter DATA_WIDTH = 32,
    parameter TOTAL_DATA = 1048576
)(
    input logic     [ADDR_WIDTH - 1:0] imem_addr,
    output logic    [DATA_WIDTH - 1:0] imem_data
);
    
    logic [BYTE_WIDTH - 1:0] imem_memory [0:TOTAL_DATA-1]; 
    
    initial begin
        $readmemh("instruction_memory.mem", imem_memory);
    end
    
    always_comb begin
        imem_data <= {
                        imem_memory[imem_addr + 32'd3],
                        imem_memory[imem_addr + 32'd2],
                        imem_memory[imem_addr + 32'd1],
                        imem_memory[imem_addr]                                               
                     };
    end

endmodule
