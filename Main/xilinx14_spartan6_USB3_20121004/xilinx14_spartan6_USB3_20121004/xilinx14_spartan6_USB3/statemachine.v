`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:20:26 08/12/2013 
// Design Name: 
// Module Name:    statemachine 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module statemachine(
    input  wire reset,
	 input wire trigger,
    input  wire okClk,
	 input 		[31:0]pi0_ep_fifo_input,    // 32-bit input to FIFO
    input 		pi0_ep_write, 
	 output reg din_DAC,                 //data to the DAC
	 output reg cs_DAC,          //data to the DAC
	 output reg clk_DAC,         //data to the DAC
    output reg ldac_DAC,        //data to the DAC
	 output reg clk_FSM,       //removed
	 output reg din_DAC_compensation,
	 
	 input wire triggerdetector,   //removed
	 input wire edgerise_logical, //no connection
    input wire edgefall_logical, //no connection
	 output reg [15:0]thresholdoutput, // to edge detactor
	 output wire [31:0] PIPEOUT_CURRENT_STATE,//FIFO remaining data display
	 output wire [15:0] DAC_VALUES,
	 input wire adc_clk,     //input adc_clk
	 output reg clk_2_DAC,    //clock signal output to the DAC
	 input wire trigger_test //reserve for testing

	 );


assign PIPEOUT_CURRENT_STATE = {21'd0,FIFO_data_remain};//FIFO remaining data display (low 11 bits)
assign DAC_VALUES = myData_out_from_FIFO[31:16];

wire full;
wire empty;


reg [3:0]currentstate;

reg [4:0]p_2_s_counter; //parallel to serial transformation counter
reg [23:0]delay_counter; //time delay counter
reg [15:0]bias; //bias value   
reg [15:0]bias_compensation;                               
reg rd_in; //FIFO output control                                        
reg wr_en;    //FIFO input control                                                                                      
reg  [7:0]OUTDAC_delay; //delay the OUTDAC stage
reg [7:0]ldac_counter; // make sure the ldac signal goes low for one clock (same clock as clk_2_DAC)
reg [1:0]trigger_type;

///////////////////////////////////////////////////////////////////////////////////////

localparam
IDLE   =      4'b0000,//0
WAITING=      4'b0001,//1
COUNT  =      4'b0010,//2
OUTDAC =      4'b0011,//3
INITIAL=		  4'b0100,//4
COUNTER=      4'b0101,//5
TRIANGLE_WAVE=4'b0110,//6
FIFO_UPDATE = 4'b0111,//7
OUTDAC_DELAY =4'b1000,//8
TRIGGER =      4'b1001,//9
STATE6 =      4'b1010,//10

triangle_counter = 8'b01100100,//(to set the triangle_counter, follow: triangle_counter=(1/freauency)*5000
OUTDAC_DELAY_CONTROL = 8'd8;


initial
currentstate<=IDLE;
always @ ( negedge adc_clk ) begin

if (reset==1'b1) begin
currentstate <= INITIAL;
end

case (currentstate)
	
	INITIAL: //100
				begin
					din_DAC<=1'b0;
					din_DAC_compensation<=1'b0;
					bias<=16'b0000000000000000;
					bias_compensation<=16'b0000000000000000;
					
					delay_counter<=24'b000000000000000000000000;
					ldac_DAC<=1'b1;
					thresholdoutput <= 16'b1000000000000000;					
					if (reset==1'b0) begin
					currentstate<=IDLE;
					end else begin
					currentstate<=INITIAL;
					end
				end

		IDLE:	//000
			begin
				if (reset==1'b1) begin//reset
					currentstate <= INITIAL;
				end else if (myData_out_from_FIFO[7:0]==8'd3 && empty == 1'b0)begin//command==8'd3, bias output
					currentstate <= OUTDAC;
					p_2_s_counter<=5'b10001;
					ldac_counter <= 8'd17;
					bias <= myData_out_from_FIFO[23:8];
					bias_compensation <= myData_out_from_FIFO[47:32];
			//		bias <= 16'b1010101010010101;
				end else if (myData_out_from_FIFO[7:0]==8'd1 && empty == 1'b0) begin//command==8'd1, delay counter
					currentstate <= COUNT;
					delay_counter <= myData_out_from_FIFO[31:8];
				end else if (myData_out_from_FIFO[7:0]==8'd2 && empty == 1'b0) begin//command==8'd2, trigger logic
					currentstate <= TRIGGER;	
					thresholdoutput <= myData_out_from_FIFO[23:8];
					trigger_type <= myData_out_from_FIFO[31:24];		
				end else begin
					currentstate <= IDLE;
				end
			end

	TRIGGER:
			begin
				if (reset==1'b1) begin
					currentstate <= INITIAL;
				end else if (trigger_type==2'd1 && edgerise_logical == 1'b1) begin
					currentstate<=FIFO_UPDATE;
				end else if (trigger_type==2'd2 && edgefall_logical == 1'b1) begin
					currentstate<=FIFO_UPDATE;
				end else begin
					currentstate<=TRIGGER;
				end
		  	end
	
	COUNT: //0010
			begin 
				if (delay_counter != 24'd0)begin
					currentstate<=COUNT;
					delay_counter <= delay_counter - 1'b1;
				end else begin
					currentstate<=FIFO_UPDATE;
				end
			end
				
	OUTDAC: //0011     
			begin
				if ((p_2_s_counter != 5'b00001) && (p_2_s_counter != 5'b00000 )) begin
					bias<={bias[14:0], 1'b0};
					bias_compensation<={bias_compensation[14:0], 1'b0};
					din_DAC_compensation<=bias_compensation[15];
					
					din_DAC<=bias[15];
					OUTDAC_delay <= OUTDAC_DELAY_CONTROL*2;  
					clk_2_DAC <= 1'b0;
					ldac_counter <= ldac_counter-1'b1;
					currentstate <= OUTDAC_DELAY;
				end else if (p_2_s_counter!=5'b00000) begin
					currentstate <= OUTDAC_DELAY;
					OUTDAC_delay <= OUTDAC_DELAY_CONTROL;    
					ldac_counter <= ldac_counter-1'b1;
					din_DAC<=0;
					din_DAC_compensation<=0;
					ldac_DAC <= 1'b0;
				end else  begin	
					currentstate <= FIFO_UPDATE;
					din_DAC<=0;
					din_DAC_compensation<=0;
					ldac_DAC <= 1'b1;
				end
			end
			
	OUTDAC_DELAY: //4'b1000
			begin 
				if (OUTDAC_delay !=8'd0) begin
					currentstate <= OUTDAC_DELAY;
					OUTDAC_delay <= OUTDAC_delay - 1'b1;
				end else begin
					p_2_s_counter <= p_2_s_counter-1;
					currentstate <= OUTDAC;
				end	
				if (OUTDAC_delay == OUTDAC_DELAY_CONTROL) begin
					clk_2_DAC <= ~clk_2_DAC;
				end
			end
			
	FIFO_UPDATE:	//0111
			begin
			currentstate <= IDLE;
			end
			/*
			begin
			if (myData_out_from_FIFO[31:17] == 16'b0000000000000000)begin
					thresholdoutput <= 16'b0000110010000000;
					currentstate <= IDLE;
				end else begin 
					thresholdoutput <= myData_out_from_FIFO[15:0];
					currentstate <= IDLE;
				end			
			end		
			*/
endcase


//cs_DAC keeps low when output the serial bias data
	if (p_2_s_counter == 5'b10001)begin
		cs_DAC<=1'b0;
	end
	if (p_2_s_counter ==5'b00001) begin
		cs_DAC<=1'b1;
	end

// rd_in is the control bit of the FIFO output, the FIFO output updata every time when it goes high
	if (currentstate == FIFO_UPDATE) begin
		rd_in<=1'b1;
	end else begin
		rd_in<=1'b0;
	end
end


wire [63:0]myData_out_from_FIFO; //FIFO output
wire [10:0]FIFO_data_remain;//to show how many data in FIFO
fifo64 fifo (
  .rst(reset), // input rst
  .wr_clk(okClk), // input wr_clk controls the FIFO's input, has to be okClk       
  .rd_clk(adc_clk), // input rd_clk controls the FIFO's output, use adc_clk
  .din(pi0_ep_fifo_input), // input [31 : 0]  FIFO input
  .wr_en(pi0_ep_write), // input wr_en FIFO input control
  .rd_en(rd_in), // input rd_en FIFO output control
  .dout(myData_out_from_FIFO), // output [31 : 0] FIFO output
  .full(full), // output full
  .empty(empty), // output empty
  .rd_data_count(FIFO_data_remain) //to show how many data in FIFO  F 
  );

endmodule
