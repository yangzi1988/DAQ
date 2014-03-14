
function DAQ_updateDACvalues_script_file(handles, name)


DAQ_constants_include;
[ndata, text, alldata] = xlsread(name);


%myTriggerTypes = text(2:size(text,1),1);
%myTriggers = zeros(size(myTriggerTypes));
%myTriggers(strcmp(myTriggerTypes,'edge-rise')) = 1;
%myTriggers(strcmp(myTriggerTypes,'edge-fall')) = 2;
%myTriggers(strcmp(myTriggerTypes,'level')) = 3;
%myTriggers(strcmp(myTriggerTypes,'none')) = 0;


myCommandTypes = text(2:size(text,1),1);
myCommand = zeros(size(myCommandTypes));
myCommand(strcmp(myCommandTypes,'DELAY')) = 1;
myCommand(strcmp(myCommandTypes,'TRIG')) = 2;
myCommand(strcmp(myCommandTypes,'BIAS')) = 3;

myTriggerTypes = text(2:size(text,1),3);
myTrigger = zeros(size(myTriggerTypes));
myTrigger(strcmp(myTriggerTypes,'rise')) = 1;
myTrigger(strcmp(myTriggerTypes,'fall')) = 2;
myTrigger(strcmp(myCommandTypes,'DELAY')) = 0;  %only trigger commands have a trigger type
myTrigger(strcmp(myCommandTypes,'BIAS')) = 0;   %only trigger commands have a trigger type

myTrigger
myCommand

myData = ndata(:,1)*1e-3; 

myData_Voltage = ndata(:,1)*1e-3;

CFAST_CAP = str2double(get(handles.edit_Cfast,'String'))*1e-12;
        CFAST_gain = 1;
        CFAST_CAP0 = 1e-12;


myvoltageoffset = str2double(get(handles.edit_mVoffset,'String'))*1e-3;
TIAgain= str2double(get(handles.edit_gain_Mohm,'String')) * 1e6;
preADCgain= str2double(get(handles.edit_preADCgain,'String'));

for c = 1:length(myCommandTypes)

    if (myCommand(c) == 3);
        myData(c) = min(1,myData(c));  % +1V maximum voltage
        myData(c) = max(-1,myData(c)); % -1V minimum voltage
        myDACvalue = (-myData(c)-myvoltageoffset+0.5*DACFULLSCALE)/DACFULLSCALE*(2^DACBITS);
        myData(c) =  myDACvalue;
      
        Compensation =  -(myData_Voltage(c) / CFAST_gain)*(CFAST_CAP / CFAST_CAP0);
        myData_Voltage(c) = (-Compensation+2.5);
        

        
        
    elseif (myCommand(c) == 1);
        timerperiod = 1/ADCSAMPLERATE;
        myData(c)= (myData(c)/timerperiod);
        

        
    elseif (myCommand(c) == 2);
        n_edgedetector=128;
        myData(c) = myData(c)*1e-9 * TIAgain * preADCgain / (2*ADCVREF * 2^-ADCBITS) * n_edgedetector / 2;
        

        
        
    end

end

LL = length(myData_Voltage);



myInstructions = uint32( [ (uint32(myData_Voltage).*2^0) ; (uint32(myTrigger).*2^24 + uint32(myData).*2^8 + uint32(myCommand).*2^0)]);
temp = myInstructions;
myInstructions(1:2:end,:) = temp(1:1:LL,:);
myInstructions(2:2:end,:) = temp(LL+1:1:end,:);



DAQ_sendDACFSMvector1(handles.xem, myInstructions);







