// Code your design here
module ALU(
  input [63:0] op0,
  input [63:0] op1,
  input [2:0] func3,
  input [6:0] func7,
  input [5:0] ctrl,
  
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
    byte_op = ((ctrl[2] || ctrl[3]) && (func3==3'b000)); // If instruction is lb or sb.

    //ADD
    {overflow, ALU_result} <= op0 + op1;
    if(func7[6:5] == 2'b01 && func3 == 3'b000 && (!ctrl[3]) && (!ctrl[1]) && (!ctrl[2]) && (!ctrl[4]) && (!ctrl[5])) // To ensure instr is not load,store,jump or branch. because they have the same func3 value.
	    {overflow, ALU_result} <= op0 - op1;



	//SLL and SLLI
    else if(func3 == 3'b001 && (!ctrl[1]) && (!ctrl[2]) && (!ctrl[5])) // To ensure instr is not load,store or branch. because they have the same func3 value.
    begin
      ALU_result <= op0 << (op1[4:0]);
    end

    // SLT and SLTI
    else if((func3 == 3'b010) && (!ctrl[1]) && (!ctrl[2]) ) // To ensure instr is not load or store. because they have the same func3 value.
    begin
      ALU_result <= lt;
    end

    // XOR and XORI
    else if(func3 == 3'b100 && (!ctrl[5]) && (!ctrl[2])) // To ensure instr is not load or branch. because they have the same func3 value.
    begin
      ALU_result <= op0 ^ op1;
    end

    // SRL and SRLI
    else if((func3 == 3'b101) && (!ctrl[2])) // To ensure instr is not load. because they have the same func3 value.
    begin
      ALU_result <= op0 >> (op1[4:0]);
    end

    // OR and ORI
    else if((func3 == 3'b110) &&  (!ctrl[5])) // To ensure instr is not branch. because they have the same func3 value.
    begin
      ALU_result <= op0 | op1;
    end

    // AND and ANDI
    else if((func3 == 3'b111) && (!ctrl[5])) // To ensure instr is not branch. because they have the same func3 value.
    begin
      ALU_result <= op0 & op1;
    end
    
	
  end
endmodule


