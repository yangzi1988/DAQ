

function DAQ_updateDACvalues_manual_zap(handles, zapbiasmV, zapseconds, biasmV)

%disp('start potvalues update');

DAQ_constants_include;

newzapbiasmV = str2double(get(handles.edit_zapmV,'String'))*1e-3;
newzapbiasmV = min(1,newzapbiasmV);
newzapbiasmV = max(-1,newzapbiasmV);
set(handles.edit_zapmV,'String',newzapbiasmV*1e3);



newbiasmV = str2double(get(handles.text_biasvoltage,'String'))*1e-3;
newbiasmV = min(1,newbiasmV);
newbiasmV = max(-1,newbiasmV);
set(handles.text_biasvoltage,'String',newbiasmV*1e3);


myvoltageoffset = str2double(get(handles.edit_mVoffset,'String'))*1e-3;

%newdelayvalue = str2double(get(handles.edit_zapseconds,'String'));



%------------------------------------------------------------------------------------------------------
%myDACvalues = uint32(str2double(get(handles.text_biasvoltage,'String')))

%myDACvalues = uint32(get(handles.text_biasvoltage))
%myDACvalues = uint32(2519)
%myDACvalues1 =  (myDACvalues*65536/4520)
%myDACvalues1 =  (2.519*65536/4520)

%myDACvalues1 = (myDACvalues*655350/45290)






myDACvalues11 = (-newzapbiasmV-myvoltageoffset+0.5*DACFULLSCALE)/DACFULLSCALE*(2^DACBITS) ;
bisvalue=          (-newbiasmV-myvoltageoffset+0.5*DACFULLSCALE)/DACFULLSCALE*(2^DACBITS) ;

myDACvalues22 = [myDACvalues11 bisvalue];
%--------------------------------------------------------------------------------------------------------
%myDelayValues = [0 zapseconds];
%myDelayValues1= (myDelayValues*1000000/2.5);
myDelayValues = (zapseconds*1000000/2.5);
%----------------------------------------------------------------------------------------------------------
%myDACvalues = uint16([32357])000000000000
myTriggerBits = [0 0];
%------------------------------------------------------------------------------------------------------

myTHRESHOLDvalues = [0 0 0];

myCommand = [3 1 3];
myData = [myDACvalues11 myDelayValues bisvalue];
%myDACvalues1 = uint32( [ (uint32(myTriggerBits).*2^2 + uint32(myDelayValues1).*2^4); uint32(myDACvalues22).*2^16 ] );
%myInstructions = uint32( [ (uint32(myTriggerBits).*2^2 + uint32(myDelayValues1).*2^4); uint32(myTHRESHOLDvalues1).*2^0 + uint32(myDACvalues22).*2^16 ] );
myInstructions = uint32( [ (uint32(myData).*2^8 + uint32(myCommand).*2^0)])
%-------------------------------------------------------------------------------------------------------



%DAQ_sendscanvector(handles.xem, myDACvalues1);
DAQ_sendFSMvector(handles.xem, myInstructions);

% LOG EVENT





%disp('end potvalues update');






