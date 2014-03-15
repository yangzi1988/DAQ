
% ================================================
% COLORS
% ================================================

global lightgreen
global lightred  
global lightblue

global lightgrey

global lightwhite
global lightblack

% ================================================
% DAQ State
% ================================================ 

global daq_initialized

% ================================================
% DEBUG REPORTING
% ================================================

global show_debug_report
global toggle_DAC_to_DOT toggle_DPOT_to_DAC

% ================================================
% PHYSICAL CONSTANTS
% ================================================
 
global kBolt Troom qe

% ================================================
% CIRCUIT ELEMENT VALUES
% ================================================

global R_f_preamp C_f_preamp fc1_preamp

global C1_boost1 R1_boost1 R2_boost1 gain_boost1 fc1_boost1 

global R1_Cfast R2_Cfast CFAST_gain CFAST_CAP0 CFAST_CAP  

global R1_Cslow R2_Cslow CSLOW_gain CSLOW_CAP0 CSLOW_CAP CAP_Rseries_x_Cslow

global Rseries Ts_est degree_comp_Rseries degree_comp_Supercharge

global preADCgain TIAgain

% ================================================
% CIRCUIT CONTROL DEFAULTS
% ================================================

global default_cslow_R2 passive_cslow_R2 default_rseries default_rseries_comp default_super

% ================================================
% BITMASKS
% ================================================

global BITMASK_ALL BITMASK_0 BITMASK_1 BITMASK_2 BITMASK_3 
global BITMASK_4 BITMASK_5 BITMASK_6 BITMASK_7 BITMASK_8 
global BITMASK_9 BITMASK_10 BITMASK_11 BITMASK_12 BITMASK_13 
global BITMASK_14 BITMASK_15

% ================================================
% INFO: FPGA
% ================================================

global FPGAMODEL BITFILENAME  bitfile
global CLK1FREQDEFAULT CLK2FREQDEFAULT
global ADCSAMPLERATE HWBUFFERSIZE_KB 
global ADCMUXDEFAULT RAWDATAFORMAT

% ================================================
% INFO: DAC
% ================================================

global DACbits DACFULLSCALE
global DACcurrent DACprevious

global DAC_center_voltage DAC_center_voltage_true

global DAC_command_volt_min DAC_command_volt_max

global DAC_output_min DAC_output_max

global DAC1voltage DAC2voltage

global offsetvoltage

% ================================================
% INFO: DPOT
% ================================================

global DPOTbits 
global R_nominal_AB R_nominal_W

global vDPOT1 
global vDPOT2 
global vDPOT3 

% ================================================
% INFO: ADC
% ================================================

global ADCVREF ADCBITS ADCnumsignals
global ADC_xfer_len ADC_pkt_len ADC_xfer_blocksize ADC_xfer_time
global ADCcaptureenable ADClogenable ADClogsize ADClogreset
global logADCfid logDACfid % 1234: logfid

% ================================================
% INFO: Buffer 
% ================================================

global displaybuffersize displaycount displayupdaterate 
global displaysubsample displaybuffer displaybuffertime

% ================================================
% DAQ LOG & OTHER UTILITIES
% ================================================

global timezero

global SAVECONFIGFILE EVENTLOGFILE

global MAXLOGBYTES

global read_monitor write_monitor

global PREVIEWtime 

global C_estimate

global myIdc myIrms

global isUnclogging

% ================================================
% ENDPOINT ADDRESSES
% ================================================

global EP_TRIGGERIN_DACFSM
global EP_TRIGGEROUT_TEST1
global EP_WIREIN_TEST1
global EP_WIREIN_ADCMUX
global EP_WIREOUT_TEST1
global EP_WIREOUT_ADCFIFOCOUNT
global EP_PIPEIN_VECTOR
global EP_PIPEOUT_ADC

global EP_WIREIN_HOLDSECONDS
global EP_PIPEIN_DACFSM
global PIPEOUT_FSM_CURRENT_STATE
global PIPEIN_HOLDSECONDS

% ================================================
% ENDPOINT BIT FIELD LOCATIONS
% ================================================

global EPBIT_ASSERTINTEGRATORRESET EPBIT_ENABLEADCFIFO 
global EPBIT_GLOBALRESET

global EPBIT_LED0 EPBIT_LED1

global EPBIT_DACSDI EPBIT_DAC2SDI EPBIT_DACCLK EPBIT_DACNCS EPBIT_DAC_NLOAD 

global EPBIT_DPOT_CLK  EPBIT_DPOT_NCS 
global EPBIT_DPOT1_SDI EPBIT_DPOT2_SDI EPBIT_DPOT3_SDI

% global EPBIT_FASTC_CAPMUX 

global EPBIT_DAQTRIGGER

global EPBIT_ADCDATAREADY
global EPBIT_ADC1MUX0 EPBIT_ADC1MUX1
global EPBIT_HEADSTAGE_PWR_EN EPBIT_HEADSTAGE_PWR_LED

global EP_ACTIVELOWBITS
global EPBIT_DACFSM_RESETFIFO EPBIT_DACFSM_FORCETRIGGER
% ================================================
% SCAN CHAIN DATA LOCATIONS
% ================================================

global DAC_SCANCHAIN_LENGTH DAC_MSB DAC_LSB

global DPOT_SCANCHAIN_LENGTH DPOT_A DPOT_MSB DPOT_LSB

% global MDAC_SCANCHAIN_LENGTH MDAC_A1 MDAC_A0 MDAC_MSB MDAC_LSB % ?old?

% ================================================
% CHIP CONFIGURATION
% ================================================

global SETUP_TIAgain
global SETUP_preADCgain






