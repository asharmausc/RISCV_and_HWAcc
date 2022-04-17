`timescale 1ns/1ps
// Test bench to test sram fifo and ALU.
module FIFO_Test_TB  ();

parameter DATA_WIDTH = 64;
parameter CTRL_WIDTH = DATA_WIDTH/8;
parameter UDP_REG_SRC_WIDTH = 2;
localparam NUM_INSTR = 32;

localparam DROP = 0;

reg [DATA_WIDTH-1:0]             in_data;
reg [CTRL_WIDTH-1:0]             in_ctrl;
reg                              in_wr   = 'h0;
wire                             in_rdy;

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

reg [31:0]                   pc_en;
// hardware registers
reg [31:0]                    matches;


wire [63:0] sram_data_out;
wire [9:0]  mem_addr_out;
wire [63:0] mem_data_out;
reg  mem_we;
wire  stall, almfull, empty, reb;

reg clk = 0;
reg reset = 0;
reg tb_stall;
// clock
always #5 clk = ~clk;

   
   
    fifo_sram #(
      .DWIDTH  (72),
	  .IAWIDTH (10) // Address range is [0 to 1023]
	) inst_fifo_sram (
      .reset_n      (reset),
      .clk          (clk),
	  .pc_en        (pc_en[0]), 
      .wea          (mem_we|in_wr),
      .addra        ('h0),
      .dina         ('h0),
      .web          ('h0),
      .addrb        ('h0),
      .dinb         ('h0),
      .fifo_input   ({in_ctrl,in_data}),
	  .reb          (reb),
      .sram_data_out(), 
      .fifo_output  ({out_ctrl,out_data}),
	  .almfull      (almfull),
	  .fifo_empty   (empty),
	  .stall        (stall)
    );
	
   assign reb = out_rdy & !empty & !tb_stall;
   assign in_rdy = ~almfull & ~stall;
   assign out_wr = reb;
   
   reg [71:0] count; 
   reg [71:0] count_chk;
   reg [15:0] diff;   
   reg reb_r;
   always @(posedge clk) begin
       if(!reset) begin
	       count <= 'h0;
       end
	   else begin
	     mem_we <= 1'b0;
	     if(!almfull & !stall) begin
	       count <= count + 1;
		   mem_we <= 1'b1;
		 end
		 {in_ctrl,in_data} <= count;
	   end
   end
   
   always @(posedge clk) begin
       reb_r <= reb;
	   if(!reset) begin
	       count_chk <= 'h0;
		   diff      <= 'h0;
       end
	   else begin
	     tb_stall <= count_chk[0];
	     if(reb_r) begin
	       count_chk <= count_chk + 1;
		 end
		 if(({out_ctrl,out_data}) != count_chk)
		   diff <= diff + 1'b1;
	   end
   end
   
initial begin
reset = 1'b0;
out_rdy = 1'b1;
pc_en = 'h0;
#100
reset = 1'b1;
#100
#200
#1000;
$stop;
end

endmodule