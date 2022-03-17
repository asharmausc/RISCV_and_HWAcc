`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 
//////////////////////////////////////////////////////////////////////////////////
module controller #(
	    parameter DWIDTH = 64,
		parameter AWIDTH = 10
	)
	(
	   input clk,
	   input reset_n,
	   input pc_en,
       input [7:0]         i_ctrl,
       input [AWIDTH-3:0]  tail_addr,
       input [AWIDTH-3:0]  head_addr,
	
	   // Processor side.
       input               wea,
       input [AWIDTH-1:0]  addra,
       input [DWIDTH-1:0]  dina,
	   output reg [DWIDTH-1:0] douta,
       
	   output reg fifo_sel,
       output reg drop_packet,
	   output wire stop_tx,
       output reg stall
	);
	// Internal signals
	reg [7:0] prev_control;
	reg [8:0] head_pointer;
	reg [8:0] tail_pointer;
	
	// register file
	reg [DWIDTH-1:0] register_0;
	reg [DWIDTH-1:0] register_1;
	reg [DWIDTH-1:0] register_2;
	reg [DWIDTH-1:0] register_3;
	
	assign stop_tx = (head_addr == register_1) & pc_en ;
	always @(posedge clk) begin
	    tail_pointer <= tail_addr;
	    if(!reset_n | !pc_en) begin
			drop_packet   <= 1'b0;
			prev_control  <= 'h0;
			stall         <= 'h0;
		    register_0    <= 'h0;
		    register_1    <= 'h0;
		    register_2    <= 'h0;
		    register_3    <= 'h0;
            fifo_sel      <= 1'b1;			
		end
		else begin
		    prev_control <= i_ctrl;
			register_2   <= tail_addr;
		    if(i_ctrl == 8'hff && prev_control != 8'hff && !stall) begin // Start of packet.
				register_1    <= tail_addr;
			end
			else if(i_ctrl != 0 && prev_control == 0) begin // End of packet.
			    stall         <= 1'b1;
				register_0    <= register_0 | 1'b1; // Indicate start of process
				fifo_sel      <= 1'b0;
			end
			if(register_3 != 0) begin
			    drop_packet   <= 1'b1;
			end
			if(register_0 == 0 && stall) begin
			    drop_packet   <= 1'b0;
				register_3    <= 'h0;    // Reset the drop packet register
			    stall         <= 1'b0;
				fifo_sel      <= 1'b1;
			end
			
			// Processor writing to register
		    if(wea && addra[9]) begin
			    case(addra[7:0])
				8'h00: begin register_0 <= dina; end
				8'h01: begin register_1 <= dina; end
				8'h03: begin register_3 <= dina; end
				endcase
			end
		end
	end
	
	always @(posedge clk) begin
	    if(!reset_n) begin
		    douta <= 'h0;
		end 
		else begin
		    if(addra[9]) begin
			    // Processor Reading from registers
			    case(addra[7:0])
				8'h00: begin douta <= register_0; end
				8'h01: begin douta <= register_1; end
				8'h02: begin douta <= register_2; end
				8'h03: begin douta <= register_3; end
				endcase
			end
		end
	end
endmodule
