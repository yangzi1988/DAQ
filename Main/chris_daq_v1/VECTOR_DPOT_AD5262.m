function returnvector = VECTOR_DPOT_AD5262(DPOTvalues,DPOTaddresses)
% Structure:
%   returnvector = VECTOR_nX_DPOT_AD5262(DPOTvalues,DPOTaddresses)
%
% Description:
%   Constructs vector with desired values for each dual potentiometer
%
% Input:
%     DPOTvalues = [1xn array] of update wiper position values (one update wiper position value per DPOT)
%     DPOTaddresses = [1xn array] vector of wiper select values (one wiper select value for each DPOT)
% 
% Output:
%   returnvector = [array] DPOTs' new values vector ready to be sent to the FPGA
%
% Range:
%   DPOTvalues(i) E: Z & [0,256] 
%   DPOTaddresses = E: Z & [0, 1]
%
% Example: 
%   % update all 3 pots and all of their wipers in two cycles
%   mydacvector = [ VECTOR_DPOT_AD5262([34 54 66],[0 1 0]) VECTOR_DPOT_AD5262([75 73 11],not([0 1 0])) ];% [ cycle_1_update_value cycle_2_update_value]
%   DAQ_sendscanvector(handles.xem, mydacvector);
%
% Note: 
%   1.) DPOTaddress(i) = { 0 if addressing Wiper 1(W1) , 1 if addressing Wiper 2(W2)}
%   2.) Dual potentiometers wipers are selected by the DPOTaddress value
%       meaning only one wiper of each potentiometer can be addressed per clock
%       cycle. thus the function constructs an update vector which contains only 
%       one value & address per potentiometer 
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DAQ_constants_include;

vector_debug = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Formate the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Function testing
% DPOTvalues = [245 50 3];
% DPOTaddresses = [0 1 0];

if vector_debug 
    disp([char(10) '>>>>>>>>>VECTOR_DPOT_AD5262 Report Start>>>>>>>>> '])
    
    disp([char(10) '-1) DPOTvalues'])
    disp(num2str(DPOTvalues))

    disp([char(10) '0) DPOTaddresses'])
    disp(num2str(DPOTaddresses))
end

DPOTdata = zeros(3,DPOT_SCANCHAIN_LENGTH); % initiate data
DPOTdata(:,DPOT_A) = DPOTaddresses; % add addresses to data

if vector_debug 
    disp([char(10) '1) DPOTdata'])
    disp(num2str(DPOTdata))
end

DPOTbinary = dec2bin(DPOTvalues,DPOTbits)-'0'; % convert to binary


if vector_debug 
    disp([char(10) '1.5) DPOTbinary'])
    disp(num2str(DPOTbinary))
end


DPOTdata(:,DPOT_MSB:-1:DPOT_LSB) = DPOTbinary; % correctly orient the data and combine with address values

if vector_debug 
    disp([char(10) '2) DPOTdata'])
    disp(num2str(DPOTdata))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Building Return Vector 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if vector_debug 
    disp([char(10) '3.0.1) EPBIT_DPOT1_SDI'])
    disp(num2str(EPBIT_DPOT1_SDI))
    disp(num2str(DPOTdata(1,:)))

    disp([char(10) '3.0.2) EPBIT_DPOT2_SDI'])
    disp(num2str(EPBIT_DPOT2_SDI))
    disp(num2str(DPOTdata(2,:)))
    
    disp([char(10) '3.0.3) EPBIT_DPOT3_SDI'])
    disp(num2str(EPBIT_DPOT3_SDI))
    disp(num2str(DPOTdata(3,:)))
end

returnvector = EPBIT_DPOT1_SDI*DPOTdata(1,:) + EPBIT_DPOT2_SDI*DPOTdata(2,:) + EPBIT_DPOT3_SDI*DPOTdata(3,:); % assign each DPOTs value to the correct pin

%returnvector = returnvector(length(returnvector):-1:1);

if vector_debug 
    disp([char(10) '3) returnvector'])
    disp(num2str(returnvector))
end

returnvector = returnvector(:)';

if vector_debug 
    disp([char(10) '4) returnvector'])
    disp(num2str(returnvector))
end

%returnvector  = [returnvector returnvector ];

returnvector  = upsample(returnvector,2,0) + upsample(returnvector,2,1);

if vector_debug 
    disp([char(10) '5) returnvector'])
    disp(num2str(returnvector))
end

vectorlength = length(returnvector);
myclk = 0.5+0.5*square(1/1*3.1416*(2:(vectorlength+1)));
returnvector = returnvector + EPBIT_DPOT_CLK*myclk;

if vector_debug 
    disp([char(10) '6) returnvector'])
    disp(num2str(returnvector))
end

returnvector = returnvector(vectorlength:-1:1);

if vector_debug 
    disp([char(10) '7) returnvector'])
    disp(num2str(returnvector))
end

returnvector = [    EPBIT_DPOT_NCS          ...
                    0                     ...
                    returnvector          ...
                    0                     ...
                    EPBIT_DPOT_NCS          ...
                ];

if vector_debug
    disp([char(10) '8) returnvector'])
    disp(num2str(returnvector))
end         
            
returnvector = returnvector + (EP_ACTIVELOWBITS-EPBIT_DPOT_NCS);                
  
if vector_debug 
    disp([char(10) '9) returnvector'])
    disp(num2str(returnvector))
end

if vector_debug 
    disp([char(10) '<<<<<<<<<VECTOR_DPOT_AD5262 Report End<<<<<<<<<<< ' char(10)])
end

end %function


