module regx4 #(
	parameter D_WIDTH = 64
)(
    input clk,
	input reset_n,
	
    input [D_WIDTH-1:0] data_WB,
	input ctrl_WB,
	
	input [4:0] reg_wraddr,
	input [4:0] rs1_ID,
	input [4:0] rs2_ID,
	
	input [3:0] thread_sel_ID,
	input [3:0] thread_sel_WB,
	
	output [D_WIDTH-1:0] reg1data1,
	output [D_WIDTH-1:0] reg2data1,
	output [D_WIDTH-1:0] reg1data2,
	output [D_WIDTH-1:0] reg2data2
);
    wire [5:0] reg_wraddr1;
    wire [5:0] reg_wraddr2;

    reg [3:0]  thread_sel_ID_r;
	
	wire [D_WIDTH-1:0] reg1data_file1;
	wire [D_WIDTH-1:0] reg2data_file1;
	
	wire [D_WIDTH-1:0] reg1data_file2;
	wire [D_WIDTH-1:0] reg2data_file2;

    assign reg1data1 = reg1data_file1;
	assign reg2data1 = reg2data_file1;
	assign reg1data2 = reg1data_file2;
	assign reg2data2 = reg2data_file2;

   assign reg_wraddr1 = (ctrl_WB & (thread_sel_WB[0] | thread_sel_WB[2])) ? {thread_sel_WB[2], reg_wraddr} : {thread_sel_ID[2], rs1_ID}; //thread 1 0-31 or 3 32-63
   reg_file inst_reg_file_1 (
        .addra(reg_wraddr1), 
        .addrb({thread_sel_ID[2], rs2_ID}), 
        .clka(clk), 
        .clkb(clk), 
        .dina(data_WB), 
        .dinb(), 
        .wea(ctrl_WB & (thread_sel_WB[0] | thread_sel_WB[2])), 
        .web(1'b0), 
        .douta(reg1data_file1), 
        .doutb(reg2data_file1)
	);

   assign reg_wraddr2 = (ctrl_WB & (thread_sel_WB[1] | thread_sel_WB[3])) ? {thread_sel_WB[3], reg_wraddr} : {thread_sel_ID[3], rs1_ID}; //thread 2 or 4
   reg_file inst_reg_file_2 (
        .addra(reg_wraddr2), 
        .addrb({thread_sel_ID[3], rs2_ID}), 
        .clka(clk), 
        .clkb(clk), 
        .dina(data_WB), 
        .dinb(), 
        .wea(ctrl_WB & (thread_sel_WB[1] | thread_sel_WB[3])), 
        .web(1'b0), 
        .douta(reg1data_file2), 
        .doutb(reg2data_file2)
	);
	
	//always @(posedge clk) begin
	//    thread_sel_ID_r <= thread_sel_ID;
	////always @(*) begin
    //    reg1data <= 'h0;
    //    reg2data <= 'h0;
	//    if(thread_sel_ID_r[0] | thread_sel_ID_r[2]) begin
    //        reg1data <= reg1data_file1;
    //        reg2data <= reg2data_file1;
	//	end
	//    else if(thread_sel_ID_r[1] | thread_sel_ID_r[3]) begin
    //        reg1data <= reg1data_file2;
    //        reg2data <= reg2data_file2;
	//	end
	//end
endmodule