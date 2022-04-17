module top_encryption(
input [63:0] in_data,
input [7:0] in_ctrl,
input         in_wr,
input clk,
output      in_rdy,

input [16*5-1:0] key,

output [63:0] out_data,
output [7:0]  out_ctrl,
output out_wr,
input  out_rdy
);

// Module 1.
wire [15:0] out_0,out_1,out_2,out_3;
single_stage_encryption stage_0(
.i_d0(in_data[15:0]),
.i_d1(in_data[31:16]),
.i_d2(in_data[47:32]),
.i_d3(in_data[63:48]),
.in_wr(in_wr),
.clk(clk),
.key(key[79:64]),
.o_d0(out_0),
.o_d1(out_1),
.o_d2(out_2),
.o_d3(out_3),
.o_wr(o_wr));


// Module 2.
wire [15:0] out_4,out_5,out_6,out_7;
single_stage_encryption stage_1(
.i_d0(out_0),
.i_d1(out_1),
.i_d2(out_2),
.i_d3(out_3),
.in_wr(in_wr),
.clk(clk),
.key(key[63:48]),
.o_d0(out_4),
.o_d1(out_5),
.o_d2(out_6),
.o_d3(out_7),
.o_wr(o_wr));


// Module 3.
wire [15:0] out_8,out_9,out_10,out_11;
single_stage_encryption stage_2(
.i_d0(out_4),
.i_d1(out_5),
.i_d2(out_6),
.i_d3(out_7),
.in_wr(in_wr),
.clk(clk),
.key(key[47:32]),
.o_d0(out_8),
.o_d1(out_9),
.o_d2(out_10),
.o_d3(out_11),
.o_wr(o_wr));

// Module 4.
wire [15:0] out_12,out_13,out_14,out_15;
single_stage_encryption stage_3(
.i_d0(out_8),
.i_d1(out_9),
.i_d2(out_10),
.i_d3(out_11),
.in_wr(in_wr),
.clk(clk),
.key(key[31:16]),
.o_d0(out_12),
.o_d1(out_13),
.o_d2(out_14),
.o_d3(out_15),
.o_wr(o_wr));


// Module 5
wire [15:0] out_16,out_17,out_18,out_19;
single_stage_encryption stage_4(
.i_d0(out_12),
.i_d1(out_13),
.i_d2(out_14),
.i_d3(out_15),
.in_wr(in_wr),
.clk(clk),
.key(key[15:0]),
.o_d0(out_16),
.o_d1(out_17),
.o_d2(out_18),
.o_d3(out_19),
.o_wr(o_wr));


assign out_data = {out_18,out_19,out_16,out_17};
                // 2        1       4       3

endmodule

