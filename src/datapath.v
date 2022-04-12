module datapath #(
    parameter PC_WIDTH = 32,
	parameter D_WIDTH = 64,
	parameter ISTR_WIDTH = 32
  )
  (
  
    input       clk,
    input       reset_n,
	
    input [7:0]             d_mem_addra, // 256 locations.
    input [D_WIDTH-1:0]     d_mem_din,   // 64 bit data input
    input                   d_mem_we,
	
    input [PC_WIDTH-1:0]    i_mem_addra,
    input [ISTR_WIDTH- 1:0] i_mem_din,
    input i_mem_we,
	
    input pc_en,
    
	// Memory access output signals
	input  [63:0] mem_datat_in,
	output [9:0] mem_addr_out,
	output [63:0] mem_data_out,
	output mem_we,
	
	output [63:0] d_mem_out,
    output [31:0] i_mem_dout
   );
   
   reg [PC_WIDTH-1:0] pc;
   wire [PC_WIDTH-1:0] pc_EX, pc_ID;
   wire [PC_WIDTH-1:0] jump_pc, jump_addr_MEM, jump_addr;
   wire [PC_WIDTH-1:0] branch_addr_MEM, branch_addr;
   
   wire [ISTR_WIDTH-1:0] instr, instr_ID;
   wire [4:0] rd_ID, rd_EX, rd_MEM, raddr_WB;
   wire [4:0] rs1_ID;
   wire [4:0] rs2_ID, reg_wraddr;
   wire [11:0] immed_ID;
   wire [9:0] func_ID;
   wire [9:0] func_EX;
   wire [19:0] joffset_ID;
   wire [19:0] joffset_EX;
   wire [6:0] ctrl_ID, ctrl_EX, ctrl_MEM, ctrl_WB;
   
   wire [D_WIDTH-1:0] reg1data;
   wire [D_WIDTH-1:0] reg2data, reg2data_MEM, mem_write_data;
   wire [D_WIDTH-1:0] data_WB;
   wire [D_WIDTH-1:0] sign_immed_ID;
   wire [D_WIDTH-1:0] sign_immed_EX;
   wire [ISTR_WIDTH-1:0] sign_immed_auipc;
   wire [D_WIDTH-1:0] alu_op0;
   wire [D_WIDTH-1:0] alu_op1;
   wire [D_WIDTH-1:0] ALU_out;
   wire [D_WIDTH-1:0] ALU_out_MEM;
   wire [D_WIDTH-1:0] ALU_out_WB, data_MEM;
   
   wire greaterthan, lessthan, equal,byte_op,byte_op_MEM,byte_op_WB;
   wire branch_taken_EX;
   wire branch_taken_MEM;
   wire branch_taken;
    
   reg [1:0] four_count;
   // -----------------------------------------
   always @(posedge clk) begin
       if(!reset_n) begin
	       pc         <= 'h0;
		   four_count <= 'h0;
	   end
	   else begin
		   if(pc_en) begin
		       pc <= pc + 1'b1;
			   four_count <= four_count + 1'b1;
	           if(branch_taken)
		           pc <= jump_pc;
		   end
	   end
   end
   
   i_mem inst_imem(
        .addra(i_mem_addra[8:0]), 
        .addrb(pc[10:2]), 
        .clka(clk), 
        .clkb(clk), 
        .dina(i_mem_din), 
        .wea(i_mem_we), 
        .doutb(instr)
	);
	
	// ---- PIPE LINE Register ----
		
    pipelinereg # (
       .DWIDTH (PC_WIDTH)
	) inst_IF_ID (
	    .clk    (clk),
	    .reset_n(reset_n),
	    .en     (pc_en),
	    .i_data ({pc}),
	    .o_data ({pc_ID})
	);
	// ---- PIPE LINE Register ----
    // ----------------------------------------
    assign instr_ID = (four_count == 2'b01) ? instr : 'h0;
    decoder inst_decoder(
     .clk     (clk),
     .reset_n (reset_n),
     .instr   (instr_ID),
     .pc      (pc_ID),  
    
     .rd      (rd_ID),
     .rs1     (rs1_ID),
     .rs2     (rs2_ID),
     .immed   (immed_ID),
     .func    (func_ID),
     .joffset (joffset_ID),
     .ctrl    (ctrl_ID)
    );
   
   assign sign_immed_ID = (ctrl_ID[6])? ({{32{joffset_ID[19]}},joffset_ID,{12{1'b0}}}) : {{52{immed_ID[11]}}, immed_ID};

   assign reg_wraddr = ctrl_WB[0] ? raddr_WB : rs1_ID;
   
   reg_file inst_reg_file (
        .addra(reg_wraddr), 
        .addrb(rs2_ID), 
        .clka(clk), 
        .clkb(clk), 
        .dina(data_WB), 
        .dinb(), 
        .wea(ctrl_WB[0]), 
        .web(1'b0), 
        .douta(reg1data), 
        .doutb(reg2data)
	);
	
	// ---- PIPE LINE Register ----
		
    pipelinereg # (
       .DWIDTH (10+7+D_WIDTH+PC_WIDTH+5+20)
	) inst_ID_EXE (
	    .clk    (clk),
	    .reset_n(reset_n),
	    .en     (pc_en),
	    .i_data ({joffset_ID, rd_ID, pc_ID, func_ID, sign_immed_ID, ctrl_ID}),
	    .o_data ({joffset_EX, rd_EX, pc_EX, func_EX, sign_immed_EX, ctrl_EX})
	);
	// ---- PIPE LINE Register ----
    // ----------------------------------------
	assign alu_op1 = (ctrl_EX[3] & !ctrl_EX[5]) ? sign_immed_EX : reg2data;
	assign alu_op0 = ctrl_EX[6] ? {{32{1'b0}},pc_EX} : reg1data;
	assign branch_taken_EX = ctrl_EX[5] & (((func_EX[2:0] == 3'b000) & equal) |
                                           ((func_EX[2:0] == 3'b001) & !equal) |	
	                                ((func_EX[2:0] == 3'b100) & lessthan) |
									((func_EX[2:0] == 3'b101) & (greaterthan | equal)));
    
    assign branch_addr = (pc_EX) + {sign_immed_EX[30:0], 1'b0};
	// --- ALU ---
	ALU inst_ALU (
      .op0   (alu_op0),
      .op1   (alu_op1),
      .func3 (func_EX[2:0]),
      .func7 (func_EX[9:3]),
	  .ctrl  (ctrl_EX),
  
      .ALU_result(ALU_out),
	  .overflow  ( ),
      .eq        (equal),
      .lt        (lessthan),
      .gt        (greaterthan),
      .byte_op   (byte_op)
	);

	assign jump_addr = {{12{joffset_EX[19]}}, joffset_EX[18:0], 1'b0} + (pc_EX);
	
	// ---- PIPE LINE Register ----
		
    pipelinereg # (
       .DWIDTH (7+D_WIDTH*2+1+5+PC_WIDTH*2+1)
	)  inst_EXE_MEM(
	    .clk    (clk),
	    .reset_n(reset_n),
	    .en     (1'b1),
	    .i_data ({jump_addr, rd_EX, branch_taken_EX, branch_addr, ctrl_EX, reg2data, ALU_out,byte_op}),
	    .o_data ({jump_addr_MEM, rd_MEM, branch_taken_MEM, branch_addr_MEM, ctrl_MEM, reg2data_MEM, ALU_out_MEM,byte_op_MEM})
	);
	// ---- PIPE LINE Register ----
    // ----------------------------------------
   
   assign jump_pc = ctrl_MEM[4] ? jump_addr_MEM : branch_addr_MEM;
   assign branch_taken = (ctrl_MEM[5] & branch_taken_MEM) | ctrl_MEM[4];
   
   // Signals to memory outside our datapath.
   assign mem_we = ctrl_MEM[1];
   assign mem_addr_out = ALU_out_MEM;
   assign mem_data_out = reg2data_MEM;
   assign mem_write_data = byte_op_MEM ? {{56{reg2data_MEM[7]}},reg2data_MEM[7:0]} : reg2data_MEM;
   reg [PC_WIDTH-1:0] addr_r;
   always @(posedge clk) 
       addr_r <= ALU_out_MEM;
   
   
   d_mem inst_dmem (
                  .addra(ALU_out_MEM[9:2]), 
                  .addrb(d_mem_addra[7:0]), 
                  .clka(clk), 
                  .clkb(clk), 
                  .dina(mem_write_data), 
                  .dinb(d_mem_din[63:0]), 
                  .wea(ctrl_MEM[1]& !ALU_out_MEM[9:8]), 
                  .web(d_mem_we),     // user interface with port B of memory.
                  .douta(data_MEM[63:0]), 
                  .doutb(d_mem_out[63:0]));
				  
	// ---- PIPE LINE Register ----
		
    pipelinereg # (
       .DWIDTH (5+7+D_WIDTH+1)
	)inst_MEM_WB (
	    .clk    (clk),
	    .reset_n(reset_n),
	    .en     (1'b1),
	    .i_data ({rd_MEM, ctrl_MEM, ALU_out_MEM, byte_op_MEM}),
	    .o_data ({raddr_WB, ctrl_WB, ALU_out_WB, byte_op_WB})
	);
	wire [D_WIDTH-1:0] data_MEM_MUX;
    wire [D_WIDTH-1:0] data_MEM_final;
    assign data_MEM_final      = (byte_op_WB) ? {{56{data_MEM[7]}},data_MEM[7:0]} : data_MEM;
	assign data_MEM_MUX  = |addr_r[9:8] ? mem_datat_in : data_MEM_final;
	assign data_WB       = ctrl_WB[2] ? data_MEM_MUX : ALU_out_WB;
	// ---- PIPE LINE Register ----
    // ----------------------------------------

endmodule
