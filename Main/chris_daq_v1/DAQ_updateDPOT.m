function DAQ_updateDPOT(handles)
% Structure:
%   DAQ_updateDPOT(handles)
%
% Description:
%   Uses GUI inputs to update the values of the DPOTs
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
%   1.) The dual potentiometers (DPOTS) being addressed are AD5262's
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%disp('start potvalues update');

DAQ_constants_include;

[cs cf rs su] = get_enable_states(handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Frequency Compensation 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

R1_boost1_pos = uint8(str2double(get(handles.edit_freqcomp,'String'))/100*(2^DPOTbits) );

R1_boost1 = pos2res(R1_boost1_pos);

gain_boost1 = R2_boost1/R1_boost1;
fc1_boost1 = rcfreq(R1_boost1,C1_boost1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cslow Compensation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CSLOW_CAP_desired = str2double(get(handles.edit_Cslow,'String'))*1e-12;

if(cs)
    if(cf)
        R2_Cslow_desired = cap2res(CSLOW_CAP0, CSLOW_CAP_desired, DAC1voltage, DAC2voltage, R1_Cslow);
        R2_Cslow_pos = res2pos(R2_Cslow_desired);
        R2_Cslow = pos2res(R2_Cslow_pos);
        CSLOW_CAP = res2cap(CSLOW_CAP0, DAC1voltage, DAC2voltage, R1_Cslow, R2_Cslow);
        set(handles.edit_Cslow,'String',CSLOW_CAP*1e12);
        CSLOW_gain = R2_Cslow/R1_Cslow;
    else
        R2_Cslow_desired = passive_cslow_R2;
        R2_Cslow_pos = res2pos(R2_Cslow_desired);
        R2_Cslow = pos2res(R2_Cslow_pos);
        CSLOW_gain = R2_Cslow/R1_Cslow;
        toggle_DPOT_to_DAC = 1;
        DAQ_updateDAC(handles);
        toggle_DPOT_to_DAC = 0;
    end
else
    R2_Cslow_desired = default_cslow_R2;
    R2_Cslow_pos = res2pos(R2_Cslow_desired);
    R2_Cslow = pos2res(R2_Cslow_pos);
    CSLOW_CAP = CSLOW_CAP_desired; % res2cap(CSLOW_CAP0, DAC1voltage, DAC2voltage, R1_Cslow, R2_Cslow);
%     set(handles.edit_Cslow,'String',CSLOW_CAP);
    CSLOW_gain = R2_Cslow/R1_Cslow;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rseries Compensation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(rs)
    degree_comp_Rseries = str2double(get(handles.edit_Rs_comp,'String'));
    Degree_compensation_Rseries__pos = per2pos(degree_comp_Rseries);
    set(handles.edit_Rs_comp,'String', pos2per(Degree_compensation_Rseries__pos));
else
    degree_comp_Rseries = default_rseries_comp;
    Degree_compensation_Rseries__pos = per2pos(degree_comp_Rseries);
%     set(handles.edit_Rs_comp,'String', pos2per(Degree_compensation_Rseries__pos));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Additional Tuning for Simultaneous Rseries & Cslow Compensation 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(rs)
    Rseries_desired = str2double(get(handles.edit_Rseries,'String'))*1e3;
    R_series_pos = res2pos(Rseries_desired);
    Rseries = pos2res(R_series_pos);
    set(handles.edit_Rseries,'String',Rseries/1e3)
else
    Rseries_desired = default_rseries;
    R_series_pos = res2pos(Rseries_desired);
    Rseries = pos2res(R_series_pos);
%     set(handles.edit_Rseries,'String',Rseries/1e3)
end
    
% Ts_matcher_pos = uint8(Rseries/100*(2^DPOTbits) );
Ts_raw = Rseries*CAP_Rseries_x_Cslow;
Rseries_est = (Ts_raw/CSLOW_CAP);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Supercharge for Reducing Command Settling Time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(su)
    degree_comp_Supercharge = 100 - str2double(get(handles.edit_Supercharge,'String'));
    Degree_compensation_Supercharge__pos = per2pos(degree_comp_Supercharge);
    set(handles.edit_Supercharge,'String',100 - pos2per(Degree_compensation_Supercharge__pos));
else
    degree_comp_Supercharge = 100 - default_super;
    Degree_compensation_Supercharge__pos = per2pos(degree_comp_Supercharge);
%     set(handles.edit_Supercharge,'String',100 - pos2per(Degree_compensation_Supercharge__pos));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sending Values to DPOTs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% schematic: U4
vDPOT1 = [R1_boost1_pos   R1_boost1_pos];
% schematic: U30
vDPOT2 = [R_series_pos   R2_Cslow_pos];
% schematic: U34
vDPOT3 = [Degree_compensation_Rseries__pos   Degree_compensation_Supercharge__pos];

% debug report
if (cs && not(cf))
    Cmessage = 'See DAC Debug Report';
else    
    Cmessage = num2str(CSLOW_CAP);
end
if (show_debug_report == -1 || show_debug_report == 1) && toggle_DAC_to_DOT == 0
    disp([char(10) '>>>>>>>>>POTs Update Report Start>>>>>>>>> ' char(10) ...
         ...        
        char(10) ':::DPOT Update Values:::' char(10) ...
        'U4: ' num2str(vDPOT1) '' char(10) ...
        'U30: ' num2str(vDPOT2) '' char(10) ...
        'U34: ' num2str(vDPOT3) '' char(10)  ...
        ...
        char(10) ':::Boost1 Parameters:::' char(10) ...
        'fc1_preamp [Hz]: ' num2str(fc1_preamp) '' char(10) ...  
        'fc1_boost1 [Hz]: ' num2str(fc1_boost1) '' char(10) ...
        'gain_boost1 [V/V]: ' num2str(gain_boost1) '' char(10) ...
        'R1_boost1 [X]: ' num2str(R1_boost1) '' char(10) ...
        ...
        char(10) ':::Slow Capacitance Compensation Parameters:::' char(10) ...
        'CSLOW_CAP [F]: ' Cmessage '' char(10) ...  
        'R2_Cslow [X]: ' num2str(R2_Cslow) '' char(10) ...
        'CSLOW_gain [V/V]: ' num2str(CSLOW_gain) '' char(10) ...
        ...
        char(10) ':::Series Resistance Compensation Parameters:::' char(10) ...
        'Rseries [X]: ' num2str(Rseries) '' char(10) ...  
        'Ts_raw [s]: ' num2str(Ts_raw) '' char(10) ...
        'Rseries Estimate [X]: ' num2str(Rseries_est) '' char(10) ...
        ...
        char(10) ':::Combined Series Resistance & Slow Capacitance Compensation Parameters:::' char(10) ...
        'degree_comp_Rseries [%]: ' num2str(degree_comp_Rseries) '' char(10) ...
        'degree_comp_Supercharge [%]: ' num2str(degree_comp_Supercharge) '' char(10) ...
        ...
        char(10) '<<<<<<<<<POTs Update Report End<<<<<<<<<<< ' char(10) ])
end

% % Codes for DPOT's 1st wipers, updated on cycle 1
DPOTcode1 = [vDPOT1(1) vDPOT2(1) vDPOT3(1)]; 
% DPOTcode1 = [vDPOT1(1) 0 0]; 
address1 = [0 0 0];

% % Codes for DPOT's 2nd wipers, updated on cycle 2
DPOTcode2 = [vDPOT1(2) vDPOT2(2) vDPOT3(2)]; 
% DPOTcode2 = [vDPOT1(2) 0 0]; 
address2 = not(address1);

% % Send to both addresses
myscanvector = [ VECTOR_DPOT_AD5262(DPOTcode1,address1) VECTOR_DPOT_AD5262(DPOTcode2,address2) ];

% % Display vector
if show_debug_report == -1 || show_debug_report == 3
    plot_scanvector( myscanvector , 'DPOT Update')
end

DAQ_sendscanvector(handles.xem, myscanvector);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Logging Event
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

newlogentry1 = sprintf('%s: DPOT1=%d \r\n',datestr(now,'yyyymmdd_HHMMSS'), DPOTcode1);
newlogentry2 = sprintf('%s: DPOT2=%d \r\n',datestr(now,'yyyymmdd_HHMMSS'), DPOTcode2);
fid=fopen(EVENTLOGFILE,'a');
fwrite(fid,newlogentry1);
fwrite(fid,newlogentry2);
fclose(fid);

%disp('end potvalues update');


% end



