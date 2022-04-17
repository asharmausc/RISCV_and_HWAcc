`timescale 1ns/1ps
// Test bench to test sram fifo and ALU.
module headerparser_TB  ();

parameter DATA_WIDTH = 64;
parameter CTRL_WIDTH = DATA_WIDTH/8;
parameter UDP_REG_SRC_WIDTH = 2;
localparam NUM_INSTR = 64;

localparam DROP = 0;

reg [DATA_WIDTH-1:0]             in_data = 'h0;
reg [CTRL_WIDTH-1:0]             in_ctrl = 'h0;
reg                              in_wr   = 'h0;
wire                             in_rdy ;

wire[DATA_WIDTH-1:0]             out_data;
wire[CTRL_WIDTH-1:0]             out_ctrl;
wire                             out_wr;
reg                             out_rdy;
    
reg [31:0] i_mem_addra;
reg [31:0] i_mem_din;
reg i_mem_we;

reg [7:0] d_mem_addra;
reg [63:0] d_mem_din;
wire [63:0] d_mem_out;
reg d_mem_we;

// software registers 
wire [31:0]                   mem_data_high;
wire [31:0]                   mem_data_low;
wire [31:0]                   mem_rd_data_high;
wire [31:0]                   mem_rd_data_low;
wire [31:0]                   mem_rd_addr;

wire [31:0]                   i_mem_dout;
reg [31:0]                   pc_en;
// hardware registers
reg [31:0]                    matches;


wire [63:0] sram_data_out;
wire [9:0]  mem_addr_out;
wire [63:0] mem_data_out;
wire  mem_we, stall, almfull, empty;
wire payload;
wire [15:0] data_count;
reg clk = 1;
reg reset = 0;

// clock
always #5 clk = ~clk;

  headerparser #(
    .DWIDTH (64),
    .CTRL_WIDTH (8)
  )
  inst_headerparser (
    .i_clock  (clk),
	.i_reset_n(~reset),
	
	.in_data  (in_data),
	.in_ctrl  (in_ctrl),
	.in_wr    (in_wr),
	.in_rdy   (in_rdy),
	
	.out_data (out_data),
	.out_ctrl (out_ctrl),
	.out_wr   (out_wr),
	.out_rdy  (out_rdy),
    
	// output data 
	.data_count       (data_count),
	.o_inside_payload (payload)
 );
 
// memory
reg [31:0] istr_mem [100:0];
reg [71:0] data_mem [100:0];
reg [71:0] mem_ALU [100:0];
initial begin
    //$readmemh("dump.txt",istr_mem);
	#10
	$display("Wrote instr to memory");
    $readmemh("data.txt",data_mem);
	#100;
	//$display("Wrote data to memory");
    //$readmemh("mem_data.txt",mem_ALU);
	//#100
	//$display("Wrote data to memory");
end
	  
integer count;
integer num_data_vals;
// SEND DATA
task send_data; begin
	count = 0;
	while(count != 5) begin
	    d_mem_addra <= count;
		d_mem_din   <= mem_ALU[count];
		d_mem_we    <= 1'b1;
		#10;
		count = count + 1'b1;
	end
	    d_mem_addra <= 'h0;
		d_mem_din   <= 'h0;
		d_mem_we    <= 1'b0;
		#10;
end
endtask

// SEND PACKET
task send_packets; begin
	count = 0;
	while(count != 100)begin
	    if(in_rdy) begin
		    {in_ctrl,in_data}   <= data_mem[count%66];
		    //{in_ctrl,in_data}   = $random()*1000;
		    in_wr    <= 1'b1;
		    #10;
		    count = (count + 1'b1);
		end
		else begin
		   {in_ctrl,in_data} <= 'h0;
		   in_wr             <= 1'b0;
		   /*#80;
		   if(DROP) force inst_fifo_sram.inst_controller.register_3 = 64'h01;
		   #40
		   release inst_fifo_sram.inst_controller.register_3;
		   #10
		   force inst_fifo_sram.inst_controller.register_0 = 'h0;*/
		   #10;
		   //release inst_fifo_sram.inst_controller.register_0;
		end
	end
		d_mem_din   <= 'h0;
		in_wr       <= 1'b0;
		#10;
end
endtask
// SEND INSTR
task send_instr; begin
	count = 0;
	while(count != NUM_INSTR) begin
	    i_mem_addra <= count;
		i_mem_din   <= istr_mem[count];
		i_mem_we    <= 1'b1;
		#10;
		count = count + 1'b1;
	end
	    i_mem_addra <= 'h0;
		i_mem_din   <= 'h0;
		i_mem_we    <= 1'b0;
		#10;
end
endtask
// READ DATA
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
  reset = 1'b1;
  out_rdy = 1'b1;
  pc_en = 'h0;
  #10
  reset = 1'b0;
  #100
  send_packets();
  //pc_en = 1'b1;
  out_rdy <= 1'b1;
  #200
  //pc_en = 32'h0;
  #20
  send_packets();
  #10000;
  //read_data();
  $stop;
end

endmodule