module top_encryption(
input clk,
input reset_n,
input [63:0] in_data,
input [7:0]  in_ctrl,
input        in_wr,
output       in_rdy,

input [16*5-1:0] key,
input inside_payload,

output reg [63:0] out_data,
output [7:0]  out_ctrl,
output out_wr,
input  out_rdy
);

reg [5:0] inside_payload_r;
reg [5:0] in_rdy_r, out_wr_r;
reg [7:0] out_ctrl_r [5:0];

//genvar i;
always @(posedge clk) begin
  if(!reset_n) begin
      //in_rdy_r <= 'h0;
      out_wr_r <= 'h0;
  end
  else begin
      // pass valid with a delay of 5 clocks.
      //in_rdy_r <= {in_rdy_r[3:0],out_rdy};
	  inside_payload_r <= {inside_payload_r[4:0],inside_payload};
      out_wr_r <= {out_wr_r[4:0],in_wr};
  end	  
end
//assign in_rdy = in_rdy_r[4];
assign in_rdy = out_rdy;
assign out_wr = out_wr_r[5];

// pipelining the out_ctrl for 5 clocks.
generate
  // Final output.
  assign out_ctrl = out_ctrl_r[5];
  for(genvar i = 1; i<6; i=i+1)
      always @(posedge clk) begin
	    out_ctrl_r[i] <= out_ctrl_r[i-1];
	  end
  always @(posedge clk) begin
      out_ctrl_r[0] <= in_ctrl;
  end
endgenerate

// Module 1.
wire [15:0] out_0,out_1,out_2,out_3;
single_stage_encryption stage_0(
  .i_d0 (in_data[15:0]),
  .i_d1 (in_data[31:16]),
  .i_d2 (in_data[47:32]),
  .i_d3 (in_data[63:48]),
  .clk  (clk),
  .key  (key[79:64]),
  .o_d0 (out_0),
  .o_d1 (out_1),
  .o_d2 (out_2),
  .o_d3 (out_3)
);


// Module 2.
wire [15:0] out_4,out_5,out_6,out_7;
single_stage_encryption stage_1(
  .i_d0 (out_0),
  .i_d1 (out_1),
  .i_d2 (out_2),
  .i_d3 (out_3),
  .clk  (clk),
  .key  (key[63:48]),
  .o_d0 (out_4),
  .o_d1 (out_5),
  .o_d2 (out_6),
  .o_d3 (out_7)
);


// Module 3.
wire [15:0] out_8,out_9,out_10,out_11;
single_stage_encryption stage_2(
  .i_d0 (out_4),
  .i_d1 (out_5),
  .i_d2 (out_6),
  .i_d3 (out_7),
  .clk  (clk),
  .key  (key[47:32]),
  .o_d0 (out_8),
  .o_d1 (out_9),
  .o_d2 (out_10),
  .o_d3 (out_11)
);

// Module 4.
wire [15:0] out_12,out_13,out_14,out_15;
single_stage_encryption stage_3(
  .i_d0 (out_8),
  .i_d1 (out_9),
  .i_d2 (out_10),
  .i_d3 (out_11),
  .clk  (clk),
  .key  (key[31:16]),
  .o_d0 (out_12),
  .o_d1 (out_13),
  .o_d2 (out_14),
  .o_d3 (out_15)
);


// Module 5
wire [15:0] out_16,out_17,out_18,out_19;
single_stage_encryption stage_4(
  .i_d0  (out_12),
  .i_d1  (out_13),
  .i_d2  (out_14),
  .i_d3  (out_15),
  .clk   (clk),
  .key   (key[15:0]),
  .o_d0  (out_16),
  .o_d1  (out_17),
  .o_d2  (out_18),
  .o_d3  (out_19)
);

wire [63:0] out_dataE;
assign out_dataE = {out_18,out_19,out_16,out_17};
                // 2        1       4       3

reg [63:0] out_data_r [4:0];
// pipelining the out_ctrl for 5 clocks.
generate
  for(genvar i = 1; i<5; i=i+1)
      always @(posedge clk) begin
	    out_data_r[i] <= out_data_r[i-1];
	  end
  // Final output.
  always @(posedge clk) begin
      out_data_r[0] <= in_data;
      if(inside_payload_r[4])
          out_data <= out_dataE;
	  else 
          out_data <= out_data_r[4];
  end
endgenerate
endmodule

