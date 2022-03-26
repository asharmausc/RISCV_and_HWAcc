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
	
	output reg [D_WIDTH-1:0] reg1data,
	output reg [D_WIDTH-1:0] reg2data

);
    wire [5:0] reg_wraddr1;
    wire [5:0] reg_wraddr2;

    reg [3:0]  thread_sel_ID_r;
	
	wire [D_WIDTH-1:0] reg1data_file1;
	wire [D_WIDTH-1:0] reg2data_file1;
	
	wire [D_WIDTH-1:0] reg1data_file2;
	wire [D_WIDTH-1:0] reg2data_file2;

   assign reg_wraddr1 = (ctrl_WB & (thread_sel_WB[0] | thread_sel_WB[2])) ? {thread_sel_WB[2], reg_wraddr} : {thread_sel_ID[2], rs1_ID}; //thread 1 0-31 or 3 32-63
   reg_file inst_reg_file_1 (
        .addra(reg_wraddr1), 
        .addrb({thread_sel_ID[2], rs2_ID}), 
        .clka(clk), 
        .clkb(clk), 
        .dina(data_WB), 
        .dinb(), 
        .wea(ctrl_WB & thread_sel_WB[0]), 
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
        .wea(ctrl_WB & thread_sel_WB[1]), 
        .web(1'b0), 
        .douta(reg1data_file2), 
        .doutb(reg2data_file2)
	);
	
	always @(posedge clk)
	    thread_sel_ID_r <= thread_sel_ID;
		
	always @(*) begin
	        case(thread_sel_ID_r)
            4'b0001: begin
                reg1data = reg1data_file1;
                reg2data = reg2data_file1;
            end
            4'b0010: begin
                reg1data = reg1data_file2;
                reg2data = reg2data_file2;
            end
            4'b0100: begin
                reg1data = reg1data_file1;
                reg2data = reg2data_file1;
            end
            4'b1000: begin
                reg1data = reg1data_file2;
                reg2data = reg2data_file2;
            end
			default: begin
                reg1data = 'h0;
                reg2data = 'h0;
			end
        endcase
	end
endmodule

