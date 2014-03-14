warning off all

DAQ_constants_include;

% ================================================
% COLORS
% ================================================ 

% uisetcolor

lightgreen = [0.455 0.875 0.463];  
lightred   = [0.957 0.592 0.592];
lightblue = [0.494 0.627, 0.984];

lightgrey = [0.8000 0.8000 0.8000];

lightwhite = [1 1 1];
lightblack = [0 0 0];

% ================================================
% DAQ State
% ================================================ 

daq_initialized = 0;

% ================================================
% DEBUG REPORTING
% ================================================

show_debug_report = 0;
% show_debug_report = -1;% all
% show_debug_report = 0; % no reporting
% show_debug_report = 1; % update reports
% show_debug_report = 2; % bytes_sent plots
% show_debug_report = 3; % scanvector plots
% show_debug_report = 4; % displayed initialized constants
% show_debug_report = 5; % display auto voltage zero 
% show_debug_report = 6; % display dac instructions

toggle_DAC_to_DOT = 0;
toggle_DPOT_to_DAC = 0;

% ================================================
% PHYSICAL CONSTANTS
% ================================================

kBolt = 1.3806503e-23; % boltzman's constant [J/K]
Troom = 298; % room temperature [K]
qe = 1.602e-19; % electron charge

% ================================================
% CIRCUIT ELEMENT VALUES
% ================================================

% PreAmp Network
C18 = 0.2e-12;
C18parasitics = 0.3e-12;
C_f_preamp = C18+C18parasitics; % C18 + parasitics [F]

% Boost1 Compensation Network
C1_boost1 = 6.2e-9; % C35 & C55 [F]
R2_boost1 = 10e3; % R82 & R83 [X] 

% Cfast Compensation Network
R1_Cfast = inf; % R42 [X], c_fast compensator's amplifier's reference connected input resistor
R2_Cfast = 0; % R44 [X], c_fast compensator's amplifier's feedback resistor
CFAST_gain = (1+R2_Cfast/R1_Cfast); % c_fast compensator's injection capacitor value (on board value) [V/V]
CFAST_CAP0 = 1e-12; % C27 [F], c_fast compensator's injection capacitor value (on board value)

% Cslow Compensation Network
R1_Cslow = 1e3; % R102 [X], c_slow compensator's amplifier's reference connected input resistor
CSLOW_CAP0 = 10e-12; % C103 [F], c_slow compensator's injection capacitor value (on board value) 
CAP_Rseries_x_Cslow = 10e-6; % C98 [F] low pass filter at output of cslow which can be varied during simultaneous Cslow and Rseries compensation the RC time constant should be equal to Rseries*Cslow after tuning

% ================================================
% CIRCUIT CONTROL DEFAULTS
% ================================================

% Default values (inactive and passive states of controls)
default_cslow_R2 = 0; %[X]
passive_cslow_R2 = 1e3; % [X]
default_rseries = 0; % [X]
default_rseries_comp = 0; % [%]
default_super = 0; % [%]

% ================================================
% BITMASKS 
% ================================================

BITMASK_ALL = hex2dec('ffff');
BITMASK_0 = hex2dec('0001');
BITMASK_1 = hex2dec('0002');
BITMASK_2 = hex2dec('0004');
BITMASK_3 = hex2dec('0008');
BITMASK_4 = hex2dec('0010');
BITMASK_5 = hex2dec('0020');
BITMASK_6 = hex2dec('0040');
BITMASK_7 = hex2dec('0080');
BITMASK_8 = hex2dec('0100');
BITMASK_9 = hex2dec('0200');
BITMASK_10 = hex2dec('0400');
BITMASK_11 = hex2dec('0800');
BITMASK_12 = hex2dec('1000');
BITMASK_13 = hex2dec('2000');
BITMASK_14 = hex2dec('4000');
BITMASK_15 = hex2dec('8000');

% ================================================
% INFO: DPOT
% ================================================

% %  MODEL: AD5262
DPOTbits = 8;

% Nominal individual potentiometer resistances
R_nominal_AB = 20e3; % nominal A to B terminal resistance
R_nominal_W = 60; % wiper resistance

% ================================================
% INFO: DAC
% ================================================

% %  MODEL: AD5541A
DACbits = 16; % DAC bits
DACFULLSCALE = 4.5; % DAC_REF voltage
DACcurrent = 0;
DACprevious = 0;

% DAQ Output Range
DAC_output_min = 0.004; % experimentally measured output min [V]
DAC_output_max = 4.190; % experimentally measure output max [V]

% Command Reference Voltage
% DAC_center_voltage = 0.5*DACFULLSCALE;
DAC_center_voltage = 0.5*(DAC_output_max - DAC_output_min) + DAC_output_min;

% Minimum & Maximumal Allowed Command Voltage
DAC_command_volt_min = -1.8; % [differential V]
DAC_command_volt_max = 1.8; % [differential V]

% ================================================
% INFO: FPGA
% ================================================

%FPGAMODEL = 'spartan3';
%FPGAMODEL = 'spartan6'
FPGAMODEL = 'spartan6_usb3';

if(strcmp(FPGAMODEL,'spartan3'))
    BITFILENAME = 'bitfile_fpga_spartan3.bit';
    CLK1FREQDEFAULT = 32e6;
    CLK2FREQDEFAULT = 200e3;
    ADCSAMPLERATE = CLK1FREQDEFAULT / 8;
    HWBUFFERSIZE_KB = 32*1024;
    ADCMUXDEFAULT = 1;
    RAWDATAFORMAT = 'uint16';
end
    
