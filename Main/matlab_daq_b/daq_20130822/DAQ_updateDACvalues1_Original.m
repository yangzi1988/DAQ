

function DAQ_updateDACvalues1(handles)

%disp('start potvalues update');

DAQ_constants_include;

newbiasvalue = str2double(get(handles.text_biasvoltage,'String'))*1e-3;
newbiasvalue = min(1,newbiasvalue);
newbiasvalue = max(-1,newbiasvalue);
set(handles.text_biasvoltage,'String',newbiasvalue*1e3)

fprintf('bias=%dmV\n',newbiasvalue*1e3);

myvoltageoffset = str2double(get(handles.edit_mVoffset,'String'))*1e-3;

myCfast = str2double(get(handles.edit_Cfast,'String'))*1e-12;

cfastrange = get(handles.checkbox_cfastrange,'Value');
if(cfastrange==0)
    Cfastvalue = CFAST_CAP0;
else
    Cfastvalue = CFAST_CAP0+CFAST_CAP1;
end

newCfastDACvoltage = - newbiasvalue * myCfast / (CFAST_gain*Cfastvalue);


% 8/24/2012: EDITED THE FOLLOWING LINE FOR INPUT-REFERENCED VOLTAGE POLARITY
biasDACcode = uint16( (-newbiasvalue-myvoltageoffset+0.5*DACFULLSCALE)/DACFULLSCALE*(2^DACBITS) );
fastcDACcode = uint16( (-newCfastDACvoltage+0.5*DACFULLSCALE)/DACFULLSCALE*(2^DACBITS) );
mydacvector = VECTOR_biasDAC_AD5541A(biasDACcode,fastcDACcode);


DACprevious = DACcurrent;
DACcurrent = newbiasvalue;


% --- display vector ---
%{
vectorlength = length(mydacvector)
%printvector = dec2bin(mydacvector,16)
toplot = dec2bin(mydacvector,16)-'0';
toplot = 0.5*toplot + ones(vectorlength,1) * (15:-1:0);
figure; stairs(toplot);
%}
% ---------------

% COMMENTED OUT 4/28/2011
%ADClogreset=1;

%if(exist('handles.xem'))

DAQ_sendscanvector(handles.xem, mydacvector);



% LOG EVENT
newlogentry = sprintf('%s: BIAS=%dmV \r\n',datestr(now,'yyyymmdd_HHMMSS'), newbiasvalue*1e3);
fid=fopen(EVENTLOGFILE,'a');
fwrite(fid,newlogentry);
fclose(fid);





%disp('end potvalues update');






