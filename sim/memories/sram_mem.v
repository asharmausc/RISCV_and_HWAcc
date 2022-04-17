// The synthesis directives "translate_off/translate_on" specified below are
// supported by Xilinx, Mentor Graphics and Synplicity synthesis
// tools. Ensure they are correct for your synthesis tool(s).

// You must compile the wrapper file i_mem.v when simulating
// the core, i_mem. When compiling the wrapper file, be sure to
// reference the XilinxCoreLib Verilog simulation library. For detailed
// instructions, please refer to the "CORE Generator Help".

`timescale 1ns/1ps

module sram_mem #(
     parameter integer DWIDTH = 72,
	  parameter integer AWIDTH = 8,
	  parameter integer DEPTH  = 2**AWIDTH
	 )
   (
     input wire clka,
	  input wire clkb,
	  input wire [DWIDTH-1:0] dina,
	  input wire               wea,
	  input wire [AWIDTH-1:0] addra,
	  output reg[DWIDTH-1:0] douta,
	  
	  input wire [DWIDTH-1:0] dinb,
	  input wire               web,
	  input wire [AWIDTH-1:0] addrb,
	  output reg[DWIDTH-1:0] doutb
    );
	 
	 reg [DWIDTH-1:0] memory_reg [DEPTH-1:0];
	 
     initial begin
         $readmemh("zeros_72.txt",memory_reg);
     	#100;
     end
	 
	 always @(posedge clka) begin
	     douta <= memory_reg[addra];
		 if(wea) begin
		     memory_reg[addra] <= dina;
		 end
	 end
	 
	 always @(posedge clkb) begin
	     doutb <= memory_reg[addrb];
		 if(web) begin
		     memory_reg[addrb] <= dinb;
		 end
	 end
	 
endmodule
