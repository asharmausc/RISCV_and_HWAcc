module top_decryption(
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
output        out_wr,
input         out_rdy
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
wire [63:0] out_data1, out_data2, out_data3, out_data4, out_dataD;
single_stage_decryption inst_single_stage_decryption_1(
  .i_d0      (in_data[15:0]),
  .i_d1      (in_data[31:16]),
  .i_d2      (in_data[47:32]),
  .i_d3      (in_data[63:48]),
  .key       (key[15:0]),

  .o_d0      (out_data1[15:0]),
  .o_d1      (out_data1[31:16]),
  .o_d2      (out_data1[47:32]),
  .o_d3      (out_data1[63:48]),

  .clk       (clk)
);
// Module 2.
single_stage_decryption inst_single_stage_decryption_2(
  .i_d0      (out_data1[15:0]),
  .i_d1      (out_data1[31:16]),
  .i_d2      (out_data1[47:32]),
  .i_d3      (out_data1[63:48]),
  .key       (key[31:16]),

  .o_d0      (out_data2[15:0]),
  .o_d1      (out_data2[31:16]),
  .o_d2      (out_data2[47:32]),
  .o_d3      (out_data2[63:48]),

  .clk       (clk)
);
// Module 3.
single_stage_decryption inst_single_stage_decryption_3(
  .i_d0      (out_data2[15:0]),
  .i_d1      (out_data2[31:16]),
  .i_d2      (out_data2[47:32]),
  .i_d3      (out_data2[63:48]),
  .key       (key[47:32]),

  .o_d0      (out_data3[15:0]),
  .o_d1      (out_data3[31:16]),
  .o_d2      (out_data3[47:32]),
  .o_d3      (out_data3[63:48]),

  .clk       (clk)
);
// Module 4.
single_stage_decryption inst_single_stage_decryption_4(
  .i_d0      (out_data3[15:0]),
  .i_d1      (out_data3[31:16]),
  .i_d2      (out_data3[47:32]),
  .i_d3      (out_data3[63:48]),
  .key       (key[63:48]),

  .o_d0      (out_data4[15:0]),
  .o_d1      (out_data4[31:16]),
  .o_d2      (out_data4[47:32]),
  .o_d3      (out_data4[63:48]),

  .clk       (clk)
);
// Module 5
single_stage_decryption inst_single_stage_decryption_5(
  .i_d0      (out_data4[15:0]),
  .i_d1      (out_data4[31:16]),
  .i_d2      (out_data4[47:32]),
  .i_d3      (out_data4[63:48]),
  .key       (key[79:64]),

  .o_d0      (out_dataD[31:16]),
  .o_d1      (out_dataD[15:0]),
  .o_d2      (out_dataD[63:48]),
  .o_d3      (out_dataD[47:32]),

  .clk       (clk)
);


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
          out_data <= out_dataD;
	  else 
          out_data <= out_data_r[4];
  end
endgenerate

endmodule
