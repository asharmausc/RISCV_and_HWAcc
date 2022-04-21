// =========================================
// This is the top module for HW Accelerator
// it servs as an interface between FIFO SRAM
// and header parser. Both encryption and 
// decryption are included in this module.
// Choose anyone according to need.
// =========================================

// PATH Select : 00 - ALU,
//               01 - Encrypt,
//               10 - Decrypt.

// Latency = 7 clock cycles.
module hwaccelerator #(
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
	input  reg                  out_rdy,
    
    input [79:0] key,
	input [15:0] data_count,
	input        inside_payload,
	input [1:0]  path_sel
 );
 
  wire [DWIDTH-1:0]     out_dataE, out_dataD;
  wire [CTRL_WIDTH-1:0] out_ctrlE, out_ctrlD;
  wire out_wrE, out_wrD;
  wire in_rdyE, in_rdyD;
 
  top_encryption inst_encryption(
    .clk      (i_clock),
    .reset_n  (i_reset_n),
    .in_data  (in_data),
    .in_ctrl  (in_ctrl),
    .in_wr    (in_wr),
    .in_rdy   (in_rdyE),
    .key      (key),
    
	.inside_payload (inside_payload),
    .out_data (out_dataE),
    .out_ctrl (out_ctrlE),
    .out_wr   (out_wrE),
    .out_rdy  (out_rdy)
  );
  
  top_decryption inst_decryption(
    .clk      (i_clock),
    .reset_n  (i_reset_n),
    .in_data  (in_data),
    .in_ctrl  (in_ctrl),
    .in_wr    (in_wr),
    .in_rdy   (in_rdyD),
    .key      (key),
    
	.inside_payload (inside_payload),
    .out_data (out_dataD),
    .out_ctrl (out_ctrlD),
    .out_wr   (out_wrD),
    .out_rdy  (out_rdy)
  );

  always @(posedge i_clock) begin
    if(!i_reset_n)
	  out_wr <= 1'b0;
	else begin
	  case(path_sel)
	  2'b01 : out_wr <= out_wrE;
	  2'b10 : out_wr <= out_wrD;
	  default : out_wr <= in_wr;
	  endcase
	end
	
	case(path_sel)
	2'b01: begin
	       out_data <= out_dataE;
           out_ctrl <= out_ctrlE;
		   in_rdy   <= in_rdyE;
		end
	2'b10: begin
	       out_data <= out_dataD;
           out_ctrl <= out_ctrlD;
		   in_rdy   <= in_rdyD;
		end
	default: begin
	       out_data <= in_data;
           out_ctrl <= in_ctrl;
		   in_rdy   <= out_rdy;
		end
	endcase
  end
endmodule