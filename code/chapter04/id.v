// Module:  id
// File:    id.v
// Author:  Lei Silei
// E-mail:  leishangwen@163.com
// Description: 译码阶段
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

//

`include "defines.v"

module id(

	input wire                      rst,
	input wire[`InstAddrBus]        pc_i, // 译码阶段指令的地址
	input wire[`InstBus]            inst_i, // 译码阶段指令的内容

    // 读取的regfile的值
	input wire[`RegBus]           reg1_data_i,
	input wire[`RegBus]           reg2_data_i,

	//输出到regfile的信息
	output reg                    reg1_read_o, // 使能信号
	output reg                    reg2_read_o,     
	output reg[`RegAddrBus]       reg1_addr_o, // 读信号
	output reg[`RegAddrBus]       reg2_addr_o, 	      
	
	//送到执行阶段的信息
	output reg[`AluOpBus]         aluop_o, // 运算的子类型
	output reg[`AluSelBus]        alusel_o, // 运算的类型
	output reg[`RegBus]           reg1_o, // 源操作数1
	output reg[`RegBus]           reg2_o, // 源操作数2
	output reg[`RegAddrBus]       wd_o, // 要写入的目的寄存器
	output reg                    wreg_o // 是否要写入寄存器
);

    // 取指令码和功能码
    wire[5:0] op = inst_i[31:26];
    wire[4:0] op2 = inst_i[10:6];
    wire[5:0] op3 = inst_i[5:0];
    wire[4:0] op4 = inst_i[20:16];
    reg[`RegBus]	imm; // 保存立即数
    reg instvalid; // 指令是否有效
  
    // 指令译码
	always @ (*) begin	
		if (rst == `RstEnable) begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			wd_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
			instvalid <= `InstValid;
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= `NOPRegAddr;
			reg2_addr_o <= `NOPRegAddr;
			imm <= 32'h0;			
	    end else begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			wd_o <= inst_i[15:11];
			wreg_o <= `WriteDisable;
			instvalid <= `InstInvalid;	   
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= inst_i[25:21];
			reg2_addr_o <= inst_i[20:16];		
			imm <= `ZeroWord;			
		    case (op)
		  	    `EXE_ORI:			
                begin                        //ORI指令
		  		    wreg_o <= `WriteEnable;		aluop_o <= `EXE_OR_OP;
		  		    alusel_o <= `EXE_RES_LOGIC; reg1_read_o <= 1'b1;	reg2_read_o <= 1'b0;	  	
					imm <= {16'h0, inst_i[15:0]};		wd_o <= inst_i[20:16];
					instvalid <= `InstValid;	
		  	    end 							 
		        default:			
                begin
		        end
		    endcase		  //case op			
		end       //if
	end     //always
	

	always @ (*) begin
		if(rst == `RstEnable) begin
			reg1_o <= `ZeroWord;
	  end else if(reg1_read_o == 1'b1) begin
	  	reg1_o <= reg1_data_i;
	  end else if(reg1_read_o == 1'b0) begin
	  	reg1_o <= imm;
	  end else begin
	    reg1_o <= `ZeroWord;
	  end
	end
	
	always @ (*) begin
		if(rst == `RstEnable) begin
			reg2_o <= `ZeroWord;
	  end else if(reg2_read_o == 1'b1) begin
	  	reg2_o <= reg2_data_i;
	  end else if(reg2_read_o == 1'b0) begin
	  	reg2_o <= imm;
	  end else begin
	    reg2_o <= `ZeroWord;
	  end
	end

endmodule