

function DAQ_updateDACvalues6(handles, getthresholdoffsetvalue)

%disp('start potvalues update');

DAQ_constants_include;

%newdelayvalue = str2double(get(handles.edit_zapseconds,'String'));

thresholdoffset1 = getthresholdoffsetvalue * 3200; 
myInstructions1 = uint32(thresholdoffset1);

%------------------------------------------------------------------------------------------------------
%myDACvalues = uint32(str2double(get(handles.text_biasvoltage,'String')))

%myDACvalues = uint32(get(handles.text_biasvoltage))
%myDACvalues = uint32(2519)
%myDACvalues1 =  (myDACvalues*65536/4520)
%myDACvalues1 =  (2.519*65536/4520)

%myDACvalues1 = (myDACvalues*655350/45290)


DAQ_sendscanvector2(handles.xem, myInstructions1);







