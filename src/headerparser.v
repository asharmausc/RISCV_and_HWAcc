// =========================================
// This module helps parse packet header for
// layer 2, 3 and TCP/UDP. and sends a 64 bit
// boundary output to encryption module to
// encrypt that.
// =========================================

module headerparser #(
  parameter DWIDTH = 64,
  parameter CTRL_WIDTH = DWIDTH/8
  )  
  (
    input i_clock,
	input i_reset_n,
	
	input [DWIDTH-1:0]      in_data,
	input [CTRL_WIDTH-1:0]  in_ctrl,
	input                   in_wr,
	output reg              in_rdy,
	
	output reg [DWIDTH-1:0]     out_data,
	output reg [CTRL_WIDTH-1:0] out_ctrl,
	output reg                  out_wr,
	input                       out_rdy,
    
	// output data 
	output reg [15:0] data_count,
	output     o_inside_payload
 );
 
 localparam HEADER = 3'b000,
            L2_PARSER = 3'b001,
			L3_PARSER = 3'b010,
			L4_PARSER = 3'b011,
			PAYLOAD   = 3'b100;
  
  reg [2:0] state; 
  reg [2:0] next_state;
  reg first_cycle;
  reg first_cycle_r;
  reg store_data;
  reg store_data_r;
  reg inside_payload_r;
  reg inside_payload;
  
  always @(*) begin
      next_state = state;
	  first_cycle = first_cycle_r;
	  store_data  = store_data_r;
	  inside_payload = inside_payload_r;
      case(state)
	  HEADER : begin
	             if(in_ctrl == 8'hff)
				     next_state = L2_PARSER;
			   end
	  L2_PARSER: begin
	               first_cycle = 1'b1;
				   if(first_cycle_r == 1) begin
				       first_cycle = 1'b0;
				       if(in_data[31:16] == 16'h0800)
					       next_state = L3_PARSER;
					   else
					       next_state = HEADER;
				   end 
				 end
	  L3_PARSER: begin
	               first_cycle = 1'b1;
				   if(in_data[7:0] != 8'h11 & !first_cycle_r)
				       next_state = HEADER;
				   if(first_cycle_r == 1) begin
				       first_cycle = 1'b0;
					   next_state = L4_PARSER;
				   end 
				 end
	  L4_PARSER: begin
	               first_cycle = 1'b1;
				   store_data  = 1'b1;
				   if(first_cycle_r == 1) begin
				       store_data  = 1'b0;
				       first_cycle = 1'b0;
					   next_state = PAYLOAD;
				   end 
				 end
	  PAYLOAD  : begin
	               inside_payload = 1'b1;
	               if(in_ctrl != 8'h00) begin
                      next_state = 	HEADER;
                      inside_payload = 1'b0;
                   end					  
				 end
	   default: begin 
	                  inside_payload = 1'b0;
                      next_state  = HEADER;
					  first_cycle = 1'b0;
					  store_data  = 1'b0;
                end
       endcase				
  end
  
  always @(posedge i_clock) begin
      if(!i_reset_n) begin
          state            <= 'h0;
	      first_cycle_r    <= 'h0;
	      store_data_r     <= 'h0;
		  data_count       <= 'h0;
		  inside_payload_r <= 'h0;
		  out_wr           <= 1'b0;
		  in_rdy           <= 1'b0;
	  end
	  else begin
          state            <= next_state;
	      first_cycle_r    <= first_cycle;
	      store_data_r     <= store_data;
		  inside_payload_r <= inside_payload;
		  
		  // store data.
		  if(store_data) begin
		      data_count <= in_data[15:0] - 6 -8;
		  end
		  if(inside_payload)
		      data_count <= data_count - 4'h8 ;
		  
		  // Send the values out.
	      out_wr   <= in_wr  ;
	      in_rdy   <= out_rdy ;
	  end
	  // Data and contorl without reset.
	  out_ctrl <= in_ctrl;
      out_data <= in_data;
  end
  // passing variable indicating payload inside the ethernet packet.
  assign o_inside_payload = inside_payload_r;
endmodule