if(strcmp(FPGAMODEL,'spartan6'))
    BITFILENAME = 'bitfile_fpga_spartan6.bit';
    CLK1FREQDEFAULT = 100e6;
    CLK2FREQDEFAULT = 4e6;
    ADCSAMPLERATE = CLK2FREQDEFAULT;
    HWBUFFERSIZE_KB = 128*1024;
    ADCMUXDEFAULT = 2;
    RAWDATAFORMAT = 'uint16';
end

if(strcmp(FPGAMODEL,'spartan6_usb3'))
    BITFILENAME = 'bitfile_fpga_spartan6_usb3.bit';
    %CLK1FREQDEFAULT = 100e6;
    %CLK2FREQDEFAULT = 4e6;
    ADCSAMPLERATE = 100e6 / 24;
    HWBUFFERSIZE_KB = 128*1024;
    ADCMUXDEFAULT = 2;
    RAWDATAFORMAT = 'uint32';
end

% ================================================
% INFO: ADC
% ================================================

% %  MODEL: AD9240
ADCBITS = 14;   %this may get overwritten by startupconfig.mat
ADCVREF = 2.5;     %this may get overwritten by startupconfig.mat
ADCnumsignals=1;  

%ADC_xfer_len = 1*1024*1024; %bytes
%ADC_xfer_len = 2*1024*1024; %bytes
ADC_xfer_len = 4*1024*1024; %bytes
ADC_pkt_len = ADC_xfer_len;
ADC_xfer_blocksize = 512;
ADC_xfer_time = ADC_xfer_len / ADCSAMPLERATE;

% % Initialize
ADCcaptureenable = 1;
ADClogenable = 0;

% 1234: logfid = -1;
logADCfid = -1;
logDACfid = -1;

ADClogsize = 0;
ADClogreset = 0;

% ================================================
% INFO: Buffer 
% ================================================

% %  MODEL: (in ADC)

displaybuffertime = floor(ADC_xfer_time * 10)/50;
displaycount = 1;
displayupdaterate = 2;
displaysubsample = 16;
displaybuffersize = ADCnumsignals*ADCSAMPLERATE*displaybuffertime/displaysubsample;
displaybuffer = zeros(displaybuffersize,1);

% ================================================
% DAQ LOG & OTHER UTILITIES
% ================================================

timezero = clock;

SAVECONFIGFILE = 'startupconfig.mat';
EVENTLOGFILE = 'EVENT_LOG.txt';

MAXLOGBYTES = 80e6; % maximum log file size

PREVIEWtime = displaybuffertime; % 

read_monitor = 0;
write_monitor = 0;

C_estimate = 0;

myIrms=0;

isUnclogging=0;

% ================================================
% ENDPOINT ADDRESSES
% ================================================

EP_TRIGGERIN_DACFSM = hex2dec('40');
EP_TRIGGEROUT_TEST1 = hex2dec('60');
EP_WIREIN_TEST1 = hex2dec('00');
EP_WIREIN_ADCMUX = hex2dec('01');
EP_WIREOUT_TEST1 = hex2dec('20');
EP_WIREOUT_ADCFIFOCOUNT = hex2dec('21');
EP_PIPEIN_VECTOR = hex2dec('80');
EP_PIPEOUT_ADC = hex2dec('A0');


EP_WIREIN_HOLDSECONDS = hex2dec('02');
EP_PIPEIN_DACFSM = hex2dec('81');
PIPEOUT_FSM_CURRENT_STATE = hex2dec('A1');
PIPEIN_HOLDSECONDS = hex2dec('82');

% ================================================
% ENDPOINT BIT FIELD LOCATIONS
% ================================================

% % Global
EPBIT_GLOBALRESET = BITMASK_15;

% % DACs
EPBIT_DACSDI  = BITMASK_0; % counter
EPBIT_DAC2SDI = BITMASK_8; % compensation
EPBIT_DACCLK = BITMASK_1; 
EPBIT_DACNCS  = BITMASK_2;
EPBIT_DAC_NLOAD = BITMASK_10;

% % DPOTs
EPBIT_DPOT_CLK = BITMASK_4;
EPBIT_DPOT_NCS = BITMASK_6;
EPBIT_DPOT1_SDI = BITMASK_5;
EPBIT_DPOT2_SDI = BITMASK_7;
EPBIT_DPOT3_SDI = BITMASK_11;

% EPBIT_FASTC_CAPMUX = BITMASK_9; % no longer used

% % DAQ Trigger
EPBIT_DAQTRIGGER = BITMASK_15;

% % ADC
EPBIT_ENABLEADCFIFO = BITMASK_4;
EPBIT_ADCDATAREADY = BITMASK_0;
EPBIT_ADC1MUX0 = BITMASK_0;
EPBIT_ADC1MUX1 = BITMASK_1;

% % Headstage Power
EPBIT_HEADSTAGE_PWR_EN = BITMASK_0;
EPBIT_HEADSTAGE_PWR_LED = BITMASK_1;

% % Active Low Bits 
EP_ACTIVELOWBITS = EPBIT_DACNCS + EPBIT_DAC_NLOAD + EPBIT_DPOT_NCS;

% % Initialize FIFO
EPBIT_DACFSM_RESETFIFO = 0;
EPBIT_DACFSM_FORCETRIGGER = 1;

% ================================================
% SCAN CHAIN DATA LOCATIONS
% ================================================

% % DACs
DAC_SCANCHAIN_LENGTH = 16;
DAC_MSB = 16;
DAC_LSB = 1;

% % DPOTs
DPOT_SCANCHAIN_LENGTH = 9;
DPOT_A = 9;
DPOT_MSB = 8;
DPOT_LSB = 1;

