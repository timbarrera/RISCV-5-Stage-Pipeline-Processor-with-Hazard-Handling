`timescale 1ns / 1ps

module risc_imm(
    input           [1:0]   imm_src,
    input           [31:0]  imm_input,
    output logic    [31:0]  imm_output
    );
    
    wire [31:0] inst;
    assign inst = imm_input;
    
    always_comb begin
        case(imm_src)
            2'b00: imm_output   <=  {{20{inst[31]}}, inst[31:20]}; //immediate
            2'b01: imm_output   <=  {{20{inst[31]}}, inst[31:25], inst[11:7]}; //store
            2'b10: imm_output   <=  {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0}; //branch
            2'b11: imm_output   <=  {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0}; //jump
            default: imm_output <=  {{20{inst[31]}}, inst[31:20]};
        endcase
    end
        
endmodule
