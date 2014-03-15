function DAQ_updateDAC(handles)
% Structure:
%   DAQ_updateDAC(handles)
%
% Description:
%   Uses GUI inputs to update the values of the DACs
%
% Input:
%     handles = handles from the GUI (DAQ_gui)
% 
% Output:
%
%
% Range:
%
%
% Example: 
%
%
% Note: 
%   1.) The digital to analog converters(DACs) being addressed are AD5541A's
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%disp('start potvalues update');

DAQ_constants_include;

[cs cf rs su] = get_enable_states(handles);

% Performing voltage offset calculations
offsetvoltage = str2double(get(handles.edit_mVoffset,'String'))*1e-3;

DAC_center_voltage_true = DAC_center_voltage + offsetvoltage;

DAC_command_volt_max = min( abs(DAC_output_max - DAC_center_voltage_true),abs(DAC_center_voltage_true - DAC_output_min) );
DAC_command_volt_min = -DAC_command_volt_max;

% Obtaining the enable states
cs = get(handles.enable_comp_cslow,'Value');
cf = get(handles.enable_comp_cfast,'Value');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DAC 1 - Counter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DAC1voltage = limit_val(str2double(get(handles.text_biasvoltage,'String'))*1e-3, DAC_command_volt_min, DAC_command_volt_max);
set(handles.text_biasvoltage,'String',DAC1voltage*1e3);

DAC1value = DAC1voltage+DAC_center_voltage_true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DAC 2 - Compensator / Cfast Compensation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CFAST_CAP_desired = str2double(get(handles.edit_Cfast,'String'))*1e-12;
CSLOW_CAP_desired = str2double(get(handles.edit_Cslow,'String'))*1e-12;

if (cf && DAC1voltage ~= 0)
    DAC2voltage_desired = cap2volt(CFAST_CAP0, CFAST_CAP_desired, DAC1voltage, CFAST_gain);
    DAC2voltage = limit_val(DAC2voltage_desired, DAC_command_volt_min, DAC_command_volt_max);
    CFAST_CAP = volt2cap(CFAST_CAP0, DAC2voltage, DAC1voltage, CFAST_gain);
    set(handles.edit_Cfast,'String',CFAST_CAP*1e12);
    toggle_DAC_to_DOT = 1;
    DAQ_updateDPOT(handles);
    toggle_DAC_to_DOT = 0;
else    
    if(cs && DAC1voltage ~= 0)
        DAC2voltage_desired = cap2volt(CSLOW_CAP0, CSLOW_CAP_desired, DAC1voltage, CSLOW_gain);
        DAC2voltage = limit_val(DAC2voltage_desired, DAC_command_volt_min, DAC_command_volt_max);
        CSLOW_CAP = volt2cap(CSLOW_CAP0, DAC2voltage, DAC1voltage, CSLOW_gain);
        set(handles.edit_Cslow,'String',CSLOW_CAP*1e12);
    else
        DAC2voltage = 0;
        CFAST_CAP = CFAST_CAP_desired;
%         set(handles.edit_Cfast,'String',CFAST_CAP*1e12);
    end
end

DAC2value = DAC2voltage+DAC_center_voltage_true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sending Values to DACs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% debug report
if (cf)
    Cmessage  = 'CFAST_CAP [F]: ';
    Cvalue = num2str(CFAST_CAP);
else
    Cmessage = 'CSLOW_CAP [F]: ';
    Cvalue = num2str(CSLOW_CAP);
end
if (show_debug_report == -1 || show_debug_report == 1) && toggle_DPOT_to_DAC == 0
    disp([char(10) '>>>>>>>>>DACs Update Report Start>>>>>>>>> ' char(10) ...
        ...                                          
        char(10) ':::DAC Update Values:::' char(10) ...
        'Vcounter [V]: ' num2str(DAC1value) '' char(10) ...
        'Vcompensation [V]: ' num2str(DAC2value) '' char(10) ...
        ...
        char(10) ':::DAC Output Range:::' char(10) ...
        'Vcenter [V]: ' num2str(DAC_center_voltage_true) '' char(10) ...
        'Vcommand_extreme [differential V]: (+-) ' num2str(DAC_command_volt_max) '' char(10) ...
        ...
        char(10) ':::Differential Voltages & Their Ratio:::' char(10) ...
        'dVcompensation/dVcounter []: ' num2str(DAC2voltage/DAC1voltage) '' char(10) ...
        'DAC1value [differential V]: ' num2str(DAC1voltage) '' char(10) ...
        'DAC2value [differential V]: ' num2str(DAC2voltage) '' char(10) ...
        ...
        char(10) '::: Capacitance Compensation Parameters:::' char(10) ...
        Cmessage Cvalue '' char(10) ...
        ...
        char(10) '<<<<<<<<<DACs Update Report End<<<<<<<<<<< ' char(10) ])
end

% 1234:
% DAC1code = uint16(DAC1value/DACFULLSCALE*(2^DACbits));
% DAC2code = uint16(DAC2value/DACFULLSCALE*(2^DACbits));
DAC1code = (DAC1value/DACFULLSCALE*(2^DACbits));
DAC2code = (DAC2value/DACFULLSCALE*(2^DACbits));

% 1234: 
% myscanvector = VECTOR_DAC_AD5541A(DAC1code,DAC2code);

DACprevious = DACcurrent;
DACcurrent = DAC1voltage;

% 1234:
% % % Display vector
% if show_debug_report == -1 || show_debug_report == 3
%     plot_scanvector( myscanvector , 'DAC Update');
% end
 

% 1234: 
% DAQ_sendscanvector(handles.xem, myscanvector);

myCommand=3;
myInstructions = uint32( [ (uint32(DAC2code).*2^0) ; (uint32(DAC1code).*2^8 + uint32(myCommand).*2^0)]);
DAQ_sendFSMvector(handles.xem, myInstructions);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Logging Event
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1234:
% newlogentry = sprintf('%s: BIAS=%dmV \r\n',datestr(now,'yyyymmdd_HHMMSS'), DAC1voltage*1e3);
% fid=fopen(EVENTLOGFILE,'a');
% fwrite(fid,newlogentry);
% fclose(fid);

%disp('end dacvalues update');


% end



