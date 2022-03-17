`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:55:24 03/08/2022 
// Design Name: 
// Module Name:    fifo_sram 
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
 
 module fifo_sram #( parameter DWIDTH  = 72,
                     parameter ALM_FULL = 240,	                 parameter IAWIDTH = 10 // Address range is [0 to 1023]
	)
    (
      input reset_n,
      input clk,
	  
	  input pc_en,
      input wea,
      input [IAWIDTH-1:0] addra,
      input [DWIDTH-1:0]  dina,
	  
	  input web,
      input [IAWIDTH-1:0] addrb,
      input [DWIDTH-1:0]  dinb,
      input [DWIDTH-1:0]  fifo_input,
      
	  input reb,
      output [DWIDTH-1:0] sram_data_out, 
      output [DWIDTH-1:0] fifo_output,
	  output almfull,
	  output fifo_empty,
	  output stall
    );
	 
	localparam AWIDTH = IAWIDTH-2;
	wire [AWIDTH-1:0] mux_addr_a,mux_addr_b;
	wire [DWIDTH-1:0] mux_dina, fifo_data_out, dout_ctrl;
	reg [AWIDTH:0] tail_address,head_address;
	wire full,empty, drop_packet, fifo_sel;
	//wire stall;
	
	assign mux_addr_a = fifo_sel ? tail_address : addra[AWIDTH-1:0];
	assign mux_addr_b = fifo_sel ? head_address : addrb[AWIDTH-1:0];
	assign mux_dina =   fifo_sel ?  fifo_input : dina;
	assign full = (tail_address[AWIDTH-1:0]==head_address[AWIDTH-1:0]) && (tail_address[AWIDTH]!=head_address[AWIDTH]);
	assign almfull = ((tail_address[AWIDTH-1:0] - head_address[AWIDTH-1:0] > ALM_FULL) && (tail_address[AWIDTH]==head_address[AWIDTH])) | 
	               (({1'b1,tail_address[AWIDTH-1:0]} - {1'b0, head_address[AWIDTH-1:0]} > ALM_FULL) && (tail_address[AWIDTH]!=head_address[AWIDTH]));
	assign empty = tail_address[AWIDTH:0]==head_address[AWIDTH:0];
	
	always @(posedge clk) begin
	    if(!reset_n)
     		tail_address <= 0;
	    else if(wea && (!full))
	        tail_address <= tail_address + 1;
	end
	
	always @(posedge clk) begin
	    if(!reset_n) 
		    head_address <= 0;
		else if(drop_packet)
		    head_address <= tail_address;
	    else if(reb && (!empty))
	        head_address <=  head_address+1;
	end
	
	sram_mem inst_fifo_ram ( 
	 .clka  (clk),
     .clkb  (clk),
 	 .dina  (mux_dina),
	 .dinb  (dinb),
	 .wea   (wea), 
	 .web   (web), 
	 .addra (mux_addr_a),
	 .addrb (mux_addr_b),
	 .douta (fifo_data_out), 
	 .doutb (fifo_output)
	);

    controller #(
		.AWIDTH (10)
	) inst_controller
	(
	   .clk      (clk),
	   .pc_en    (pc_en),
	   .reset_n  (reset_n),
       .i_ctrl   (fifo_input[71:64]),
       .tail_addr(tail_address),
       .head_addr(head_address),
	
	   // Processor side.
       .wea      (wea),
       .addra    (addra),
       .dina     (dina),
	   .douta     (dout_ctrl),
	   .stop_tx   (stop_tx),
	   
	   .fifo_sel    (fifo_sel),
       .drop_packet (drop_packet),
       .stall       (stall)
	);
	reg [IAWIDTH-1:0] addra_r;
	always @(posedge clk) 
	    addra_r <= addra;
		
	assign sram_data_out = addra_r[9] ? dout_ctrl : fifo_data_out; 
	assign fifo_empty = stop_tx | empty;
endmodule


