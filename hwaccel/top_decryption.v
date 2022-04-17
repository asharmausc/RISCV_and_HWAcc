module top_decryption(
input clk,
input [63:0] in_data,
input [7:0] in_ctrl,
input         in_wr,
output      in_rdy,

input [16*5-1:0] key,

output [63:0] out_data,
output [7:0]   out_ctrl,
output           out_wr,
input              out_rdy
);

wire [63:0] out_data1, out_data2, out_data3, out_data4;
// Module 1.
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

  .o_d0      (out_data[31:16]),
  .o_d1      (out_data[15:0]),
  .o_d2      (out_data[63:48]),
  .o_d3      (out_data[47:32]),

  .clk       (clk)
);


endmodule
