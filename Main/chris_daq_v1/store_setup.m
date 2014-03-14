function store_setup(handles)

DAQ_constants_include

SETUP_TIAgain = str2double(get(handles.edit_gain_Mohm,'String'))*1e6;
SETUP_preADCgain = str2double(get(handles.edit_preADCgain,'String'));
SETUP_pAoffset = str2double(get(handles.edit_pAoffset,'String'))*1e-12;
SETUP_mVoffset = str2double(get(handles.edit_mVoffset,'String'))*1e-3;
SETUP_cfast = str2double(get(handles.edit_Cfast,'String'))*1e-12;
SETUP_freqcomp = str2double(get(handles.edit_freqcomp,'String'));
SETUP_ADCBITS = ADCBITS;
SETUP_ADCVREF = ADCVREF;

save(SAVECONFIGFILE,'SETUP*');

