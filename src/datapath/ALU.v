// Code your design here
module ALU(
  input [63:0] op0,
  input [63:0] op1,
  input [2:0] func3,
  input [6:0] func7,
  input [6:0] ctrl,
  
  output reg [63:0] ALU_result,
  output reg overflow,
  output reg eq,
  output reg lt,
  output reg gt,
  output reg byte_op // True for LB
  );
  
  // R-type: add,sll,sub
  
  always@(*) begin

    // Branch instructions
    eq = op0 == op1;
    gt = op0 > op1;
    lt = op0 < op1;
    byte_op = ((ctrl[2] | ctrl[3]) && (func3==3'b000)); // If instruction is lb or sb.
    
	{overflow, ALU_result} = op0 + op1;
	if (ctrl[6]) begin  // To ensure instr is not load,store,jump or branch. because they have the same func3 value.
	    case(func3)
	    3'b000: begin // SUB - only for R type.
	        if(func7[6:5] == 2'b01)
	          {overflow, ALU_result} = op0 - op1;
	    	else
	    	  {overflow, ALU_result} = op0 + op1;
	      end
	    3'b001: begin //SLL and SLLI
	        ALU_result = op0 << (op1[4:0]);
	      end
	    3'b010: begin // SLT and SLTI
	        ALU_result = lt;
	      end
	    3'b100: begin// XOR and XORI 
	        ALU_result = op0 ^ op1;
	      end
	    3'b101: begin // SRL and SRLI
	        ALU_result = op0 >> (op1[4:0]);
	      end
	    3'b110: begin // OR and ORI
	        ALU_result = op0 | op1;
	      end
	    3'b111: begin // AND and ANDI
	        ALU_result = op0 & op1;
	      end
		default: {overflow, ALU_result} = op0 + op1;
	    endcase
	end        
  end
endmodule


