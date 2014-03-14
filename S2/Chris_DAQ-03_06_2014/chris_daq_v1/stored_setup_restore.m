function stored_setup_restore(handles)

DAQ_constants_include

if(exist(SAVECONFIGFILE,'file'))
    
    load(SAVECONFIGFILE,'SETUP*');

    set(handles.edit_gain_Mohm,'String',SETUP_TIAgain*1e-6);
    set(handles.edit_preADCgain,'String',SETUP_preADCgain);
    set(handles.edit_pAoffset,'String',SETUP_pAoffset*1e12);
    set(handles.edit_mVoffset,'String',SETUP_mVoffset*1e3);
    set(handles.edit_Cfast,'String',SETUP_cfast*1e12);
    set(handles.edit_freqcomp,'String',SETUP_freqcomp);    
    ADCBITS = SETUP_ADCBITS;
    ADCVREF = SETUP_ADCVREF;
    
end

if show_debug_report == -1 || show_debug_report == 4
    FPGAMODEL
    ADCSAMPLERATE
    displaybuffertime
    displaysubsample
end

R_f_preamp = str2double(get(handles.edit_gain_Mohm,'String'))*1e6;
fc1_preamp = 1/(2*pi*R_f_preamp*C_f_preamp);

set(handles.enable_debug_level,'String', show_debug_report);

set(handles.edit_mVoffset,'String',offsetvoltage*1e3)

todaysdate = datestr(now,'yyyymmdd');
set(handles.edit_logdir,'String',todaysdate);