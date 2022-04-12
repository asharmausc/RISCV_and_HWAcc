`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name:    tb_datapath 
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

module tb_datapath(
    );

localparam NUM_INSTR = 174 ;
reg clk = 1'b0;
reg reset_n = 1'b1;
reg pc_en = 1'b0;

// memory
reg [31:0] istr_mem [NUM_INSTR:0];
reg [63:0] data_mem [511:0];
initial begin
    $readmemh("dump.txt",istr_mem);
	#100
	$display("Wrote instr to memory");
    $readmemh("data.txt",data_mem);
	#100
	$display("Wrote data to memory");
end


reg [31:0] i_mem_addra;
reg [31:0] i_mem_din;
reg i_mem_we;

reg [7:0] d_mem_addra;
reg [63:0] d_mem_din;
wire [63:0] d_mem_out;
reg d_mem_we;

// clock
always #5 clk = ~clk;

// UUT
   datapath UUT (
		.i_mem_addra(i_mem_addra), 
		.i_mem_din  (i_mem_din), 
		.i_mem_dout (), 
		.i_mem_we   (i_mem_we), 
		.d_mem_addra(d_mem_addra), 
		.d_mem_din  (d_mem_din), 
		.d_mem_we   (d_mem_we), 
		.d_mem_out  (), 
		
		// Memory access for FIFO and controller
	    .mem_datat_in ('h0),
	    .mem_addr_out (),
	    .mem_data_out (),
	    .mem_we       (),
		
		.pc_en      (pc_en), 
		.reset_n    (reset_n), 
		.clk        (clk)
     );
	/*  
	assign i_mem_din = istr_mem[i_mem_addra];
	assign i_mem_we  = reset_n & (i_mem_addra < NUM_INSTR);
	always @(posedge clk) begin
	    if(!reset_n) begin
		    i_mem_addra <= 'h0;
		end
		else begin
		    if(i_mem_addra < NUM_INSTR)
		    i_mem_addra <= i_mem_addra + 1'b1;
			else
			pc_en <= 1'b1;
		end
	end */

integer count;
integer num_data_vals;
task send_data; begin
  //  num_data_vals = data_mem[0];
	count = 0;
	while(count != 39) begin
	    d_mem_addra = count;
		d_mem_din   = data_mem[count];
		d_mem_we    = 1'b1;
		#10;
		count = count + 1'b1;
	end
	    d_mem_addra = 'h0;
		d_mem_din   = 'h0;
		d_mem_we    = 1'b0;
		#10;
end
endtask 

//integer count;
task send_instr; begin
	count = 0;
	while(count != NUM_INSTR) begin
	    i_mem_addra = count;
		i_mem_din   = istr_mem[count];
		i_mem_we    = 1'b1;
		#10;
		count = count + 1'b1;
	end
	    i_mem_addra = 'h0;
		i_mem_din   = 'h0;
		i_mem_we    = 1'b0;
		#10;
end
endtask


task read_data; begin
  count  = 0;
  num_data_vals = data_mem[0];
  while (count != num_data_vals) begin
      d_mem_addra = count + 1;
		#10
		$display("%x",d_mem_out);
		count = count +1;
  end
  d_mem_addra = 'h0;
end
endtask



initial begin
reset_n = 1'b0;

#100 
reset_n = 1'b1;
#10
send_data();

#100 
send_instr();
pc_en = 1'b1;
#510;
//read_data();
$stop;
end

endmodule

