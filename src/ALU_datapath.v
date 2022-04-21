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

module ALU_datapath  
   #(
      parameter DATA_WIDTH = 64,
      parameter CTRL_WIDTH = DATA_WIDTH/8,
      parameter UDP_REG_SRC_WIDTH = 2
   )
   (
      input  [DATA_WIDTH-1:0]             in_data,
      input  [CTRL_WIDTH-1:0]             in_ctrl,
      input                               in_wr,
      output                              in_rdy,

      output [DATA_WIDTH-1:0]             out_data,
      output [CTRL_WIDTH-1:0]             out_ctrl,
      output                              out_wr,
      input                               out_rdy,
   
      // --- Register interface
      input                               reg_req_in,
      input                               reg_ack_in,
      input                               reg_rd_wr_L_in,
      input  [`UDP_REG_ADDR_WIDTH-1:0]    reg_addr_in,
      input  [`CPCI_NF2_DATA_WIDTH-1:0]   reg_data_in,
      input  [UDP_REG_SRC_WIDTH-1:0]      reg_src_in,

      output                              reg_req_out,
      output                              reg_ack_out,
      output                              reg_rd_wr_L_out,
      output  [`UDP_REG_ADDR_WIDTH-1:0]   reg_addr_out,
      output  [`CPCI_NF2_DATA_WIDTH-1:0]  reg_data_out,
      output  [UDP_REG_SRC_WIDTH-1:0]     reg_src_out,

      // misc
      input                                reset,
      input                                clk
   );
   
   // software registers 
   wire [31:0]                   mem_data_high;
   wire [31:0]                   mem_data_low;
   wire [31:0]                   mem_addr_and_en;
   wire [31:0]                   mem_rd_data_high;
   wire [31:0]                   mem_rd_data_low;
   wire [31:0]                   mem_rd_addr;
 
   wire [31:0]                   istr_data;
   wire [31:0]                   istr_addr_and_en;
   wire [31:0]                   istr_rd_data;
   wire [31:0]                   pc_en;
   // hardware registers
   reg [31:0]                    matches;
   
   
   wire [71:0] sram_data_out;
   wire [9:0]  mem_addr_out;
   wire [63:0] mem_data_out;
   wire  mem_we, stall, reb, empty, almfull;      
   reg reb_r;
   wire full;
   
   // Header parser signals
   wire [DATA_WIDTH-1:0] out_dataH, out_dataHWacc;
   wire [CTRL_WIDTH-1:0] out_ctrlH, out_ctrlHWacc;
   wire out_wrH, out_wrHWacc;
   wire out_rdyHWacc, out_rdyF;
   wire [15:0] data_count;
   wire payload;
   wire [79:0] key;
   
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
   inst_HWACC  
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
      .web          (mem_we),
      .addrb        (mem_addr_out),
      .dinb         ({8'h00, mem_data_out}),
      .fifo_input   ({out_ctrlHWacc,out_dataHWacc}),
	  .reb          (reb),
      .sram_data_out(sram_data_out), 
      .fifo_output  ({out_ctrl,out_data}),
	  .almfull      (almfull),
	  .fifo_empty   (empty),
	  .o_full       (full),
	  .stall        (stall)
    );
	
   assign reb = out_rdy & !empty;
   assign out_rdyF = ~almfull & ~stall;
   assign out_wr = reb_r;
   
   always @(posedge clk)
       reb_r <= reb;
   
   reg [15:0] out_count;
   reg [15:0] in_count;
   always @(posedge clk) begin
       if(reset) begin
           in_count  <= 'h0;
	       out_count <= 'h0;
       end
       else begin
          if(in_wr)
	           in_count  <= in_count + 1'b1;
	      if(out_wr)
	           out_count <= out_count + 1'b1;
       end
   end
   datapath inst_datapath (
		.i_mem_addra  (istr_addr_and_en), 
		.i_mem_din    (istr_data), 
		.i_mem_dout   (istr_rd_data), 
		.i_mem_we     (istr_addr_and_en[9]), 
		.d_mem_addra  (mem_addr_and_en[7:0]), 
		.d_mem_din    ({mem_data_high, mem_data_low}), 
		.d_mem_we     (mem_addr_and_en[8]), 
		.d_mem_out    ({mem_rd_data_high, mem_rd_data_low}),
		// Memory access for FIFO and controller
	    .mem_datat_in (sram_data_out[63:0]),
	    .mem_addr_out (mem_addr_out),
	    .mem_data_out (mem_data_out),
	    .mem_we       (mem_we),

		.pc_en        (pc_en[0]), 
		.reset_n      (~reset), 
		.clk          (clk)
   );
   

   generic_regs
   #( 
      .UDP_REG_SRC_WIDTH   (UDP_REG_SRC_WIDTH),
      .TAG                 (`ALU_DATAPATH_BLOCK_ADDR),          // Tag -- eg. MODULE_TAG
      .REG_ADDR_WIDTH      (`ALU_DATAPATH_REG_ADDR_WIDTH),     // Width of block addresses -- eg. MODULE_REG_ADDR_WIDTH
      .NUM_COUNTERS        (0),                 // Number of counters
      .NUM_SOFTWARE_REGS   (7),                 // Number of sw regs
      .NUM_HARDWARE_REGS   (4)                  // Number of hw regs
   ) module_regs (
      .reg_req_in       (reg_req_in),
      .reg_ack_in       (reg_ack_in),
      .reg_rd_wr_L_in   (reg_rd_wr_L_in),
      .reg_addr_in      (reg_addr_in),
      .reg_data_in      (reg_data_in),
      .reg_src_in       (reg_src_in),

      .reg_req_out      (reg_req_out),
      .reg_ack_out      (reg_ack_out),
      .reg_rd_wr_L_out  (reg_rd_wr_L_out),
      .reg_addr_out     (reg_addr_out),
      .reg_data_out     (reg_data_out),
      .reg_src_out      (reg_src_out),

      // --- counters interface
      .counter_updates  (),
      .counter_decrement(),

      // --- SW regs interface
      .software_regs    ({key, pc_en, istr_addr_and_en, istr_data, mem_addr_and_en, mem_data_high, mem_data_low}),

      // --- HW regs interface
      //.hardware_regs    ({{out_count, empty, full, almfull, stall, in_count[11:0]}, istr_rd_data, mem_rd_data_high, mem_rd_data_low}),
      .hardware_regs    ({{28'h0000000, empty, full, almfull, stall}, istr_rd_data, mem_rd_data_high, mem_rd_data_low}),

      .clk              (clk),
      .reset            (reset)
    );

endmodule 
