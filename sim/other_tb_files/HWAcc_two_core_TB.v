///////////////////////////////////////////////////////////////////////////////
// vim:set shiftwidth=3 softtabstop=3 expandtab:
// $Id: module_template 2008-03-13 gac1 $
//
// Module: ALU.v
// Project: NF2.1
// Description: Defines a simple ALU module for the user data path.  The
// modules reads a 64-bit register that contains a pattern to match and
// counts how many packets match.  The register contents are 7 bytes of
// pattern and one byte of mask.  The mask bits are set to one for each
// byte of the pattern that should be included in the mask -- zero bits
// mean "don't care".
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module HWAcc_two_core_TB ();
parameter DATA_WIDTH = 64;
parameter CTRL_WIDTH = DATA_WIDTH/8;
parameter UDP_REG_SRC_WIDTH = 2;
localparam NUM_INSTR = 250;
localparam PKT_SIZE = 20;

localparam DROP = 0;

reg [DATA_WIDTH-1:0]             in_data = 'h0;
reg [CTRL_WIDTH-1:0]             in_ctrl = 'h0;
reg                              in_wr   = 'h0;
wire                             in_rdy ;

wire[DATA_WIDTH-1:0]             out_data, out_data1;
wire[CTRL_WIDTH-1:0]             out_ctrl, out_ctrl1;
wire                             out_wr;
reg                             out_rdy;
    
reg [31:0] i_mem_addra[1:0];
reg [31:0] i_mem_din[1:0];
reg i_mem_we[1:0];
reg i_mem_w[1:0];

reg [7:0] d_mem_addra[1:0];
reg [63:0] d_mem_din [1:0];
wire [63:0] d_mem_out[1:0];
reg d_mem_we[1:0];

// software registers 
wire [31:0]                   mem_data_high;
wire [31:0]                   mem_data_low;
wire [31:0]                   mem_rd_data_high;
wire [31:0]                   mem_rd_data_low;
wire [31:0]                   mem_rd_addr;

wire [31:0]                   i_mem_dout, i_mem_dout1;
reg [31:0]                    pc_en;


wire [63:0] sram_data_out[1:0];//, sram_data_out1;
wire [9:0]  mem_addr_out[1:0];//, mem_addr_out1;
wire [63:0] mem_data_out[1:0];//, mem_data_out1;
wire mem_we[1:0];
wire stall[1:0];
wire almfull[1:0];
wire empty[1:0];
wire reb[1:0];	
reg clk = 1;
reg reset = 0;
reg reb_r[1:0];
wire full[1:0];

// clock
always #5 clk = ~clk;

   // Header parser signals
   wire [DATA_WIDTH-1:0] out_dataH, out_dataH2, out_dataHWacc, out_dataHWaccd;
   wire [CTRL_WIDTH-1:0] out_ctrlH, out_ctrlH2, out_ctrlHWacc, out_ctrlHWaccd;
   wire out_wrH, out_wrH2, out_wrHWacc, out_wrHWaccd;
   wire out_rdyHWacc, out_rdyHWacc_d, out_rdyF;
   wire [15:0] data_count, data_countd;
   wire payload, payloadd;
   wire [79:0] key = {16'h0123, 16'h4567, 16'h89ab, 16'hcdef, 16'h0123};
   
   // Instanse for Header parser.
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
	
	.out_data (out_dataH),
	.out_ctrl (out_ctrlH),
	.out_wr   (out_wrH),
	.out_rdy  (out_rdyHWacc),
    
	// output data 
	.data_count       (data_count),
	.o_inside_payload (payload)
   );

   // Instanse for HW Accelerator.
   hwaccelerator #(
     .DWIDTH (64)
  )
   inst_HWACC_encrypt  
  (
    .i_clock   (clk),
	.i_reset_n (~reset),
	
	.in_data   (out_dataH),
	.in_ctrl   (out_ctrlH),
	.in_wr     (out_wrH),
	.in_rdy    (out_rdyHWacc),
	
	.out_data  (out_dataHWacc),
	.out_ctrl  (out_ctrlHWacc),
	.out_wr    (out_wrHWacc),
	.out_rdy   (out_rdyF),
    
    .key       (key),
	.data_count(data_count),
	.inside_payload (payload),
	.path_sel  (pc_en[17:16])
 );	   

