//------------------------------------------------------------------------
// ramtest.v
//
// This sample uses the Xilinx MIG DDR2 controller and HDL to move data
// from the PC to the DDR2 and vice-versa. Based on MIG generated example_top.v
//
// Host Interface registers:
// WireIn 0x00
//     0 - DDR2 read enable (0=disabled, 1=enabled)
//     1 - DDR2 write enable (0=disabled, 1=enabled)
//     2 - Reset
//
// PipeIn 0x80 - DDR2 write port (U11, DDR2)
// PipeOut 0xA0 - DDR2 read port (U11, DDR2)
//
// This sample is included for reference only.  No guarantees, either 
// expressed or implied, are to be drawn.
//------------------------------------------------------------------------
// tabstop 3
// Copyright (c) 2005-2009 Opal Kelly Incorporated
// $Rev: 303 $ $Date: 2007-05-16 19:13:24 -0700 (Wed, 16 May 2007) $
//------------------------------------------------------------------------
`timescale 1ns/1ps

module bitfile_fpga   #(
	parameter C3_P0_MASK_SIZE           = 4,
	parameter C3_P0_DATA_PORT_SIZE      = 32,
	parameter C3_P1_MASK_SIZE           = 4,
	parameter C3_P1_DATA_PORT_SIZE      = 32,
	parameter DEBUG_EN                  = 0,       
	parameter C3_MEMCLK_PERIOD          = 3200,       
	parameter C3_CALIB_SOFT_IP          = "TRUE",       
	parameter C3_SIMULATION             = "FALSE",       
	parameter C3_HW_TESTING             = "FALSE",       
	parameter C3_RST_ACT_LOW            = 0,       
	parameter C3_INPUT_CLK_TYPE         = "DIFFERENTIAL",       
	parameter C3_MEM_ADDR_ORDER         = "ROW_BANK_COLUMN",       
	parameter C3_NUM_DQ_PINS            = 16,       
	parameter C3_MEM_ADDR_WIDTH         = 13,       
	parameter C3_MEM_BANKADDR_WIDTH     = 3        
	)
	(

	input  wire [4:0]   okUH,
	output wire [2:0]   okHU,
	inout wire  [31:0]  okUHU,
	inout  wire         okAA,

	input  wire        sys_clkp,
	input  wire        sys_clkn,
	
	//output wire [7:0]  led,
	output wire   led,
	
	inout  wire [28:0] xbusp,
	inout  wire [28:0] xbusn,
	inout  wire [28:0] ybusp,
	inout  wire [28:0] ybusn,
	
	inout  wire 		 xclk1,
	inout  wire 		 xclk2,
	inout  wire 		 yclk1,
	inout  wire 		 yclk2,

	
	
	
	
	inout  wire [C3_NUM_DQ_PINS-1:0]         ddr2_dq,
	output wire [C3_MEM_ADDR_WIDTH-1:0]      ddr2_a,
	output wire [C3_MEM_BANKADDR_WIDTH-1:0]  ddr2_ba,
	output wire                              ddr2_ras_n,
	output wire                              ddr2_cas_n,
	output wire                              ddr2_we_n,
	output wire                              ddr2_odt,
	output wire                              ddr2_cke,
	output wire                              ddr2_dm,
	inout  wire                              ddr2_udqs,
	inout  wire                              ddr2_udqs_n,
	inout  wire                              ddr2_rzq,
	inout  wire                              ddr2_zio,
	output wire                              ddr2_udm,
	inout  wire                              ddr2_dqs,
	inout  wire                              ddr2_dqs_n,
	output wire                              ddr2_ck,
	output wire                              ddr2_ck_n,
	output wire                              ddr2_cs_n
	);

	localparam BLOCK_SIZE      = 128;   // 512 bytes / 4 byte per word;
	localparam FIFO_SIZE       = 1024;
	
	 localparam C3_INCLK_PERIOD         = 10000; // 10000ps -> 10ns -> 100Mhz
      localparam C3_CLKOUT0_DIVIDE       = 1;     // 625 MHz system clock      
   localparam C3_CLKOUT1_DIVIDE       = 1;     // 625 MHz system clock (180 deg)      
   localparam C3_CLKOUT2_DIVIDE       = 4;     // 156.256 MHz test bench clock      
   localparam C3_CLKOUT3_DIVIDE       = 8;     // 78.125 MHz calibration clock      
   localparam C3_CLKFBOUT_MULT        = 25;    // 25MHz x 25 = 625 MHz system clock       
   localparam C3_DIVCLK_DIVIDE        = 4;     // 100MHz/4 = 25 Mhz       
   localparam C3_ARB_NUM_TIME_SLOTS   = 12;       
   localparam C3_ARB_TIME_SLOT_0      = 3'o0;       
   localparam C3_ARB_TIME_SLOT_1      = 3'o0;       
   localparam C3_ARB_TIME_SLOT_2      = 3'o0;       
   localparam C3_ARB_TIME_SLOT_3      = 3'o0;       
   localparam C3_ARB_TIME_SLOT_4      = 3'o0;       
   localparam C3_ARB_TIME_SLOT_5      = 3'o0;       
   localparam C3_ARB_TIME_SLOT_6      = 3'o0;       
   localparam C3_ARB_TIME_SLOT_7      = 3'o0;       
   localparam C3_ARB_TIME_SLOT_8      = 3'o0;       
   localparam C3_ARB_TIME_SLOT_9      = 3'o0;       
   localparam C3_ARB_TIME_SLOT_10     = 3'o0;       
   localparam C3_ARB_TIME_SLOT_11     = 3'o0;       
   localparam C3_MEM_TRAS             = 40000;       
   localparam C3_MEM_TRCD             = 15000;       
   localparam C3_MEM_TREFI            = 7800000;       
   localparam C3_MEM_TRFC             = 127500;       
   localparam C3_MEM_TRP              = 15000;       
   localparam C3_MEM_TWR              = 15000;       
   localparam C3_MEM_TRTP             = 7500;       
   localparam C3_MEM_TWTR             = 7500;       
   localparam C3_MEM_TYPE             = "DDR2";       
   localparam C3_MEM_DENSITY          = "1Gb";       
   localparam C3_MEM_BURST_LEN        = 4;       
   localparam C3_MEM_CAS_LATENCY      = 5;       
   localparam C3_MEM_NUM_COL_BITS     = 10;       
   localparam C3_MEM_DDR1_2_ODS       = "FULL";       
   localparam C3_MEM_DDR2_RTT         = "50OHMS";       
   localparam C3_MEM_DDR2_DIFF_DQS_EN  = "YES";       
   localparam C3_MEM_DDR2_3_PA_SR     = "FULL";       
   localparam C3_MEM_DDR2_3_HIGH_TEMP_SR  = "NORMAL";       
   localparam C3_MEM_DDR3_CAS_LATENCY  = 6;       
   localparam C3_MEM_DDR3_ODS         = "DIV6";       
   localparam C3_MEM_DDR3_RTT         = "DIV2";       
   localparam C3_MEM_DDR3_CAS_WR_LATENCY  = 5;       
   localparam C3_MEM_DDR3_AUTO_SR     = "ENABLED";       
   localparam C3_MEM_DDR3_DYN_WRT_ODT  = "OFF";       
   localparam C3_MEM_MOBILE_PA_SR     = "FULL";       
   localparam C3_MEM_MDDR_ODS         = "FULL";       
   localparam C3_MC_CALIB_BYPASS      = "NO";       
   localparam C3_MC_CALIBRATION_MODE  = "CALIBRATION";       
   localparam C3_MC_CALIBRATION_DELAY  = "HALF";       
   localparam C3_SKIP_IN_TERM_CAL     = 0;       
   localparam C3_SKIP_DYNAMIC_CAL     = 0;       
   localparam C3_LDQSP_TAP_DELAY_VAL  = 0;       
   localparam C3_LDQSN_TAP_DELAY_VAL  = 0;       
   localparam C3_UDQSP_TAP_DELAY_VAL  = 0;       
   localparam C3_UDQSN_TAP_DELAY_VAL  = 0;       
   localparam C3_DQ0_TAP_DELAY_VAL    = 0;       
   localparam C3_DQ1_TAP_DELAY_VAL    = 0;       
   localparam C3_DQ2_TAP_DELAY_VAL    = 0;       
   localparam C3_DQ3_TAP_DELAY_VAL    = 0;       
   localparam C3_DQ4_TAP_DELAY_VAL    = 0;       
   localparam C3_DQ5_TAP_DELAY_VAL    = 0;       
   localparam C3_DQ6_TAP_DELAY_VAL    = 0;       
   localparam C3_DQ7_TAP_DELAY_VAL    = 0;       
   localparam C3_DQ8_TAP_DELAY_VAL    = 0;       
   localparam C3_DQ9_TAP_DELAY_VAL    = 0;       
   localparam C3_DQ10_TAP_DELAY_VAL   = 0;       
   localparam C3_DQ11_TAP_DELAY_VAL   = 0;       
   localparam C3_DQ12_TAP_DELAY_VAL   = 0;       
   localparam C3_DQ13_TAP_DELAY_VAL   = 0;       
   localparam C3_DQ14_TAP_DELAY_VAL   = 0;       
   localparam C3_DQ15_TAP_DELAY_VAL   = 0;       
   localparam C3_p0_BEGIN_ADDRESS                   = (C3_HW_TESTING == "TRUE") ? 32'h01000000:32'h00000100;
   localparam C3_p0_DATA_MODE                       = 4'b0010;
   localparam C3_p0_END_ADDRESS                     = (C3_HW_TESTING == "TRUE") ? 32'h02ffffff:32'h000002ff;
   localparam C3_p0_PRBS_EADDR_MASK_POS             = (C3_HW_TESTING == "TRUE") ? 32'hfc000000:32'hfffffc00;
   localparam C3_p0_PRBS_SADDR_MASK_POS             = (C3_HW_TESTING == "TRUE") ? 32'h01000000:32'h00000100;
  wire                              c3_sys_clk;
  wire                              c3_error;
  wire                              c3_calib_done;
  wire                              c3_clk0;
  reg                               c3_sys_rst_n;
  wire                              c3_rst0;
  wire                              c3_async_rst;
  wire                              c3_sysclk_2x;
  wire                              c3_sysclk_2x_180;
  wire                              c3_pll_ce_0;
  wire                              c3_pll_ce_90;
  wire                              c3_pll_lock;
  wire                              c3_mcb_drp_clk;
  wire                              c3_cmp_error;
  wire                              c3_cmp_data_valid;
  wire                              c3_vio_modify_enable;
  wire  [127:0]                     c3_error_status;
  wire  [2:0]                       c3_vio_data_mode_value;
  wire  [2:0]                       c3_vio_addr_mode_value;
  wire  [31:0]                      c3_cmp_data;
  wire                              c3_p0_cmd_en;
  wire [2:0]                        c3_p0_cmd_instr;
  wire [5:0]                        c3_p0_cmd_bl;
  wire [29:0]                       c3_p0_cmd_byte_addr;
  wire                              c3_p0_cmd_empty;
  wire                              c3_p0_cmd_full;
  wire                              c3_p0_wr_en;
  wire [C3_P0_MASK_SIZE - 1:0]      c3_p0_wr_mask;
  wire [C3_P0_DATA_PORT_SIZE - 1:0] c3_p0_wr_data;
  wire                              c3_p0_wr_full;
  wire                              c3_p0_wr_empty;
  wire [6:0]                        c3_p0_wr_count;
  wire                              c3_p0_wr_underrun;
  wire                              c3_p0_wr_error;
  wire                              c3_p0_rd_en;
  wire [C3_P0_DATA_PORT_SIZE - 1:0] c3_p0_rd_data;
  wire                              c3_p0_rd_full;
  wire                              c3_p0_rd_empty;
  wire [6:0]                        c3_p0_rd_count;
  wire                              c3_p0_rd_overflow;
  wire                              c3_p0_rd_error;
  wire                              selfrefresh_enter;          
  wire                              selfrefresh_mode; 


	
//========================================================================
// CLOCKS
//========================================================================

wire vector_clk;
wire adc_clk;


BioEE_clkdivider vectorclkdivider(
	.clkin(okClk),
	.integerdivider(16'd250),
	.enable(1'b1),
	.clkout(vector_clk)
	);

BioEE_clkdivider adcclkdivider(
	.clkin(okClk),
	.integerdivider(16'd24),
	.enable(1'b1),
	.clkout(adc_clk)
	);



//========================================================================
// I/O Mapping
//========================================================================

wire [14:1] adc1_data;
wire adc1_otr;

wire adc1_muxen = 1'b1;

wire [1:0] adc1_mux;
assign adc1_mux[1] = bioee_wirein_adcmux[1];
assign adc1_mux[0] = bioee_wirein_adcmux[0];

wire [15:0] extbusout;



wire clk;
wire DAC_SDIN_VCOUNTER;
wire DAC_NCS;
wire DAC_NLDAC;
wire DAC_SCLK;
wire DAC_SDIN_VCOMPENSATION;
/////////////////////////////////////////////////////////////////////////////////////////////////////////




assign extbusout[0] = DAC_SDIN_VCOUNTER; //xbusp[1]

assign extbusout[1] = DAC_SCLK;//xbusp[0]
assign extbusout[2] = DAC_NCS;//xbusn[1]
assign extbusout[10] = DAC_NLDAC;//xbusn[5]
//assign extbusout[10] = bioee_triggerin_test1[1];
assign extbusout[8] = DAC_SDIN_VCOMPENSATION; //xbusp[1]

//assign extbusout[1] = scanvector_output[1];


// temporarily removed
//assign extbusout[9:3] = scanvector_output[9:3];
assign extbusout[7:3] = scanvector_output[7:3];
assign extbusout[9] = scanvector_output[9];

assign extbusout[14:11] = scanvector_output[14:11];
// temporarily removed



//assign extbusout[15] = headstage_pwr_led;

// ====== previous assignments ==================
//assign extbusout[14:0] = scanvector_output[14:0];
//assign extbusout[15] = headstage_pwr_led;
// ==============================================


OBUF OBUF_adc1clk ( .I(adc_clk), .O(xbusn[13]) );

IBUF IBUF_adc1data[14:1] ( .I( {xbusp[15],xbusn[15],xbusp[17],xbusn[17],xbusp[19],xbusn[19],xbusp[21],xbusn[21],xbusp[23],xbusn[23],xbusp[25],xbusn[25],xbusp[27],xbusn[27]} ), .O(adc1_data[14:1]) );
IBUF IBUF_adc1otr ( .I(xbusn[28]), .O(adc1_otr) );

OBUF OBUF_adc1muxen ( .I(adc1_muxen), .O(xbusp[26]) );
//OBUF OBUF_adc2muxen ( .I(adc2_muxen), .O(ybusp[26]) );
OBUF OBUF_adc1mux[1:0] ( .I(adc1_mux[1:0]), .O( {xbusp[28],xbusn[26]} ) );
//OBUF OBUF_adc2mux[1:0] ( .I(adc2_mux[1:0]), .O( {ybusp[28],ybusn[26]} ) );

// full EXTBUS for 6010
OBUF OBUF_EXTBUSOUT[15:0] ( .I(extbusout[15:0]), .O( {xbusn[6],xbusn[7],xbusp[6],xbusp[7],xbusn[4],xbusn[5],xbusp[4],xbusp[5],xbusn[2],xbusn[3],xbusp[2],xbusp[3],xbusn[0],xbusn[1],xbusp[0],xbusp[1]} ) );


//========================================================================
// OPAL KELLY INTERFACE
//========================================================================

	// USB Host Interface
	wire         okClk;
	wire [112:0] okHE;
	wire [64:0]  okEH;
	
	wire [31:0]	bioee_triggerin_test1;
	wire [31:0]	bioee_triggerout_test1;
	wire [31:0] bioee_wirein_test1;
	wire [31:0] bioee_wirein_adcmux;
	wire [31:0] bioee_wireout_test1;
	
	
	
	wire [31:0] bioee_wirein_triangle_wave;
	
	
	
	wire [31:0] pipein_triggerthresholds;
	wire [31:0] pipein_holdseconds;
	wire [31:0] pipeout_FSM_current_state;
	
	

	wire [31:0] bioee_wireout_adcfifocount;

	//wire [15:0]  ep00wire;

	wire        pipe_in_start;
	wire        pipe_in_done;
	wire        pipe_in_read;
	wire [31:0] pipe_in_data;
	
	wire [9:0]  pipe_in_rd_count;      //original
	//wire [8:0]  pipe_in_rd_count;    //JKR mod
		
	wire [9:0]  pipe_in_wr_count;   //original
	//wire [10:0]  pipe_in_wr_count;   //JKR mod
	wire        pipe_in_valid;
	wire        pipe_in_full;
	wire        pipe_in_empty;
	reg         pipe_in_ready;
	
	wire        pipe_out_start;
	wire        pipe_out_done;
	wire        pipe_out_write;
	wire [31:0] pipe_out_data;
	wire [9:0]  pipe_out_rd_count;
	wire [9:0]  pipe_out_wr_count;
	wire        pipe_out_full;
	wire        pipe_out_empty;
	reg         pipe_out_ready;
	
	wire [31:0] pipein_vector_dataout;
	wire pipein_vector_write; 
	
	wire [31:0] pipein_dacfsm_dataout_to_fifo;
	wire pipein_dacfsm_write;
	
	wire [31:0] po0_ep_datain;
	wire po0_ep_read;
	
	wire trigger;
	wire reset;	

assign reset=bioee_triggerin_test1[0];
assign led=bioee_wirein_test1[0];


okHost okHI(
	.okUH(okUH),
	.okHU(okHU),
	.okUHU(okUHU),
	.okAA(okAA),
	.okClk(okClk),
	.okHE(okHE), 
	.okEH(okEH)
);
	


localparam OKwireORcount = 8;

wire [65*OKwireORcount-1:0]  okEHx;

okWireOR # (.N(OKwireORcount)) wireOR (okEH, okEHx);

okWireIn     wi00(.okHE(okHE),                           .ep_addr(8'h00), .ep_dataout(bioee_wirein_test1));
okWireIn		 wi01(.okHE(okHE),									 .ep_addr(8'h01), .ep_dataout(bioee_wirein_adcmux));

okWireIn		 wi02(.okHE(okHE),									 .ep_addr(8'h02), .ep_dataout(bioee_wirein_triangle_wave));

okWireOut    wo20(.okHE(okHE), .okEH(okEHx[ 0*65 +: 65 ]), .ep_addr(8'h20), .ep_datain(bioee_wireout_test1));
okWireOut    wo21(.okHE(okHE), .okEH(okEHx[ 1*65 +: 65 ]), .ep_addr(8'h21), .ep_datain(bioee_wireout_adcfifocount));
okTriggerIn  ti40(.okHE(okHE),                           .ep_addr(8'h40), .ep_clk(adc_clk), .ep_trigger(bioee_triggerin_test1));

okTriggerOut to60(.okHE(okHE), .okEH(okEHx[ 2*65 +: 65 ]), .ep_addr(8'h60), .ep_clk(adc_clk), .ep_trigger(bioee_triggerout_test1));
okBTPipeOut    po0  (.okHE(okHE), .okEH(okEHx[ 3*65 +: 65 ]), .ep_addr(8'ha0), .ep_read(po0_ep_read),   .ep_blockstrobe(), .ep_datain(po0_ep_datain), .ep_ready(pipe_out_ready));
okPipeOut    po1  (.okHE(okHE), .okEH(okEHx[ 4*65 +: 65 ]), .ep_addr(8'ha1), .ep_read(), .ep_datain(pipeout_FSM_current_state));
okPipeIn     pi0  (.okHE(okHE), .okEH(okEHx[ 5*65 +: 65 ]), .ep_addr(8'h80), .ep_write(pipein_vector_write), .ep_dataout(pipein_vector_dataout));
okPipeIn     pi1  (.okHE(okHE), .okEH(okEHx[ 6*65 +: 65 ]), .ep_addr(8'h81), .ep_write(pipein_dacfsm_write), .ep_dataout(pipein_dacfsm_dataout_to_fifo));
okPipeIn     pi2  (.okHE(okHE), .okEH(okEHx[ 7*65 +: 65 ]), .ep_addr(8'h82), .ep_write(), .ep_dataout(pipein_holdseconds));

//========================================================================
// MISC I/O
//========================================================================	

wire adc_fill_level_trigger;
assign bioee_triggerout_test1[0] = adc_fill_level_trigger;

wire globalreset = bioee_wirein_test1[15] | bioee_wirein_test1[2];

wire adc_write_en = bioee_wirein_test1[4];

wire headstage_pwr_en = bioee_wirein_test1[0];
//wire headstage_pwr_led = bioee_wirein_test1[1];
OBUF OBUF_headstage_pwr_en ( .I(headstage_pwr_en), .O(ybusp[0]) );
//OBUF OBUF_headstage_pwr_led ( .I(headstage_pwr_led), .O(xbusn[6]) );


//========================================================================
// CONTROL VECTORS
//========================================================================

wire [31:0] scanvector_output;

BioEE_vector1_32in_32out scanvector ( 	.vectorreset(1'b0), 
									.vectorclk(vector_clk), 
									.okClk(okClk), 
									.pipeI_vector_write(pipein_vector_write),
									.pipeI_vector_data(pipein_vector_dataout),
									.vectoroutput(scanvector_output[31:0]) );


wire [15:0] thresholdoutput;
wire [15:0] DAC_VALUES;



//========================================================================
// FSM
//========================================================================
statemachine statemachine (
    .reset(reset), 
    .trigger(trigger), //no connction
	 .okClk(okClk),   // FIFO input clock
	 .adc_clk(adc_clk), // FSM clock
    .pi0_ep_fifo_input(pipein_dacfsm_dataout_to_fifo),   //32-bit data input to FIFO
    .pi0_ep_write(pipein_dacfsm_write), //currently no connection
	 .din_DAC(DAC_SDIN_VCOUNTER), //serial signaly that sent to the DAC
	 .cs_DAC(DAC_NCS), //sent to the DAC
	 .ldac_DAC(DAC_NLDAC), //sent to the DAC
	 //.clk_DAC(DAC_SCLK),
	 .clk_2_DAC(DAC_SCLK),//clock that sent to the DAC
	 .edgerise_logical(edgerise_logical), //logic combination: send the trigger to FSM if (manually trigger or ("allow trigger" box checked & edgerise-bit high))
    .edgefall_logical(edgefall_logical), //logic combination: send the trigger to FSM if (manually trigger or ("allow trigger" box checked & edgefall-bit high))
	 .thresholdoutput(thresholdoutput), // out to edge detactor
	 .PIPEOUT_CURRENT_STATE(pipeout_FSM_current_state), //display the amount of remaining data in FIFO 
	 .DAC_VALUES(DAC_VALUES),
	 .trigger_test(bioee_triggerin_test1[1]),	 //reserve for trigger test
	 .din_DAC_compensation(DAC_SDIN_VCOMPENSATION)
    );


wire edgerise_logical;
wire edgefall_logical;

assign edgerise_logical = ((edgerise && bioee_wirein_test1[0]) || bioee_triggerin_test1[1]);//logic combination: send the trigger to FSM if (manually trigger or ("allow trigger" box checked & edgerise-bit high))
assign edgefall_logical = ((edgefall && bioee_wirein_test1[0]) || bioee_triggerin_test1[1]);//logic combination: send the trigger to FSM if (manually trigger or ("allow trigger" box checked & edgefall-bit high))

wire daqtrigger1 = edgerise_logical;
wire daqtrigger2 = edgefall_logical;

//========================================================================
// EDGE DETECTOR
//========================================================================

wire edgerise_to_FSM;
wire edgefall_to_FSM;
wire edgerise;
wire edgefall;
wire [13:0] adcsignal = {adc1_data[1],adc1_data[2],adc1_data[3],adc1_data[4],adc1_data[5],adc1_data[6],adc1_data[7],adc1_data[8],adc1_data[9],adc1_data[10],adc1_data[11],adc1_data[12],adc1_data[13],adc1_data[14]};

EdgeDetParametrized edgedetector1 (
    .clk(adc_clk), 
    .signal(adcsignal), 
    //.edgerise_to_FSM(edgerise_to_FSM), 
    //.edgefall_to_FSM(edgefall_to_FSM), 
	 .edgerise(edgerise),
	 .edgefall(edgefall),
	 .thresholdoffset(thresholdoutput),
    .convsum()
    );
	 


//========================================================================
// SDRAM FIFOS
//========================================================================

//fifo_w16_2048_r32_1024 ADCdata_fifo (
fifo_w32_1024_r32_1024 okPipeIn_fifo (
	.rst(globalreset),
	.rd_clk(c3_clk0),
	
	/*
	// ----- original -----
	.wr_clk(okClk),
	.din(pi0_ep_dataout), // Bus [31 : 0] 
	.wr_en(pi0_ep_write),
	// --------------------
	*/
	
	// ----- JKR -----
	.wr_clk(adc_clk),    // restored to non-inverted
//	.din( { 16'b0000000000000000, adc1_data[1], adc1_data[2], adc1_data[3], adc1_data[4], adc1_data[5], adc1_data[6], adc1_data[7], adc1_data[8], adc1_data[9], adc1_data[10], adc1_data[11], adc1_data[12], adc1_data[13], adc1_data[14], daqtrigger2, daqtrigger1  } ),
	.din( { DAC_VALUES, adc1_data[1], adc1_data[2], adc1_data[3], adc1_data[4], adc1_data[5], adc1_data[6], adc1_data[7], adc1_data[8], adc1_data[9], adc1_data[10], adc1_data[11], adc1_data[12], adc1_data[13], adc1_data[14], daqtrigger2, daqtrigger1  } ),
	//.din( { adc1_data[1], adc1_data[2], adc1_data[3], adc1_data[4], adc1_data[5], adc1_data[6], adc1_data[7], adc1_data[8], adc1_data[9], adc1_data[10], adc1_data[11], adc1_data[12], adc1_data[13], adc1_data[14], 1'b0, 1'b0  } ),
	.wr_en(1'b1),
	// --------------------
	
	.rd_en(pipe_in_read),
	.dout(pipe_in_data), // Bus [31 : 0] 
	.full(pipe_in_full),
	.empty(pipe_in_empty),
	.valid(pipe_in_valid),
	.rd_data_count(pipe_in_rd_count), // Bus [9 : 0]  
	.wr_data_count(pipe_in_wr_count)); // Bus [9 : 0]

fifo_w32_1024_r32_1024 okPipeOut_fifo (
	.rst(globalreset),
	.wr_clk(c3_clk0),
	.rd_clk(okClk),
	.din(pipe_out_data), // Bus [31 : 0] 
	.wr_en(pipe_out_write),
	.rd_en(po0_ep_read),
	.dout(po0_ep_datain), // Bus [31 : 0] 
	.full(pipe_out_full),
	.empty(pipe_out_empty),
	.valid(),
	.rd_data_count(pipe_out_rd_count), // Bus [9 : 0] 
	.wr_data_count(pipe_out_wr_count)); // Bus [9 : 0] 








//========================================================================
// LEDs
//========================================================================

//assign led = ~{chip_scan1clk,4'b0,globalreset,c3_calib_done,c3_pll_lock};
/*
assign led = ~{
					globalreset,
					c3_pll_lock,
					//adc1_mux[1],
					adc1_otr,
					1'b0,
					//headstage_pwr_en,
					headstage_pwr_led,
					pipe_in_wr_count[5]
					};

//assign led = ~scanvector_output[7:0];

*/

//========================================================================
// MEMORY INTERFACE
//========================================================================	
	
	assign c3_sys_clk     = 1'b0;
	assign ddr2_cs_n = 1'b0;
	
	wire			ddr_readenable = 1'b1;
	wire			ddr_writeenable = 1'b1;
	
	//MIG Infrastructure Reset
	reg [3:0] rst_cnt;
	initial rst_cnt = 4'b0;
	always @(posedge okClk) begin
		if(rst_cnt < 4'b1000) begin
		  rst_cnt <= rst_cnt + 1;
			c3_sys_rst_n <= 1'b1;
		end
		else begin
			c3_sys_rst_n <= 1'b0;
		end
	end

memc3_infrastructure #
	(
   .C_MEMCLK_PERIOD                  (C3_INCLK_PERIOD),  //MIG PLL Input
   .C_RST_ACT_LOW                    (C3_RST_ACT_LOW),
   .C_INPUT_CLK_TYPE                 (C3_INPUT_CLK_TYPE),
   .C_CLKOUT0_DIVIDE                 (C3_CLKOUT0_DIVIDE),
   .C_CLKOUT1_DIVIDE                 (C3_CLKOUT1_DIVIDE),
   .C_CLKOUT2_DIVIDE                 (C3_CLKOUT2_DIVIDE),
   .C_CLKOUT3_DIVIDE                 (C3_CLKOUT3_DIVIDE),
   .C_CLKFBOUT_MULT                  (C3_CLKFBOUT_MULT),
   .C_DIVCLK_DIVIDE                  (C3_DIVCLK_DIVIDE)
	)
memc3_infrastructure_inst
	(
   .sys_clk_p                      (sys_clkp),
   .sys_clk_n                      (sys_clkn),
   .sys_clk                        (c3_sys_clk),
   .sys_rst_n                      (c3_sys_rst_n),
   .clk0                           (c3_clk0),
   .rst0                           (c3_rst0),
   .async_rst                      (c3_async_rst),
   .sysclk_2x                      (c3_sysclk_2x),
   .sysclk_2x_180                  (c3_sysclk_2x_180),
   .pll_ce_0                       (c3_pll_ce_0),
   .pll_ce_90                      (c3_pll_ce_90),
   .pll_lock                       (c3_pll_lock),
   .mcb_drp_clk                    (c3_mcb_drp_clk)
	);

// wrapper instantiation
 memc3_wrapper #
	(
   .C_MEMCLK_PERIOD                  (C3_MEMCLK_PERIOD),
   .C_CALIB_SOFT_IP                  (C3_CALIB_SOFT_IP),
   .C_SIMULATION                     (C3_SIMULATION),
   .C_ARB_NUM_TIME_SLOTS             (C3_ARB_NUM_TIME_SLOTS),
   .C_ARB_TIME_SLOT_0                (C3_ARB_TIME_SLOT_0),
   .C_ARB_TIME_SLOT_1                (C3_ARB_TIME_SLOT_1),
   .C_ARB_TIME_SLOT_2                (C3_ARB_TIME_SLOT_2),
   .C_ARB_TIME_SLOT_3                (C3_ARB_TIME_SLOT_3),
   .C_ARB_TIME_SLOT_4                (C3_ARB_TIME_SLOT_4),
   .C_ARB_TIME_SLOT_5                (C3_ARB_TIME_SLOT_5),
   .C_ARB_TIME_SLOT_6                (C3_ARB_TIME_SLOT_6),
   .C_ARB_TIME_SLOT_7                (C3_ARB_TIME_SLOT_7),
   .C_ARB_TIME_SLOT_8                (C3_ARB_TIME_SLOT_8),
   .C_ARB_TIME_SLOT_9                (C3_ARB_TIME_SLOT_9),
   .C_ARB_TIME_SLOT_10               (C3_ARB_TIME_SLOT_10),
   .C_ARB_TIME_SLOT_11               (C3_ARB_TIME_SLOT_11),
   .C_MEM_TRAS                       (C3_MEM_TRAS),
   .C_MEM_TRCD                       (C3_MEM_TRCD),
   .C_MEM_TREFI                      (C3_MEM_TREFI),
   .C_MEM_TRFC                       (C3_MEM_TRFC),
   .C_MEM_TRP                        (C3_MEM_TRP),
   .C_MEM_TWR                        (C3_MEM_TWR),
   .C_MEM_TRTP                       (C3_MEM_TRTP),
   .C_MEM_TWTR                       (C3_MEM_TWTR),
   .C_MEM_ADDR_ORDER                 (C3_MEM_ADDR_ORDER),
   .C_NUM_DQ_PINS                    (C3_NUM_DQ_PINS),
   .C_MEM_TYPE                       (C3_MEM_TYPE),
   .C_MEM_DENSITY                    (C3_MEM_DENSITY),
   .C_MEM_BURST_LEN                  (C3_MEM_BURST_LEN),
   .C_MEM_CAS_LATENCY                (C3_MEM_CAS_LATENCY),
   .C_MEM_ADDR_WIDTH                 (C3_MEM_ADDR_WIDTH),
   .C_MEM_BANKADDR_WIDTH             (C3_MEM_BANKADDR_WIDTH),
   .C_MEM_NUM_COL_BITS               (C3_MEM_NUM_COL_BITS),
   .C_MEM_DDR1_2_ODS                 (C3_MEM_DDR1_2_ODS),
   .C_MEM_DDR2_RTT                   (C3_MEM_DDR2_RTT),
   .C_MEM_DDR2_DIFF_DQS_EN           (C3_MEM_DDR2_DIFF_DQS_EN),
   .C_MEM_DDR2_3_PA_SR               (C3_MEM_DDR2_3_PA_SR),
   .C_MEM_DDR2_3_HIGH_TEMP_SR        (C3_MEM_DDR2_3_HIGH_TEMP_SR),
   .C_MEM_DDR3_CAS_LATENCY           (C3_MEM_DDR3_CAS_LATENCY),
   .C_MEM_DDR3_ODS                   (C3_MEM_DDR3_ODS),
   .C_MEM_DDR3_RTT                   (C3_MEM_DDR3_RTT),
   .C_MEM_DDR3_CAS_WR_LATENCY        (C3_MEM_DDR3_CAS_WR_LATENCY),
   .C_MEM_DDR3_AUTO_SR               (C3_MEM_DDR3_AUTO_SR),
   .C_MEM_DDR3_DYN_WRT_ODT           (C3_MEM_DDR3_DYN_WRT_ODT),
   .C_MEM_MOBILE_PA_SR               (C3_MEM_MOBILE_PA_SR),
   .C_MEM_MDDR_ODS                   (C3_MEM_MDDR_ODS),
   .C_MC_CALIB_BYPASS                (C3_MC_CALIB_BYPASS),
   .C_MC_CALIBRATION_MODE            (C3_MC_CALIBRATION_MODE),
   .C_MC_CALIBRATION_DELAY           (C3_MC_CALIBRATION_DELAY),
   .C_SKIP_IN_TERM_CAL               (C3_SKIP_IN_TERM_CAL),
   .C_SKIP_DYNAMIC_CAL               (C3_SKIP_DYNAMIC_CAL),
   .C_LDQSP_TAP_DELAY_VAL            (C3_LDQSP_TAP_DELAY_VAL),
   .C_LDQSN_TAP_DELAY_VAL            (C3_LDQSN_TAP_DELAY_VAL),
   .C_UDQSP_TAP_DELAY_VAL            (C3_UDQSP_TAP_DELAY_VAL),
   .C_UDQSN_TAP_DELAY_VAL            (C3_UDQSN_TAP_DELAY_VAL),
   .C_DQ0_TAP_DELAY_VAL              (C3_DQ0_TAP_DELAY_VAL),
   .C_DQ1_TAP_DELAY_VAL              (C3_DQ1_TAP_DELAY_VAL),
   .C_DQ2_TAP_DELAY_VAL              (C3_DQ2_TAP_DELAY_VAL),
   .C_DQ3_TAP_DELAY_VAL              (C3_DQ3_TAP_DELAY_VAL),
   .C_DQ4_TAP_DELAY_VAL              (C3_DQ4_TAP_DELAY_VAL),
   .C_DQ5_TAP_DELAY_VAL              (C3_DQ5_TAP_DELAY_VAL),
   .C_DQ6_TAP_DELAY_VAL              (C3_DQ6_TAP_DELAY_VAL),
   .C_DQ7_TAP_DELAY_VAL              (C3_DQ7_TAP_DELAY_VAL),
   .C_DQ8_TAP_DELAY_VAL              (C3_DQ8_TAP_DELAY_VAL),
   .C_DQ9_TAP_DELAY_VAL              (C3_DQ9_TAP_DELAY_VAL),
   .C_DQ10_TAP_DELAY_VAL             (C3_DQ10_TAP_DELAY_VAL),
   .C_DQ11_TAP_DELAY_VAL             (C3_DQ11_TAP_DELAY_VAL),
   .C_DQ12_TAP_DELAY_VAL             (C3_DQ12_TAP_DELAY_VAL),
   .C_DQ13_TAP_DELAY_VAL             (C3_DQ13_TAP_DELAY_VAL),
   .C_DQ14_TAP_DELAY_VAL             (C3_DQ14_TAP_DELAY_VAL),
   .C_DQ15_TAP_DELAY_VAL             (C3_DQ15_TAP_DELAY_VAL)
	)
memc3_wrapper_inst
	(
   .mcb3_dram_dq                        (ddr2_dq),
   .mcb3_dram_a                         (ddr2_a),
   .mcb3_dram_ba                        (ddr2_ba),
   .mcb3_dram_ras_n                     (ddr2_ras_n),
   .mcb3_dram_cas_n                     (ddr2_cas_n),
   .mcb3_dram_we_n                      (ddr2_we_n),
   .mcb3_dram_odt                       (ddr2_odt),
   .mcb3_dram_cke                       (ddr2_cke),
   .mcb3_dram_dm                        (ddr2_dm),
   .mcb3_dram_udqs                      (ddr2_udqs),
   .mcb3_dram_udqs_n                    (ddr2_udqs_n),
   .mcb3_rzq                            (ddr2_rzq),
   .mcb3_zio                            (ddr2_zio),
   .mcb3_dram_udm                       (ddr2_udm),
   .calib_done                          (c3_calib_done),
   .async_rst                           (c3_async_rst),
   .sysclk_2x                           (c3_sysclk_2x),
   .sysclk_2x_180                       (c3_sysclk_2x_180),
   .pll_ce_0                            (c3_pll_ce_0),
   .pll_ce_90                           (c3_pll_ce_90),
   .pll_lock                            (c3_pll_lock),
   .mcb_drp_clk                         (c3_mcb_drp_clk),
   .mcb3_dram_dqs                       (ddr2_dqs),
   .mcb3_dram_dqs_n                     (ddr2_dqs_n),
   .mcb3_dram_ck                        (ddr2_ck),
   .mcb3_dram_ck_n                      (ddr2_ck_n),
   .p0_cmd_clk                          (c3_clk0),
   .p0_cmd_en                           (c3_p0_cmd_en),
   .p0_cmd_instr                        (c3_p0_cmd_instr),
   .p0_cmd_bl                           (c3_p0_cmd_bl),
   .p0_cmd_byte_addr                    (c3_p0_cmd_byte_addr),
   .p0_cmd_empty                        (c3_p0_cmd_empty),
   .p0_cmd_full                         (c3_p0_cmd_full),
   .p0_wr_clk                           (c3_clk0),
   .p0_wr_en                            (c3_p0_wr_en),
   .p0_wr_mask                          (c3_p0_wr_mask),
   .p0_wr_data                          (c3_p0_wr_data),
   .p0_wr_full                          (c3_p0_wr_full),
   .p0_wr_empty                         (c3_p0_wr_empty),
   .p0_wr_count                         (c3_p0_wr_count),
   .p0_wr_underrun                      (c3_p0_wr_underrun),
   .p0_wr_error                         (c3_p0_wr_error),
   .p0_rd_clk                           (c3_clk0),
   .p0_rd_en                            (c3_p0_rd_en),
   .p0_rd_data                          (c3_p0_rd_data),
   .p0_rd_full                          (c3_p0_rd_full),
   .p0_rd_empty                         (c3_p0_rd_empty),
   .p0_rd_count                         (c3_p0_rd_count),
   .p0_rd_overflow                      (c3_p0_rd_overflow),
   .p0_rd_error                         (c3_p0_rd_error),
   .selfrefresh_enter                   (selfrefresh_enter),
   .selfrefresh_mode                    (selfrefresh_mode)
	);


 ddr2_fifo adcfifo
	(
	.clk(c3_clk0),
	.reset(globalreset | c3_rst0), 
	.reads_en(ddr_readenable),
	.writes_en(ddr_writeenable),
	.calib_done(c3_calib_done), 

	.ib_re(pipe_in_read),
	.ib_data(pipe_in_data),
	.ib_count(pipe_in_rd_count),
	.ib_valid(pipe_in_valid),
	.ib_empty(pipe_in_empty),
	
	.ob_we(pipe_out_write),
	.ob_data(pipe_out_data),
	.ob_count(pipe_out_wr_count),
	
	.p0_rd_en_o(c3_p0_rd_en),  
	.p0_rd_empty(c3_p0_rd_empty), 
	.p0_rd_data(c3_p0_rd_data), 
	
	.p0_cmd_en(c3_p0_cmd_en),
	.p0_cmd_full(c3_p0_cmd_full), 
	.p0_cmd_instr(c3_p0_cmd_instr),
	.p0_cmd_byte_addr(c3_p0_cmd_byte_addr), 
	.p0_cmd_bl_o(c3_p0_cmd_bl), 
	
	.p0_wr_en(c3_p0_wr_en),
	.p0_wr_full(c3_p0_wr_full), 
	.p0_wr_data(c3_p0_wr_data), 
	.p0_wr_mask(c3_p0_wr_mask),
	
	.fill_level_trigger(adc_fill_level_trigger),
	.fill_count(bioee_wireout_adcfifocount)
	);




//Block Throttle
always @(posedge okClk) begin
		if(pipe_in_wr_count <= (FIFO_SIZE-BLOCK_SIZE) ) begin
		  pipe_in_ready <= 1'b1;
		end
		else begin
			pipe_in_ready <= 1'b0;
		end
		
		if(pipe_out_rd_count >= BLOCK_SIZE) begin
		  pipe_out_ready <= 1'b1;
		end
		else begin
			pipe_out_ready <= 1'b0;
		end
		
	end	


endmodule