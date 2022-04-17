/*******************************************************************************
*     This file is owned and controlled by Xilinx and must be used             *
*     solely for design, simulation, implementation and creation of            *
*     design files limited to Xilinx devices or technologies. Use              *
*     with non-Xilinx devices or technologies is expressly prohibited          *
*     and immediately terminates your license.                                 *
*                                                                              *
*     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"            *
*     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR                  *
*     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION          *
*     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION              *
*     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS                *
*     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,                  *
*     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE         *
*     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY                 *
*     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE                  *
*     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR           *
*     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF          *
*     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS          *
*     FOR A PARTICULAR PURPOSE.                                                *
*                                                                              *
*     Xilinx products are not intended for use in life support                 *
*     appliances, devices, or systems. Use in such applications are            *
*     expressly prohibited.                                                    *
*                                                                              *
*     (c) Copyright 1995-2007 Xilinx, Inc.                                     *
*     All rights reserved.                                                     *
*******************************************************************************/
// The synthesis directives "translate_off/translate_on" specified below are
// supported by Xilinx, Mentor Graphics and Synplicity synthesis
// tools. Ensure they are correct for your synthesis tool(s).

// You must compile the wrapper file i_mem.v when simulating
// the core, i_mem. When compiling the wrapper file, be sure to
// reference the XilinxCoreLib Verilog simulation library. For detailed
// instructions, please refer to the "CORE Generator Help".

`timescale 1ns/1ps

module i_mem #(
     parameter integer DWIDTH = 32,
	  parameter integer AWIDTH = 10,
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
         $readmemh("zeros_32.txt",memory_reg);
     	#100;
     end
	 
	 always @(posedge clka) begin
	     douta <= memory_reg[addra];
		 if(wea) begin
		     memory_reg[addra] <= dina;
		 end
	 end
	 
	 always @(posedge clka) begin
	     doutb <= memory_reg[addrb];
		 if(web) begin
		     memory_reg[addrb] <= dinb;
		 end
	 end
	 
endmodule
