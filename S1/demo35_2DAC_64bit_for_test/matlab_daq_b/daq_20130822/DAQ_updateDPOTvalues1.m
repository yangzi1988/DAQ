

function DAQ_updateDPOTvalues1(handles)

%AD5262


%disp('start potvalues update');

DAQ_constants_include;

myDPOTvalue = str2double(get(handles.edit_freqcomp,'String'));

DPOTbits = 8;

DPOTcode = uint8( myDPOTvalue/100*(2^DPOTbits) )
% send to both addresses
mydacvector = [ VECTOR_DPOT_AD5262(DPOTcode,0) VECTOR_DPOT_AD5262(DPOTcode,1) ];


% --- display vector ---
%{
vectorlength = length(mydacvector)
printvector = dec2bin(mydacvector,16)
toplot = dec2bin(mydacvector,16)-'0';
toplot = 0.5*toplot + ones(vectorlength,1) * (15:-1:0);
figure; stairs(toplot);
%}
% ---------------

% COMMENTED OUT 4/28/2011
%ADClogreset=1;

%if(exist('handles.xem'))

DAQ_sendscanvector1(handles.xem, mydacvector);



% LOG EVENT
newlogentry = sprintf('%s: DPOT=%d \r\n',datestr(now,'yyyymmdd_HHMMSS'), DPOTcode);
fid=fopen(EVENTLOGFILE,'a');
fwrite(fid,newlogentry);
fclose(fid);





%disp('end potvalues update');






