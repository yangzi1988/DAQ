
function DAQ_updateDAC_script(handles, name)

DAQ_constants_include;

% % Read in csv
[ndata, text, alldata] = xlsread(name);

% % Commands Types
myCommandTypes = text(2:size(text,1),1);
myCommand = zeros(size(myCommandTypes));
myCommand(strcmp(myCommandTypes,'DELAY')) = 1;
myCommand(strcmp(myCommandTypes,'TRIG')) = 2;
myCommand(strcmp(myCommandTypes,'BIAS')) = 3;

% % Trigger Types
myTriggerTypes = text(2:size(text,1),3);
myTrigger = zeros(size(myTriggerTypes));
myTrigger(strcmp(myTriggerTypes,'rise')) = 1;
myTrigger(strcmp(myTriggerTypes,'fall')) = 2;
myTrigger(strcmp(myCommandTypes,'DELAY')) = 0;  %only trigger commands have a trigger type
myTrigger(strcmp(myCommandTypes,'BIAS')) = 0;   %only trigger commands have a trigger type

% Initial Matrices
Data_DAC1 = ndata(:,1)*1e-3; 
Data_DAC2 = ndata(:,1)*1e-3;

% Offsets & Voltage Limits
offsetvoltage = str2double(get(handles.edit_mVoffset,'String'))*1e-3;
DAC_center_voltage_true = DAC_center_voltage + offsetvoltage;
DAC_command_volt_max = min( abs(DAC_output_max - DAC_center_voltage_true),abs(DAC_center_voltage_true - DAC_output_min) );
DAC_command_volt_min = -DAC_command_volt_max;

% Capacitors
[cs cf rs su] = get_enable_states(handles);
CFAST_CAP_desired = str2double(get(handles.edit_Cfast,'String'))*1e-12;
CSLOW_CAP_desired = str2double(get(handles.edit_Cslow,'String'))*1e-12;

% % Analyzing Commands
for c = 1:length(myCommandTypes)

    if (myCommand(c) == 3);
        % DAC 1 Voltage
        Data_DAC1(c) = limit_val(Data_DAC1(c),DAC_command_volt_min,DAC_command_volt_max);  % +-1V maximum voltage
        Data_DAC1(c) = Data_DAC1(c) + DAC_center_voltage_true;
        Data_DAC1(c) = (Data_DAC1(c)/DACFULLSCALE*(2^DACbits));
      
        % DAC 2 Voltage
        if (cf && DAC1voltage ~= 0)
            DAC2voltage_desired = cap2volt(CFAST_CAP0, CFAST_CAP_desired, DAC1voltage, CFAST_gain);
        else    
            if(cs && DAC1voltage ~= 0)
                DAC2voltage_desired = cap2volt(CSLOW_CAP0, CSLOW_CAP_desired, DAC1voltage, CSLOW_gain);
            else
                DAC2voltage_desired = 0;
            end
        end
        DAC2voltage = limit_val(DAC2voltage_desired, DAC_command_volt_min, DAC_command_volt_max);
        Data_DAC2(c) = DAC2voltage+DAC_center_voltage_true;

    elseif (myCommand(c) == 1);
        % Time
        timerperiod = 1/ADCSAMPLERATE;
        Data_DAC1(c)= (Data_DAC1(c)/timerperiod);
  
    elseif (myCommand(c) == 2);
        % Trigger
        n_edgedetector=128;
        Data_DAC1(c) = Data_DAC1(c)*1e-9 * TIAgain * preADCgain / (2*ADCVREF * 2^-ADCBITS) * n_edgedetector / 2; 
        
    end

end

myInstructions = uint32( [ (uint32(Data_DAC2).*2^0) ; (uint32(myTrigger).*2^24 + uint32(Data_DAC1).*2^8 + uint32(myCommand).*2^0)]);

% % Formatting the Instruction
L2 = length(Data_DAC2);
temp = myInstructions;
myInstructions(1:2:end,:) = temp(1:1:L2,:);
myInstructions(2:2:end,:) = temp(L2+1:1:end,:);

DAQ_sendDACFSMvector1(handles.xem, myInstructions);







