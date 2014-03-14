

function DAQ_updateDACvalues1(handles)

%disp('start potvalues update');

DAQ_constants_include;
newbiasvalue = str2double(get(handles.text_biasvoltage,'String'))*1e-3;
newbiasvalue = min(1,newbiasvalue);
newbiasvalue = max(-1,newbiasvalue);
set(handles.text_biasvoltage,'String',newbiasvalue*1e3)

fprintf('bias=%dmV\n',newbiasvalue*1e3);

myvoltageoffset = str2double(get(handles.edit_mVoffset,'String'))*1e-3;


myDACvalues1= (-newbiasvalue-myvoltageoffset+0.5*DACFULLSCALE)/DACFULLSCALE*(2^DACBITS) ;
DACpreviousbis=(-DACcurrent-myvoltageoffset+0.5*DACFULLSCALE)/DACFULLSCALE*(2^DACBITS);

    myDACvalues = [myDACvalues1];
    myDelayValues = [0];
    myTriggerBits = [0];   
myTHRESHOLDvalues1 = 0;

myData=myDACvalues;
myCommand=[3];



CFAST_CAP = str2double(get(handles.edit_Cfast,'String'))*1e-12;
CFAST_gain = 1;
CFAST_CAP0 = 1e-12;
voltage = str2double(get(handles.text_biasvoltage,'String'))*1e-3;
Compensation =  -(voltage / CFAST_gain)*(CFAST_CAP / CFAST_CAP0);
myCompensation = (-Compensation+2.5);



%myInstructions = uint32( [ (uint32(myTriggerBits).*2^2 + uint32(myDelayValues).*2^4); uint32(myTHRESHOLDvalues1).*2^0 + uint32(myDACvalues).*2^16 ] );      % 2x32bit columns to assemble 64bit data
%myInstructions = uint32( [ (uint32(myTriggerBits).*2^2 + uint32(myDelayValues).*2^4); uint32(myDACvalues).*2^16 ] );
%myInstructions = uint32( [ (uint32(myData).*2^8 + uint32(myCommand).*2^0)])
myInstructions = uint32( [ (uint32(myCompensation).*2^0) ; (uint32(myData).*2^8 + uint32(myCommand).*2^0)])
%-------------------------------------------------------------------------------------------------------

DACprevious = DACcurrent;
DACcurrent = newbiasvalue;





%DAQ_updateDACvalues4(handles.xem, myDACvalues1);
%DAQ_sendscanvector1(handles.xem, myInstructions);
DAQ_sendDACFSMvector1(handles.xem, myInstructions);

% LOG EVENT





%disp('end potvalues update');






