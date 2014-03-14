
% ================================================
% UTILITIES
% ================================================

global SAVECONFIGFILE EVENTLOGFILE

global BITMASK_ALL BITMASK_0 BITMASK_1 BITMASK_2 BITMASK_3 BITMASK_4 BITMASK_5 BITMASK_6 BITMASK_7
global BITMASK_8 BITMASK_9 BITMASK_10 BITMASK_11 BITMASK_12 BITMASK_13 BITMASK_14 BITMASK_15

global FPGAMODEL HWBUFFERSIZE_KB BITFILENAME RAWDATAFORMAT

global CLK1FREQDEFAULT CLK2FREQDEFAULT

global ADCVREF ADCBITS DACBITS DACFULLSCALE

global ADCMUXDEFAULT

global MAXLOGBYTES

global CFAST_gain CFAST_CAP0 CFAST_CAP1 

global DACcurrent DACprevious

global ADC_xfer_len ADC_pkt_len ADC_xfer_blocksize

global timezero

global ADCcaptureenable ADClogenable logADCfid logDACfid ADClogsize ADCSAMPLERATE ADClogreset

global displaybuffersize displaycount displayupdaterate displaysubsample displaybuffer displaybuffertime
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
global EP_PIPEIN_DACFSM



global PIPEIN_HOLDSECONDS
global EP_PIPEOUT_ADC
global EP_WIREIN_HOLDSECONDS
global PIPEOUT_FSM_CURRENT_STATE
    

% ================================================
% ENDPOINT BIT FIELD LOCATIONS
% ================================================

global EPBIT_ASSERTINTEGRATORRESET EPBIT_ENABLEADCFIFO 
global EPBIT_GLOBALRESET

global EPBIT_LED0 EPBIT_LED1

global EPBIT_DACSDI EPBIT_DACCLK EPBIT_DACNCS EPBIT_DAC_NLOAD EPBIT_DACSDI_FASTC

global EPBIT_DPOT_CLK EPBIT_DPOT_SDI EPBIT_DPOT_NCS

global EPBIT_FASTC_CAPMUX 

global EPBIT_DAQTRIGGER

global EPBIT_ADCDATAREADY
global EPBIT_ADC1MUX0 EPBIT_ADC1MUX1
global EPBIT_HEADSTAGE_PWR_EN EPBIT_HEADSTAGE_PWR_LED

global EP_ACTIVELOWBITS


global EPBIT_DACFSM_RESETFIFO EPBIT_DACFSM_FORCETRIGGER

% ================================================
% CHIP CONFIGURATION
% ================================================

global SETUP_TIAgain
global SETUP_preADCgain

% ================================================
% SCAN CHAIN DATA LOCATIONS
% ================================================

global DAC_SCANCHAIN_LENGTH DAC_MSB DAC_LSB

global DPOT_SCANCHAIN_LENGTH DPOT_A DPOT_MSB DPOT_LSB

global MDAC_SCANCHAIN_LENGTH MDAC_A1 MDAC_A0 MDAC_MSB MDAC_LSB 








