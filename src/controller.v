`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 
//////////////////////////////////////////////////////////////////////////////////
module controller #(
	    parameter DWIDTH = 72,
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
	   output reg stop_tx,
       output wire stall
	);
	// Internal signals
	reg [7:0] prev_control;
	reg [8:0] head_pointer;
	
	// register file
	reg [DWIDTH-1:0] register_0;
	reg [DWIDTH-1:0] register_1;
	reg [DWIDTH-1:0] register_2;
	reg [DWIDTH-1:0] register_3;
	
	
	localparam SEARCH_SOP     = 3'b000;
	localparam SEARCH_EOP     = 3'b001;
	localparam ALU_PROCESSING = 3'b010;
	localparam DRPKT          = 3'b011;
	localparam EJECT_PREV_PKT = 3'b100;
	
	reg stall_r;
	reg stall_C;
	reg drop_packet_C;
	reg fifo_sel_r;
	reg fifo_sel_C;
	reg [2:0] state, next_state;
	
	reg we_reg0;
	reg	we_reg1;
	reg	we_reg2;
	reg	clr_reg3;

	
	//assign stop_tx = (head_addr == register_1) & pc_en ;
	assign stall = stall_C | stall_r; // immediate assertion and synchronous deassertion.
	
	always @(*) begin
		stall_C      = stall_r;
		//stall_C    = 1'b0;
		we_reg0    = 1'b0;
		we_reg1    = 1'b0;
		we_reg2    = 1'b0;
		clr_reg3   = 1'b0;
		stop_tx    = 1'b0;
		next_state = state;
		fifo_sel_C = fifo_sel_r;
		drop_packet_C = drop_packet;
		if(pc_en) begin
		    case(state)
		    SEARCH_SOP: begin 
		        stall_C    = 1'b0;
		    	stop_tx    = (head_addr == register_1);
		        if(i_ctrl == 8'hff && prev_control != 8'hff) begin
		    	    we_reg1    = 1'b1;
		    		next_state = SEARCH_EOP;
		    	end
		    end
		    SEARCH_EOP: begin
		    	stop_tx    = (head_addr == register_1);
		    	stall_C       = 1'b0;
		        if(i_ctrl != 0 && prev_control == 0) begin // End of packet.
		    	    stall_C       = 1'b1;
		    		we_reg0       = 1'b1; // Indicate start of process.
		    		we_reg2       = 1'b1; // Store end of packet
		    		//fifo_sel_C    = 1'b0;
					if(stop_tx)
		    		    next_state    = ALU_PROCESSING;
                    else
		    		    next_state    = EJECT_PREV_PKT;
		    	end
		    end
		    ALU_PROCESSING: begin
		    	stop_tx    = 1'b1;
		    	stall_C       = 1'b1;
				fifo_sel_C    = 1'b0;
		        if(register_3 != 0) begin
		    		next_state    = DRPKT;
                    drop_packet_C = 1'b1;				
		    	end 
		    	else if(register_0 == 0) begin
		    	    drop_packet_C = 1'b0;
		    		clr_reg3      = 1'b1;    // Reset the drop packet register
		    	    //stall_C       = 1'b0;
		    		fifo_sel_C    = 1'b1;
		    		if(register_2 == tail_addr-1)
		    	        next_state = SEARCH_SOP;
		    		else begin
		    		    next_state = SEARCH_EOP;
		    	        we_reg1    = 1'b1;
		    		end
		    	end
		    end
		    DRPKT: begin
		    	stall_C       = 1'b1;
				stop_tx       = 1'b1;
		    	if(register_0 == 0) begin
		    	    drop_packet_C = 1'b0;
		    		clr_reg3      = 1'b1;    // Reset the drop packet register
		    	    //stall_C       = 1'b0;
		    		fifo_sel_C    = 1'b1;
		    		if(register_2 == tail_addr-1)
		    	        next_state = SEARCH_SOP;
		    		else begin
		    		    next_state = SEARCH_EOP;
		    	        we_reg1    = 1'b1;
		    		end
		    	end
		    end
			EJECT_PREV_PKT: begin
		    	stop_tx    = (head_addr == register_1);
		    	stall_C       = 1'b1;
				if(stop_tx)
				    next_state = ALU_PROCESSING;
			end
		    endcase
        end			
	end
	
	
	always @(posedge clk) begin
		//fifo_sel     <= fifo_sel_r;
	    if(!reset_n | !pc_en) begin
		    state         <= SEARCH_SOP;
			drop_packet   <= 1'b0;
			prev_control  <= 'h0;
			stall_r       <= 1'b0;
		    register_0    <= 'h0;
		    register_1    <= 'h0;
		    register_2    <= 'h0;
		    register_3    <= 'h0;
            fifo_sel_r    <= 1'b1;
            fifo_sel      <= 1'b1;
		end
		else begin
		    state        <= next_state;
		    fifo_sel_r   <= fifo_sel_C;
		    fifo_sel     <= fifo_sel_C;
		    prev_control <= i_ctrl;
			stall_r      <= stall_C;
		    drop_packet  <= drop_packet_C;

			if(we_reg2) begin // store end of packet.
			    register_2   <= tail_addr;
			end
		    if(we_reg1) begin // Start of packet.
				register_1    <= tail_addr;
			end
			if(we_reg0) begin // End of packet.
				register_0    <= register_0 | 4'hf; // Indicate start of process
			end
			if(clr_reg3) begin
				register_3    <= 'h0;    // Reset the drop packet register
			end
			
			// Processor writing to register
		    if(wea && addra[9]) begin
			    case(addra[7:0])
				8'h00: begin register_0 <= register_0 & dina; end
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
