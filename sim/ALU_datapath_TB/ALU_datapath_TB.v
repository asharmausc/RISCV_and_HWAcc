`timescale 1ns/1ps
// Test bench to test sram fifo and ALU.
module ALU_datapath_TB  ();

parameter DATA_WIDTH = 64;
parameter CTRL_WIDTH = DATA_WIDTH/8;
parameter UDP_REG_SRC_WIDTH = 2;
localparam NUM_INSTR = 250;

localparam DROP = 0;

reg [DATA_WIDTH-1:0]             in_data = 'h0;
reg [CTRL_WIDTH-1:0]             in_ctrl = 'h0;
reg                              in_wr   = 'h0;
wire                             in_rdy ;

wire[DATA_WIDTH-1:0]             out_data, out_data1;
wire[CTRL_WIDTH-1:0]             out_ctrl, out_ctrl1;
wire                             out_wr;
reg                             out_rdy;
    
reg [31:0] i_mem_addra, i_mem_addra1;
reg [31:0] i_mem_din, i_mem_din1;
reg i_mem_we, i_mem_we1;

reg [7:0] d_mem_addra, d_mem_addra1;
reg [63:0] d_mem_din, d_mem_din1;
wire [63:0] d_mem_out, d_mem_out1;
reg d_mem_we, d_mem_we1;

// software registers 
wire [31:0]                   mem_data_high;
wire [31:0]                   mem_data_low;
wire [31:0]                   mem_rd_data_high;
wire [31:0]                   mem_rd_data_low;
wire [31:0]                   mem_rd_addr;

wire [31:0]                   i_mem_dout, i_mem_dout1;
reg [31:0]                   pc_en;
// hardware registers
reg [31:0]                    matches;


wire [63:0] sram_data_out, sram_data_out1;
wire [9:0]  mem_addr_out, mem_addr_out1;
wire [63:0] mem_data_out, mem_data_out1;
wire  mem_we, mem_we1, stall, stall1, almfull, almfull1, empty, empty1;

reg clk = 1;
reg reset = 0;
reg reb_r;


// clock
always #5 clk = ~clk;

   
   
    fifo_sram #(
      .DWIDTH  (72),
	  .IAWIDTH (10) // Address range is [0 to 1023]
	) inst_fifo_sram (
      .reset_n      (~reset),
      .clk          (clk),
	  .pc_en        (pc_en[0]), 
      .wea          (in_wr),
      .addra        ('h0),
      .dina         ('h0),
      .web          (mem_we),
      .addrb        (mem_addr_out),
      .dinb         ({8'h00, mem_data_out}),
      .fifo_input   ({in_ctrl,in_data}),
	  .reb          (reb),
      .sram_data_out(sram_data_out), 
      .fifo_output  ({out_ctrl,out_data}),
	  .almfull      (almfull),
	  .fifo_empty   (empty),
	  .stall        (stall)
    );

	fifo_sram #(
      .DWIDTH  (72),
	  .IAWIDTH (10) // Address range is [0 to 1023]
	) inst_fifo_sram1 (
      .reset_n      (~reset),
      .clk          (clk),
	  .pc_en        (pc_en[0]), 
      .wea          (out_wr),
      .addra        ('h0),
      .dina         ('h0),
      .web          (mem_we1),
      .addrb        (mem_addr_out),
      .dinb         ({8'h00, sram_data_out}),
      .fifo_input   ({out_ctrl,out_data}),
	  .reb          (reb1),
      .sram_data_out(sram_data_out1), 
      .fifo_output  ({out_ctrl1,out_data1}),
	  .almfull      (almfull1),
	  .fifo_empty   (empty1),
	  .stall        (stall1)
    );
	
   assign reb1 = out_rdy & !empty1;
   assign reb = !almfull1 & !empty;
   assign in_rdy = ~almfull & ~stall;
   assign out_wr = reb_r;

   always @(posedge clk)
       reb_r <= reb;
 
   datapath inst_datapath (
		.i_mem_addra  (i_mem_addra), 
		.i_mem_din    (i_mem_din), 
		.i_mem_dout   (i_mem_dout), 
		.i_mem_we     (i_mem_we), 
		.d_mem_addra  (d_mem_addra[7:0]), 
		.d_mem_din    (d_mem_din), 
		.d_mem_we     (d_mem_we), 
		.d_mem_out    (d_mem_out),
		// Memory access for FIFO and controller
	    .mem_datat_in (sram_data_out[63:0]),
	    .mem_addr_out (mem_addr_out),
	    .mem_data_out (mem_data_out),
	    .mem_we       (mem_we),

		.pc_en        (pc_en[0]), 
		.reset_n      (~reset), 
		.clk          (clk)
   );
   datapath inst_datapath1 (
		.i_mem_addra  (i_mem_addra1), 
		.i_mem_din    (i_mem_din1), 
		.i_mem_dout   (i_mem_dout1), 
		.i_mem_we     (i_mem_we1), 
		.d_mem_addra  (d_mem_addra[7:0]), 
		.d_mem_din    (d_mem_din), 
		.d_mem_we     (d_mem_we), 
		.d_mem_out    (d_mem_out),
		// Memory access for FIFO and controller
	    .mem_datat_in (sram_data_out1[63:0]),
	    .mem_addr_out (mem_addr_out1),
	    .mem_data_out (mem_data_out1),
	    .mem_we       (mem_we1),

		.pc_en        (pc_en[0]), 
		.reset_n      (~reset), 
		.clk          (clk)
   );
   

// memory
reg [31:0] istr_mem [NUM_INSTR-1:0];
reg [31:0] istr_mem1 [NUM_INSTR-1:0];
reg [71:0] data_mem [100:0];
reg [71:0] mem_ALU [100:0];
initial begin
    $readmemh("encrypt_dump.txt",istr_mem);
	$readmemh("decrypt_dump.txt",istr_mem1);
	#100
	$display("Wrote instr to memory");
    $readmemh("data.txt",data_mem);
	#100
	$display("Wrote data to memory");
    $readmemh("mem_data.txt",mem_ALU);
	#100
	$display("Wrote data to memory");
end
	  
integer count;
integer num_data_vals;
// SEND DATA
task send_data; begin
	count = 0;
	while(count != 39) begin
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
	while(count != 64)begin
	    if(!stall & ~almfull) begin
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
		i_mem_addra1 <= count;
		i_mem_din1   <= istr_mem1[count];
		i_mem_we1    <= 1'b1;
		#10;
		count = count + 1'b1;
	end
	    i_mem_addra <= 'h0;
		i_mem_din   <= 'h0;
		i_mem_we    <= 1'b0;
		i_mem_addra1 <= 'h0;
		i_mem_din1   <= 'h0;
		i_mem_we1    <= 1'b0;
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
#100
reset = 1'b0;
#100
//pc_en = 1'b1;
send_instr();
send_data();
pc_en <= 1'b1;
out_rdy <= 1'b1;
//fork
  //send_packets();
  //pc_en = 32'h1;
//join
//#200
//pc_en = 32'h0;
#20
send_packets();
//#10000;
//read_data();
$stop;
end

endmodule