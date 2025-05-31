// Module:  regfile
// File:    regfile.v
// Author:  Lei Silei
// E-mail:  leishangwen@163.com
// Description: 通用寄存器，共32个
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

`include "defines.v"

// 可以同时进行两个寄存器的读和一个寄存器的写

module regfile(

	input wire clk,
	input wire rst,
	
	//写端口
	input wire we,
	input wire[`RegAddrBus] waddr,
	input wire[`RegBus] wdata,
	
	//读端口1
	input wire re1,
	input wire[`RegAddrBus] raddr1,
	output reg[`RegBus] rdata1,
	
	//读端口2
	input wire re2,
	input wire[`RegAddrBus] raddr2,
	output reg[`RegBus] rdata2
	
);

	reg[`RegBus]  regs[0:`RegNum-1]; //32个32位通用寄存器

    // 写操作
	always @ (posedge clk) begin
		if (rst == `RstDisable) begin
			if((we == `WriteEnable) && (waddr != `RegNumLog2'h0)) // MIPS32架构要求$0只能为0
            begin
				regs[waddr] <= wdata;
			end
		end
	end

    // 第一个读寄存器端口
	always @ (*) begin
	    if(rst == `RstEnable) begin
			  rdata1 <= `ZeroWord;  // 复位信号有效，此时读出0
	    end else if(raddr1 == `RegNumLog2'h0) begin
	  		rdata1 <= `ZeroWord;    // 0号寄存器读出0
	    end else if((raddr1 == waddr) && (we == `WriteEnable) // 同时读写，直接把要写的元素读出
	  	            && (re1 == `ReadEnable)) begin
	  	    rdata1 <= wdata;
	    end else if(re1 == `ReadEnable) begin
	        rdata1 <= regs[raddr1];
	    end else begin // 其他情况，读出0
	        rdata1 <= `ZeroWord;
	    end
	end

    // 第二个读寄存器端口
	always @ (*) begin
		if(rst == `RstEnable) begin
			  rdata2 <= `ZeroWord;
	  end else if(raddr2 == `RegNumLog2'h0) begin
	  		rdata2 <= `ZeroWord;
	  end else if((raddr2 == waddr) && (we == `WriteEnable) 
	  	            && (re2 == `ReadEnable)) begin
	  	  rdata2 <= wdata;
	  end else if(re2 == `ReadEnable) begin
	      rdata2 <= regs[raddr2];
	  end else begin
	      rdata2 <= `ZeroWord;
	  end
	end

endmodule