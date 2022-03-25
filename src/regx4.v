module regx4 #(
	parameter D_WIDTH = 64
)(
    input clk,
	input reset_n,
	
    input [D_WIDTH-1:0] data_WB,
	input ctrl_WB,
	
	input [4:0] reg_wraddr,
	input [4:0] rs2_ID,
	
	input [3:0] thread_sel_ID,
	input [3:0] thread_sel_WB,
	
	output reg [D_WIDTH-1:0] reg1data,
	output reg [D_WIDTH-1:0] reg2data

);

	wire [D_WIDTH-1:0] reg1data_file1;
	wire [D_WIDTH-1:0] reg2data_file1;
	
	wire [D_WIDTH-1:0] reg1data_file2;
	wire [D_WIDTH-1:0] reg2data_file2;

	wire [D_WIDTH-1:0] reg1data_file3;
	wire [D_WIDTH-1:0] reg2data_file3;

	wire [D_WIDTH-1:0] reg1data_file4;
	wire [D_WIDTH-1:0] reg2data_file4;



   reg_file inst_reg_file_1 (
        .addra(reg_wraddr), 
        .addrb(rs2_ID), 
        .clka(clk), 
        .clkb(clk), 
        .dina(data_WB), 
        .dinb(), 
        .wea(ctrl_WB & thread_sel_WB[0]), 
        .web(1'b0), 
        .douta(reg1data_file1), 
        .doutb(reg2data_file1)
	);
	
   reg_file inst_reg_file_2 (
        .addra(reg_wraddr), 
        .addrb(rs2_ID), 
        .clka(clk), 
        .clkb(clk), 
        .dina(data_WB), 
        .dinb(), 
        .wea(ctrl_WB & thread_sel_WB[1]), 
        .web(1'b0), 
        .douta(reg1data_file2), 
        .doutb(reg2data_file2)
	);

   reg_file inst_reg_file_3 (
        .addra(reg_wraddr), 
        .addrb(rs2_ID), 
        .clka(clk), 
        .clkb(clk), 
        .dina(data_WB), 
        .dinb(), 
        .wea(ctrl_WB & thread_sel_WB[2]), 
        .web(1'b0), 
        .douta(reg1data_file3), 
        .doutb(reg2data_file3)
	);

   reg_file inst_reg_file_4 (
        .addra(reg_wraddr), 
        .addrb(rs2_ID), 
        .clka(clk), 
        .clkb(clk), 
        .dina(data_WB), 
        .dinb(), 
        .wea(ctrl_WB & thread_sel_WB[3]), 
        .web(1'b0), 
        .douta(reg1data_file4), 
        .doutb(reg2data_file4)
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
                reg1data = reg1data_file3;
                reg2data = reg2data_file3;
            end
            4'b1000: begin
                reg1data = reg1data_file4;
                reg2data = reg2data_file4;
            end
			default: begin
                reg1data = 'h0;
                reg2data = 'h0;
			end
        endcase
	end
endmodule

