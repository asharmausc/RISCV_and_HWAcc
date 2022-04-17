// =======================================
// Pipeline register for various stages of 
// our register file.
// =======================================

module pipelinereg #(
       parameter DWIDTH = 64
	) (
	   input clk,
	   input reset_n,
	   input en,
	   input [DWIDTH-1:0] i_data,
	   output reg [DWIDTH-1:0] o_data
	);
	
	always @(posedge clk, negedge reset_n) begin
	    if(!reset_n) begin
		    o_data <= 'h0;
		end
		else begin
		    if(en)
			    o_data <= i_data;
		end
	end
	
endmodule