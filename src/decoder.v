module decoder (
    input clk,
    input reset_n,
    input [31:0] instr,
    input [31:0] pc,
    
    output reg [4:0] rd,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [11:0] immed,
    output reg [9:0] func,
    output reg [19:0] joffset,
    output reg [6:0] ctrl
    //ctrl[6] = auipc
    //ctrl[5] = branch
    //ctrl[4] = jump
    //ctrl[3] = immediate
    //ctrl[2] = memRead
    //ctrl[1] = memWrite
    //ctrl[0] = regWrite
);

localparam OP_R = 7'b0110011;
localparam OP_I = 7'b0010011;
localparam OP_S = 7'b0100011;
localparam OP_B = 7'b1100011;
localparam OP_J = 7'b1101111;
localparam OP_L = 7'b0000011;
localparam OP_AUIPC = 7'b0010111;

always @ (*) 
begin
    rd      = instr[11:7];
    rs1     = instr[19:15];
    rs2     = instr[24:20];
    func    = {instr[31:25], instr[14:12]};
    joffset = {instr[31], instr[19:12], instr[20], instr[30:21]};
	immed   = 'h0;
    case(instr[6:0])
        OP_R: begin
            ctrl = 7'b0000001; //regWrite
        end
        OP_I: begin
            immed = instr[31:20];
            ctrl = 7'b0001001; //immediate, regWrite
        end
        OP_AUIPC: begin
            joffset = instr[31:12];
            ctrl = 7'b1001001; //auipc, immediate, regWrite
        end
        OP_S: begin
            immed = {instr[31:25], instr[11:7]};
            ctrl = 7'b0001010; //immediate, memWrite
        end
        OP_B: begin
            immed = {instr[31], instr[7], instr[30:25], instr[11:8]};
            ctrl = 7'b0101000; //branch, immediate
        end
        OP_J: begin
            ctrl = 7'b0010000; //jump
        end
		OP_L: begin
		    immed = instr[31:20];
		    ctrl = 7'b0001101; //immediate, memRead, regWrite
		end
		default: begin
            ctrl  = 'h0;
		end
    endcase
end

endmodule
