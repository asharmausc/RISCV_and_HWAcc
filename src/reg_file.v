//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:24:33 02/03/2022 
// Design Name: 
// Module Name:    sdpram 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
module reg_file #(
     parameter integer DWIDTH = 64,
	  parameter integer AWIDTH = 6,
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
         $readmemh("zeros_64.txt",memory_reg);
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
