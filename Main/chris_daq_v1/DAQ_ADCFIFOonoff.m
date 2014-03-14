
function DAQ_ADCFIFOonoff(obj, event, handles,ONOFF)


DAQ_constants_include;

set(handles.checkbox_adcfifoenable,'Value',ONOFF);

setwireinvalue(handles.xem, EP_WIREIN_TEST1, ONOFF, EPBIT_ENABLEADCFIFO ); 
updatewireins(handles.xem);

fprintf('Stop timer at %f\n',etime(clock,timezero));







