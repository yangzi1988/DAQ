
function returnval = DAQ_unclogDAC(obj, event, handles, newbiasvalue)

DAQ_constants_include;

set(handles.text_biasvoltage,'String',newbiasvalue);

DAQ_updateDAC(handles);

unclogdelay = str2double(get(handles.edit_unclogdelay,'String'));
t = timer('StartDelay',unclogdelay);
t.TimerFcn = {@DAQ_isunclogging, handles, 0};
start(t);
