`timescale 1ns / 1ps
`default_nettype none

module BioEE_vector(

	input wire vectorreset,
	input wire vectorclk,

	//data port to RAM
	input wire ti_clk,
	input wire pipeI_vector_write,
	//input wire pipeI_vector_block,
	input wire [15:0] pipeI_vector_data,
	//output wire pipeI_vector_ready,
	
	//vector outputs
	output wire [15:0] vectoroutput
	
   );


//------------------------------------------------------------------------
// data from pc -> vector
//------------------------------------------------------------------------

wire vectorfifo_full, vectorfifo_empty;

//assign pipeI_vector_ready = ~vectorfifo_full;

wire vectorfifo_prog_full;

wire vectorfifo_overflow;
wire vectorfifo_underflow;


fifo_16bit_16k vectorfifo(
	.din(pipeI_vector_data[15:0]), 
	.wr_clk(ti_clk), 
	.wr_en(pipeI_vector_write), 
	.rd_en(1'b1), 
	.rst(vectorreset),
	.rd_clk(vectorclk), 
	.dout(vectoroutput[15:0]),
	.empty(vectorfifo_empty),
	.full(vectorfifo_full),
	.prog_full_thresh(9'b100000000),
	.prog_full(vectorfifo_prog_full)
	);
	
//------------------------------------------------------------------------
//------------------------------------------------------------------------

endmodule

