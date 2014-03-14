`timescale 1ns / 1ps
`default_nettype none

module BioEE_vector1_32in_32out(

	input wire vectorreset,
	input wire vectorclk,

	//data port to RAM
	input wire okClk,
	input wire pipeI_vector_write,
	//input wire pipeI_vector_block,
	input wire [31:0] pipeI_vector_data,
	//output wire pipeI_vector_ready,
	
	//vector outputs
	output wire [31:0] vectoroutput
	
   );


//------------------------------------------------------------------------
// data from pc -> vector
//------------------------------------------------------------------------

wire vectorfifo_full, vectorfifo_empty;

//assign pipeI_vector_ready = ~vectorfifo_full;

wire vectorfifo_prog_full;

wire vectorfifo_overflow;
wire vectorfifo_underflow;

fifo_w32_1024_r32_1024 vectorfifo (
	.rst(vectorreset),
	.wr_clk(okClk),
	.rd_clk(vectorclk),
	.din(pipeI_vector_data), // Bus [31 : 0] 
	.wr_en(pipeI_vector_write),
	.rd_en(1'b1),
	.dout(vectoroutput[31:0]), // Bus [31 : 0] 
	.full(vectorfifo_full),
	.empty(vectorfifo_empty),
	.valid(),
	.rd_data_count(), // Bus [9 : 0] 
	.wr_data_count()); // Bus [9 : 0] 
	
	
//------------------------------------------------------------------------
//------------------------------------------------------------------------

endmodule

