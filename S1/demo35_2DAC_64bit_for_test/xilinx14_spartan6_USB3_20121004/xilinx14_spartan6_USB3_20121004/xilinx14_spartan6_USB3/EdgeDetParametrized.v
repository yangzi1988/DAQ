`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Brown University
// Engineer: Cynthia Barajas and Dr. Jacob Rosenstein
// 
// Create Date:    14:43:27 06/24/2013 
// Design Name: 
// Module Name:    EdgeDetParameterized 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Parameterized edge detector - the width of the filter (n) can be changed
//						without the need to adjust the rest of the code. 
//						It will output a single pulse for each rising and falling edge detection.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module EdgeDetParametrized(
		input wire clk,
		input wire [13:0] signal,
		output reg edgerise, 
	  // output reg edgerise_to_FSM,
		output reg edgefall,
   	//output reg edgefall_to_FSM,
		input wire [15:0] thresholdoffset,
		output reg [31:0] convsum	//For debug
    ); 

reg [4:0] risedelay;



	parameter risecome = 2'b00;
   parameter risemaintain = 2'b01;

 reg [1:0] nextstaterise;
 reg [1:0] staterise;
 reg edgerisemaintain;



reg [4:0] falldelay;

	parameter fallcome = 2'b00;
   parameter fallmaintain = 2'b01;

 reg [1:0] nextstatefall;
 reg [1:0] statefall;
 reg edgefallmaintain;


// =======================================================================================
//FSM states
parameter hold = 3'b000,low = 3'b001,high = 3'b010,low_fall = 3'b011, high_fall = 3'b100, hold_fall = 3'b101;
reg [2:0]	state,st;
reg [2:0]	next_state,nst;
// =======================================================================================

// =======================================================================================
//Parameters for the edge detector
parameter n = 128; //width of filter (even value)
parameter offset = 32'd2**24; //Offset for the output signal so the signal does not go below zero 

reg [31:0] shiftreg [n:1];	// nx32 bit shift register 
integer y;	//Variable used to save the delayed signals in specific registers
// =======================================================================================

// =======================================================================================
// Initializing the convsum and shift registers
initial begin
	convsum = offset;	//initialize convsum with the offset
	
	//for loop to initialize all shift registers to zero
	for (y = n; y >= 1; y = y - 1) begin
		shiftreg[y] = 0;
	end
end

// =======================================================================================


wire [31:0] signal32 = {18'b0,signal};	//Incoming signal


// =======================================================================================
/*
The code here was:


wire [31:0] posthreshold = offset + (100*n);	    //100*n to detect a 100mV step
wire [31:0] negthreshold = offset - (100*n); 
*/
wire [31:0] posthreshold = offset + thresholdoffset;	    //100*n to detect a 100mV step
wire [31:0] negthreshold = offset - thresholdoffset; 
// =======================================================================================

always @ (posedge clk) begin

	shiftreg [n] <= signal32;	//Shift in the incoming signal
		
	//For loop to 'delay signal' by saving it in different registers		
	//For loop in Verilog HDL does a combinatorial process (in one clock cycle)
	for (y = (n-1); y >= 1; y = y - 1) begin
		shiftreg[y] <= shiftreg[y+1];
	end

	//Iterative function to add/subtract the delayed signals
	convsum <= convsum + signal32 - (2 * shiftreg[(n/2)+1]) + shiftreg[1];
	
end


// Rising Edge Detector
always @ (posedge clk) 
begin
	state <= next_state;
end
	always @ (state) begin

		case(state)
			//Constantly checks to see if the convsum output is above the posthreshold
			//if it is not, it will hold the output signal at low
			hold:		if (convsum > posthreshold) begin	
							next_state <= high;																		 
						end else begin
							edgerise <= edgerise;
							next_state <= hold;
						end
						
			//Output signal stays low as long as the convsum output is around the offset			
			 low: 	if (convsum > offset) begin 
							edgerise <= 1'b0;
							next_state <= low;
						end else if (convsum < offset) begin
							edgerise <= 1'b0;
							next_state <= hold;
						end	
							
				//Output signal goes high when edge is detected			
				high: 	begin
							edgerise <= 1'b1;
							next_state <= low;
							end 

			default: next_state <= low;
		endcase
end

//Falling Edge Detector





always @ (posedge clk) 
	st <= nst;
	
	always @ (st) begin

		case(st)
	//Constantly checks to see if the convsum output is below the negthreshold
	//if it is not, it will hold the output signal at low	
	hold_fall:		if (convsum < negthreshold) begin	
							nst <= high_fall;
						end else begin
							edgefall <= edgefall;
							nst <= hold_fall;
						end
						
	//Output signal stays low as long as the convsum output is around the offset									
	low_fall:		if (convsum < offset) begin  
							edgefall <= 1'b0;
							nst <= low_fall;
						end else if (convsum > offset) begin  
							edgefall <= 1'b0;
							nst <= hold;
						end		

	//Output signal goes high when edge is detected	
	high_fall:		begin
							edgefall <= 1'b1;
							nst <= low_fall;
						end
			default: nst <= hold_fall;
		endcase
end

//----------------------------------------------------------------------------------------------------------------------------------------------------
/*

initial begin
edgerise_to_FSM<=1'b0;
edgefall_to_FSM<=1'b0;
end
 
		always @ (posedge clk) begin
         staterise <= nextstaterise;
			if (edgerise == 1'b1) begin
			edgerisemaintain <= 1'b1;
			end
		


	case (staterise)
       risecome : 
				begin
               if (edgerisemaintain == 1'b0) begin
                  nextstaterise <= risecome;
               end else begin 
						nextstaterise <= risemaintain;
						risedelay <= 5'd1;
						edgerise_to_FSM<= 1'b1;
					end
            end
				
       risemaintain : 
				begin
						risedelay <= risedelay - 1;
               if (risedelay != 5'b00000) begin
                  nextstaterise <= risemaintain;
               end else begin
                  nextstaterise <= risecome;
						edgerise_to_FSM<= 1'b0;
						risedelay <= 5'b00000;
						edgerisemaintain <= 1'b0;
					end
				end
	endcase
end


//------------------------------------------------------------------------------------------------------------------
		always @ (posedge clk) begin
         statefall <= nextstatefall;
			if (edgefall == 1'b1) begin
			edgefallmaintain <= 1'b1;
			end
		


	case (statefall)
       fallcome : 
				begin
               if (edgefallmaintain == 1'b0) begin
                  nextstatefall <= fallcome;
               end else begin 
						nextstatefall <= fallmaintain;
						falldelay <= 5'd1;
						edgefall_to_FSM<= 1'b1;
					end
            end
				
       fallmaintain : 
				begin
						falldelay <= falldelay - 1;
               if (falldelay != 5'b00000) begin
                  nextstatefall <= fallmaintain;
               end else begin
                  nextstatefall <= fallcome;
						edgefall_to_FSM<= 1'b0;
						falldelay <= 5'b00000;
						edgefallmaintain <= 1'b0;
					end
				end
	endcase
end
*/


endmodule