// signal decleration for 2 processor signals.
    wire [DATA_WIDTH-1:0]    out_data_r[1:0];
    wire [CTRL_WIDTH-1:0]    out_ctrl_r[1:0];
    wire                     out_wr_r  [1:0];

    assign out_rdyF = ~almfull[0] & ~stall[0];
	assign out_data = out_data_r[0];
	assign out_ctrl = out_ctrl_r[0];
	assign out_wr   = out_wr_r  [0];
	
  generate 
    for(genvar i = 0; i< 2; i= i+1) begin
      fifo_sram #(
        .DWIDTH  (72),
	    .IAWIDTH (10) // Address range is [0 to 1023]
	  ) inst_fifo_sram (
        .reset_n      (~reset & ~pc_en[4]),
        .clk          (clk),
	    .pc_en        (pc_en[0]), 
        .wea          (out_wrHWacc),
        .addra        ('h0),
        .dina         ('h0),
        .web          (mem_we[i]),
        .addrb        (mem_addr_out[i]),
        .dinb         ({8'h00, mem_data_out[i]}),
        .fifo_input   ({out_ctrlHWacc,out_dataHWacc}),
	    .reb          (reb[i]),
        .sram_data_out(sram_data_out[i]), 
        .fifo_output  ({out_ctrl_r[i],out_data_r[i]}),
	    .almfull      (almfull[i]),
	    .fifo_empty   (empty[i]),
	    .o_full       (full[i]),
	    .stall        (stall[i])
      );
	  
      assign reb[i] = out_rdy & !empty[i];
      //assign out_rdyF = ~almfull[i] & ~stall[i];
      assign out_wr_r[i] = reb_r[i];
      
      always @(posedge clk)
         reb_r[i] <= reb[i];
	  
      datapath inst_datapath (
	  	.i_mem_addra  (i_mem_addra[i]), 
	  	.i_mem_din    (i_mem_din[i]), 
	  	.i_mem_dout   (i_mem_dout[i]), 
	  	.i_mem_we     (i_mem_we[i]), 
	  	.d_mem_addra  (d_mem_addra[i][7:0]), 
	  	.d_mem_din    (d_mem_din[i]), 
	  	.d_mem_we     (d_mem_we[i]), 
	  	.d_mem_out    (d_mem_out[i]),
	  	// Memory access for FIFO and controller
	    .mem_datat_in (sram_data_out[i][63:0]),
	    .mem_addr_out (mem_addr_out[i]),
	    .mem_data_out (mem_data_out[i]),
	    .mem_we       (mem_we[i]),
	  
	  	.pc_en        (pc_en[0]), 
	  	.reset_n      (~reset), 
	  	.clk          (clk)
      );
   end
   endgenerate   

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
  
  // Always block checking for data.
  reg [15:0] indx = 'h0;
  reg diff = 1'b0;
  always @(posedge clk) begin
    if(out_wr) begin
	  indx = indx + 1'b1;
	  if(indx == PKT_SIZE-1)
	    indx <= 'h0;
	  if(data_mem[indx] != out_data)
	    diff <= 1'b1;
	end
  end  
  
  integer count;
  integer num_data_vals;
  // SEND DATA
  task send_data; begin
  	count = 0;
  	while(count != 39) begin
  	    d_mem_addra[0] <= count;
  	    d_mem_addra[1] <= count;
  		d_mem_din  [0] <= mem_ALU[count];
  		d_mem_din  [1] <= mem_ALU[count];
  		d_mem_we   [0] <= 1'b1;
  		d_mem_we   [1] <= 1'b1;
  		#10;
  		count = count + 1'b1;
  	end
  	    d_mem_addra[0] <= 'h0;
  	    d_mem_addra[1] <= 'h0;
  		d_mem_din  [0] <= 'h0;
  		d_mem_din  [1] <= 'h0;
  		d_mem_we   [0] <= 1'b0;
  		d_mem_we   [1] <= 1'b0;
  		#10;
  end
  endtask
  
  // SEND PACKET
  task send_packets; begin
  	count = 0;
  	while(count != 64)begin
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
  		in_wr       <= 1'b0;
  		#10;
  end
  endtask
  
  // SEND INSTR
  task send_instr; begin
  	count = 0;
  	while(count != NUM_INSTR) begin
  	    i_mem_addra[0] <= count;
  	    i_mem_addra[1] <= count;
  		i_mem_din[0]   <= istr_mem[count];
  		i_mem_din[1]   <= istr_mem[count];
  		i_mem_we[0]    <= 1'b1;
  		i_mem_we[1]    <= 1'b1;
  		#10;
  		count = count + 1'b1;
  	end
  	    i_mem_addra[0] <= 'h0;
  	    i_mem_addra[1] <= 'h0;
  		i_mem_din  [0] <= 'h0;
  		i_mem_din  [1] <= 'h0;
  		i_mem_we   [0] <= 1'b0;
  		i_mem_we   [1] <= 1'b0;
  		#10;
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
	pc_en[17:16] <= 2'b00;
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