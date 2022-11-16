`timescale 1ns / 1ps


module risc_alu(
    input [31:0]        operandA,
    input [31:0]        operandB,
    input [2:0]         alu_op,
    output logic [31:0] alu_out,
    output logic        zero 
    );
    
    always_comb begin
        case(alu_op)
            3'b000: alu_out <= operandA + operandB;
            3'b001: alu_out <= operandA - operandB;
            3'b010: alu_out <= operandA & operandB;
            3'b011: alu_out <= operandA | operandB;
            3'b100: alu_out <= operandA << operandB;
            3'b101: alu_out <= operandA >> operandB;
            default: alu_out <= operandA + operandB;
        endcase
    end
        
    always_comb begin
        zero <= (operandA == operandB) ? 1'b1 : 1'b0;
    end
  
endmodule
