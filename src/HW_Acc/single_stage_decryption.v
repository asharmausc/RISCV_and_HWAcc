// Code your design here
module single_stage_decryption(
/* input, output ports*/
  input [15:0] i_d0,
  input [15:0] i_d1,
  input [15:0] i_d2,
  input [15:0] i_d3,
  input in_wr,
  input clk,
  input [15:0] key,
  
  output reg[15:0] o_d0,
  output reg[15:0] o_d1,
  output reg[15:0] o_d2,
  output reg[15:0] o_d3,
  output o_wr
);

  parameter [15:0]cons1 = 16'hffff;
  parameter [15:0]cons2 = {12'h000,4'hf};
  parameter [15:0]Q11_cons = {12'h000,4'b1100};
  parameter [7:0] P11_cons = {4'h0,4'hf};
  
  reg [3:0] P[15:0];
  reg [3:0] Q[15:0];

  always@(posedge clk) begin
    
  P[0] <= 4'd3; 
  P[1] <= 4'd15;
  P[2] <= 4'd14;
  P[3] <= 4'd0;
  P[4] <= 4'd5;
  P[5] <= 4'd4;
  P[6] <= 4'd11;
  P[7] <= 4'd12;
  P[8] <= 4'd13;
  P[9] <= 4'd10;
  P[10] <= 4'd9; 
  P[11] <= 4'd6;
  P[12] <= 4'd7;
  P[13] <= 4'd8;
  P[14] <= 4'd2;
  P[15] <= 4'd1; 
  
 
  Q[0] <= 4'd9;
  Q[1] <= 4'd14;
  Q[2] <= 4'd5;
  Q[3] <= 4'd6;
  Q[4] <= 4'd10;
  Q[5] <= 4'd2;
  Q[6] <= 4'd3;
  Q[7] <= 4'd12;
  Q[8] <= 4'd15;
  Q[9] <= 4'd0;
  Q[10] <= 4'd4; 
  Q[11] <= 4'd13;
  Q[12] <= 4'd7;
  Q[13] <= 4'd11;
  Q[14] <= 4'd1;
  Q[15] <= 4'd8;
    
  end

wire [15:0] P10,Q10,P20,Q20,Q11,P11,Q21,P21,P12,Q12,P22,Q22;
wire [15:0] P10_1,Q10_1,P20_1,Q20_1,Q11_1,P11_1,Q21_1,P21_1,P12_1,Q12_1,P22_1,Q22_1;
wire [15:0] d1_1,d2_1,d3_1,d4_1, d1_0_f, d4_0_f;


  assign d1_1 = ((~(i_d0 ^ key)) & (cons1));

  assign P10 = P[i_d3>>12];
  assign Q10= Q[(i_d3>>8) & cons2];
  assign P20= P[(i_d3>>4)  & cons2];
  assign Q20= Q[i_d3  &  cons2];
  assign Q11= Q[(P10 & Q11_cons) | (Q10 >> 2)];
  assign P11= P[((P10 << 2) | (P20 >> 2)) & 8'h0f];
  assign Q21= Q[((Q10 << 2) | (Q20 >> 2)) & 8'h0f];
  assign P21= P[(Q20 & 4'b0011) | ((P20 << 2) & 4'b1100)];
  assign P12= P[(Q11 & 4'b1100) | (P11 >> 2)];
  assign Q12= Q[((Q11 << 2) | (Q21 >> 2)) & 8'h0f];
  assign P22= P[((P11 << 2) | (P21 >> 2)) & 8'h0f];
  assign Q22= Q[(P21 & 4'b0011) | ((Q21 << 2) & 4'b1100)];
 
  assign d4_0_f = (P12<<12) | (Q12 << 8) | (P22 <<4) | Q22;

  assign d2_1 =  (d4_0_f ^ i_d2) & 20'h0ffff;
  assign d4_1 = ~(i_d3 ^ key) & 20'h0ffff;

  assign P10_1 = P[i_d0>>12];
  assign Q10_1 = Q[i_d0>>8  & 16'h000f];
  assign P20_1 = P[i_d0>>4  & 16'h000f];
  assign Q20_1 = Q[i_d0     & 16'h000f];
  assign Q11_1 = Q[(P10_1 & 4'b1100) | (Q10_1 >> 2)];
  assign P11_1 = P[((P10_1 << 2) | (P20_1 >> 2)) & P11_cons];
  assign Q21_1 = Q[((Q10_1 << 2) | (Q20_1 >> 2)) & 8'h0f];
  assign P21_1 = P[(Q20_1 & 4'b0011) | ((P20_1 << 2) & 4'b1100)];
  assign P12_1 = P[(Q11_1 & 4'b1100) | (P11_1 >> 2)];
  assign Q12_1 = Q[((Q11_1 << 2) | (Q21_1 >> 2)) & 16'h000f];
  assign P22_1 = P[((P11_1 << 2) | (P21_1 >> 2)) & 8'h0f];
  assign Q22_1 = Q[(P21_1 & 16'h0003) | ((Q21_1 << 2) & 16'h000c)];

  assign d1_0_f = (P12_1<<12) | (Q12_1 << 8) | (P22_1 <<4) | Q22_1;

  assign d3_1 = (d1_0_f ^ i_d1)  & 20'h0ffff;

  always @(posedge clk) begin
  	o_d0 <= d2_1;
	o_d1 <= d1_1;
	o_d2 <= d4_1;
	o_d3 <= d3_1;
  end

endmodule

