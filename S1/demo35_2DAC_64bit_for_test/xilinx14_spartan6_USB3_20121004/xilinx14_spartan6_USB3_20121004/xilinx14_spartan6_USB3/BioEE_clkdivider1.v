`timescale 1ns / 1ps
`default_nettype none

module BioEE_clkdivider(

	input wire clkin,
	input wire [15:0] integerdivider,  //even numbers only
	
	input wire enable,
	output reg clkout
	
   );


reg [14:0] clk_counter;

initial begin
	clk_counter <= 15'd00;
end

always @(posedge clkin) begin
	if ( (enable==1'b1) && (clk_counter == integerdivider[15:1]) ) begin
		clk_counter <= 15'd01;
		clkout <= ~clkout;
	end else begin
		clk_counter <= clk_counter + 1;
	end
end




endmodule

