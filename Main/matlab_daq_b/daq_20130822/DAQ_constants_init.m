


warning off all


DAQ_constants_include;


% ================================================
% UTILITIES
% ================================================

k = 1.3806503e-23;
T = 298;

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

timezero = clock;

SAVECONFIGFILE = 'startupconfig.mat';
EVENTLOGFILE = 'EVENT_LOG.txt';


%FPGAMODEL = 'spartan3';
%FPGAMODEL = 'spartan6'
FPGAMODEL = 'spartan6_usb3'

if(strcmp(FPGAMODEL,'spartan3'))
    BITFILENAME = 'bitfile_fpga_spartan3.bit';
    CLK1FREQDEFAULT = 32e6;
    CLK2FREQDEFAULT = 200e3;
    ADCSAMPLERATE = CLK1FREQDEFAULT / 8
    HWBUFFERSIZE_KB = 32*1024;
    ADCMUXDEFAULT = 1;
    RAWDATAFORMAT = 'uint16';
end
    
if(strcmp(FPGAMODEL,'spartan6'))
    BITFILENAME = 'bitfile_fpga_spartan6.bit';
    CLK1FREQDEFAULT = 100e6;
    CLK2FREQDEFAULT = 4e6;
    ADCSAMPLERATE = CLK2FREQDEFAULT 
    HWBUFFERSIZE_KB = 128*1024;
    ADCMUXDEFAULT = 2;
    RAWDATAFORMAT = 'uint16';
end

if(strcmp(FPGAMODEL,'spartan6_usb3'))
    BITFILENAME = 'bitfile_fpga_spartan6_usb3.bit';
    %CLK1FREQDEFAULT = 100e6;
    %CLK2FREQDEFAULT = 4e6;
    ADCSAMPLERATE = 100e6 / 24
    HWBUFFERSIZE_KB = 128*1024;
    ADCMUXDEFAULT = 2;
    RAWDATAFORMAT = 'uint32';
end


MAXLOGBYTES = 80e6;    %maximum log file size


CFAST_gain = 2;
CFAST_CAP0 = 1e-12;
CFAST_CAP1 = 10e-12;



%ADC_xfer_len = 1*1024*1024; %bytes
%ADC_xfer_len = 2*1024*1024; %bytes
ADC_xfer_len = 4*1024*1024; %bytes
ADC_pkt_len = ADC_xfer_len;
ADC_xfer_blocksize = 512;

ADCcaptureenable = 1;

ADCnumsignals=1;  %CHANGED 2/5/2011
            
ADCBITS = 14;   %this may get overwritten by startupconfig.mat
ADCVREF = 2.5;     %this may get overwritten by startupconfig.mat

ADClogenable = 0;
ADClogsize = 0;
ADClogreset = 0;

logADCfid = -1;
logDACfid = -1;

DACBITS = 16;
DACFULLSCALE = 4.5;
DACcurrent = 0;
DACprevious = 0;

ADC_xfer_time = ADC_xfer_len / ADCSAMPLERATE

displaybuffertime = floor(ADC_xfer_time * 10)/50
displaycount = 1;
displayupdaterate = 2;
%displaysubsample = 500
%displaysubsample = 50
displaysubsample = 16
displaybuffersize = ADCnumsignals*ADCSAMPLERATE*displaybuffertime/displaysubsample;
displaybuffer = zeros(displaybuffersize,1);


PREVIEWtime = displaybuffertime;


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
EP_WIREIN_HOLDSECONDS = hex2dec('02');
EP_WIREIN_ADCMUX = hex2dec('01');
EP_WIREOUT_TEST1 = hex2dec('20');
EP_WIREOUT_ADCFIFOCOUNT = hex2dec('21');

EP_PIPEIN_VECTOR = hex2dec('80');
EP_PIPEIN_DACFSM = hex2dec('81');

EP_PIPEOUT_ADC = hex2dec('A0');
PIPEOUT_FSM_CURRENT_STATE = hex2dec('A1');
PIPEIN_HOLDSECONDS = hex2dec('82');

% ================================================
% ENDPOINT BIT FIELD LOCATIONS
% ================================================

EPBIT_HEADSTAGE_PWR_EN = BITMASK_0;
EPBIT_HEADSTAGE_PWR_LED = BITMASK_1;

EPBIT_ENABLEADCFIFO = BITMASK_4;
EPBIT_GLOBALRESET = BITMASK_15;

EPBIT_DACSDI  = BITMASK_0;
EPBIT_DACCLK = BITMASK_1; 
EPBIT_DACNCS  = BITMASK_2;
EPBIT_DACSDI_FASTC = BITMASK_8;
EPBIT_DAC_NLOAD = BITMASK_10;

EPBIT_DPOT_CLK = BITMASK_4;
EPBIT_DPOT_SDI = BITMASK_5;
EPBIT_DPOT_NCS = BITMASK_6;

EPBIT_FASTC_CAPMUX = BITMASK_9;

EPBIT_DAQTRIGGER = BITMASK_15;

EPBIT_ADCDATAREADY = BITMASK_0;
EPBIT_ADC1MUX0 = BITMASK_0;
EPBIT_ADC1MUX1 = BITMASK_1;


EPBIT_DACFSM_RESETFIFO = 0;
EPBIT_DACFSM_FORCETRIGGER = 1;


EP_ACTIVELOWBITS = EPBIT_DACNCS + EPBIT_DAC_NLOAD + EPBIT_DPOT_NCS;




% ================================================
% SCAN CHAIN DATA LOCATIONS
% ================================================

DAC_SCANCHAIN_LENGTH = 16;
DAC_MSB = 16;
DAC_LSB = 1;

DPOT_SCANCHAIN_LENGTH = 9;
DPOT_A = 9;
DPOT_MSB = 8;
DPOT_LSB = 1;


