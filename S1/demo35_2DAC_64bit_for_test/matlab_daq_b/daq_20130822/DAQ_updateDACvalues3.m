
function returnval = DAQ_updateDACvalues3(obj, event, handles, newbiasvalue)

DAQ_constants_include;

set(handles.text_biasvoltage,'String',newbiasvalue);

DAQ_updateDACvalues1(handles);

unclogdelay = str2double(get(handles.edit_unclogdelay,'String'));
t = timer('StartDelay',unclogdelay);
t.TimerFcn = {@DAQ_isunclogging, handles, 0};
start(t);
