// Code your testbench here
// or browse Examples
module encryption_tb();
  
  // inputs:
  reg[15:0] i_d0;
  reg[15:0] i_d1;
  reg[15:0] i_d2;
  reg[15:0] i_d3;
  reg in_wr;
  reg [79:0] key;
  reg clk;
  
  //outputs:
  wire [15:0] o_d0;
  wire [15:0] o_d1;
  wire [15:0] o_d2;
  wire [15:0] o_d3;
  wire o_wr;
  wire [63:0] out_data;
  
  //single_stage_encryption dut(.i_d0(i_d0), .i_d1(i_d1), .clk(clk), .i_d2(i_d2), .i_d3(i_d3), .in_wr(in_wr), .key(key), .o_d0(o_d0), .o_d1(o_d1), .o_d2(o_d2), .o_d3(o_d3));
  
  top_encryption dut(.in_data(64'h1123456789abcdef), .key({16'h0123, 16'h4567, 16'h89ab, 16'hcdef, 16'h0123}), .clk(clk), .in_ctrl(0), .in_rdy(), .out_data(out_data), .in_wr(0), .out_ctrl(), .out_wr(), .out_rdy());

  initial begin
    clk=0;
     forever #5 clk = ~clk; 
  end
  
  /*
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
      #1000
  	  $finish;
    end
  */
endmodule
