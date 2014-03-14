
DAQ_constants_include;


% ================================================
% UTILITIES
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

timezero = clock;

CLK1FREQDEFAULT = 100e6;
CLK2FREQDEFAULT = 2e6;

ADC_xfer_len = 1*1024*1024; %bytes
ADC_pkt_len = ADC_xfer_len;

ADCcaptureenable = 1;

ADCSAMPLERATE = CLK2FREQDEFAULT;
ADClogenable = 0;
ADClogsize = 0;

displaybuffersize = ADCSAMPLERATE*0.01;
displaycount = 1;
displayupdaterate = 1;
displaysubsample = 1;
displaybuffer = zeros(displaybuffersize,1);

read_monitor = 0;
write_monitor = 0;

% ================================================
% ENDPOINT ADDRESSES
% ================================================

EP_TRIGGERIN_TEST1 = hex2dec('40');
EP_TRIGGEROUT_TEST1 = hex2dec('60');
EP_WIREIN_TEST1 = hex2dec('00');
EP_WIREOUT_TEST1 = hex2dec('20');

EP_PIPEIN_SCANCHAINS = hex2dec('80');

EP_PIPEOUT_ADC = hex2dec('A0');


% ================================================
% ENDPOINT BIT FIELD LOCATIONS
% ================================================

EPBIT_GLOBALRESET = BITMASK_15;

EPBIT_LED0 = BITMASK_0;
EPBIT_LED1 = BITMASK_1;

EPBIT_SCAN1CLK = BITMASK_0;
EPBIT_SCAN1RESETN = BITMASK_1;
EPBIT_SCAN1LATCH = BITMASK_2;
EPBIT_SCAN1DATA0 = BITMASK_3;
EPBIT_SCAN1DATA1 = BITMASK_4;
EPBIT_SCAN1DATA2 = BITMASK_5;
EPBIT_SCAN1DATA3 = BITMASK_6;
EPBIT_SCAN1DATA4 = BITMASK_7;
EPBIT_SCAN2CLK = BITMASK_8;
EPBIT_SCAN2RESETN = BITMASK_9;
EPBIT_SCAN2LATCH = BITMASK_10;
EPBIT_SCAN2DATA = BITMASK_11;

EPBIT_ADCDATAREADY = BITMASK_0;

%%
[xem,xempll] = DAQ_configureOK();

DAQ_configurePLL(xem,xempll,CLK1FREQDEFAULT,CLK2FREQDEFAULT);


%% -----------------------------------------------------

%trigger
%triggervalue=0;
%setwireinvalue(xem,EP_WIREIN_TEST1, triggervalue*trigger, trigger );    
%updatewireins(xem);

%%
%reset
%resetvalue=1;
%setwireinvalue(xem,EP_WIREIN_TEST1, resetvalue*reset, reset );    
%updatewireins(xem);





%% ---------------------------------------------------
% send data to pipein

%mydata = uint32(rand(5,100).*2^32);
%mydata = uint16(1:16)


%myDACvalues = uint16([12247  32097  29202  42357  46489  49459 0])
%myDACvalues = uint16([65536  32097  29202 0])
%myDACvalues = uint16([2.5 1.9 2.5 2.65])
%-------------------------------------------------------------------------------------------
%myDACvalues = [2.5 1.9 2.5 2.65 0]
myDACvalues = uint32([3.4 1.2 0.9 1.5 2 0])
myDACvalues1 = round (myDACvalues*65536/4.52)
%-------------------------------------------------------------------------------------------
myDelayValues = [1000000 1000000 1000000 1000000 0 0]
myDelayValues1= round (myDelayValues/2.5)
%---------------------------------------------------------------------------------
%myDACvalues = uint16([32357])000000000000
myTriggerBits = [0 1 1 0 1 1]
%myTriggerBits = [0]
%myDelayValues = [100 150 40 20 80 2]
%myDelayValues = [5 10 1000 150 0]
%myDelayValues1= myDelayValues/2.5

%myDelayValues = [0 0 0 20 20 2]

%myInstructions = uint64( uint64(myDACvalues1).*2^48 + uint64(myTriggerBits).*2^3 + uint64(myDelayValues).*2^24 );
% 11AM VERSION      myInstructions = uint64( uint64(myDACvalues).*2^40 + uint64(myTriggerBits).*2^3 + uint64(myDelayValues).*2^4 );

myInstructions = uint32( [ (uint32(myTriggerBits).*2^3 + uint32(myDelayValues1).*2^4); myDACvalues1.*2^16 ] );


%myInstructions = uint32( uint32(myDACvalues).*2^16 
%uint32(myTriggerBits).*2^3 + uint32(myDelayValues).*2^4 );

packet = typecast(myInstructions(:),'uint8');

printpacket=dec2bin(typecast(myInstructions(:),'uint64'),64)
printpacket=dec2bin(typecast(packet,'uint32'),32)


%sendpacket = uint8(zeros(1,512));
%sendpacket(1:length(packet)) = packet;

%bytes_sent = writetopipein(xem, EP_PIPEIN_SCANCHAINS, sendpacket, length(sendpacket))
bytes_sent = writetopipein(xem, EP_PIPEIN_SCANCHAINS, packet, length(packet))
%writetopipein(obj, epaddr, epvalue, psize)

%bytes_sent = writetoblockpipein(xem, EP_PIPEIN_SCANCHAINS, length(packet), packet, length(packet))


%% -------------------------------------------------------
%reset
activatetriggerin(xem, EP_TRIGGERIN_TEST1, 0);    
%activatetriggerin(obj, epaddr, epbit)

%% -------------------------------------------------------



%trigger
activatetriggerin(xem, EP_TRIGGERIN_TEST1, 1);    
%activatetriggerin(obj, epaddr, epbit)
 

