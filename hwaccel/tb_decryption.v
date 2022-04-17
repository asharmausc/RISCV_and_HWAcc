// Code your testbench here
// or browse Examples
module decryption_tb();
  
  // inputs:
  reg [63:0] in_data;
  reg in_wr;
  reg [80:0] key;
  reg clk;
  
  //outputs:
  wire [63:0] out_data;
  wire o_wr;
  
  top_decryption dut(
    .in_data      (in_data),
    .out_data     (out_data),
    .key          (key),
    .clk          (clk)
  );
  
  initial begin
   
   in_data = 64'h1123456789abcdef;

   key = 80'h0123456789abcdef0123;
  end
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
