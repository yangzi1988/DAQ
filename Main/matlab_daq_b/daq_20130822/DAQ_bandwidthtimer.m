

function returnval = DAQ_bandwidthtimer(obj, event, handles)

%bandwidthtimerprocess=1

%disp('start bw timer update');

DAQ_constants_include;

mytime = datenum([2010 1 1 0 0 etime(clock,timezero)]);
mytimestring = datestr(mytime,'HH:MM:SS');
set(handles.text_time,'String',mytimestring);
set(handles.text_readrate,'String',read_monitor/2000);
set(handles.text_writerate,'String',write_monitor/2000);

updatewireouts(handles.xem);

if(strcmp(FPGAMODEL,'spartan3'))
    fifolevel = getwireoutvalue(handles.xem, EP_WIREOUT_ADCFIFOCOUNT);
    set(handles.text_adcfifolevel,'String',sprintf('%u kB /  %u %%  /  %2.1f sec',fifolevel,floor(100*fifolevel/32e3),fifolevel*1024/(ADCSAMPLERATE*2)));
end

if(strcmp(FPGAMODEL,'spartan6'))
    fifolevel = 4*bitand(getwireoutvalue(handles.xem, EP_WIREOUT_ADCFIFOCOUNT),bin2dec('0111111111111111'));
    set(handles.text_adcfifolevel,'String',sprintf('%u kB /  %u %%  /  %2.1f sec',fifolevel,floor(100*fifolevel/HWBUFFERSIZE_KB),fifolevel*1024/(ADCSAMPLERATE*2)));
end

if(strcmp(FPGAMODEL,'spartan6_usb3'))
    fifolevel = 4*bitand(getwireoutvalue(handles.xem, EP_WIREOUT_ADCFIFOCOUNT),bin2dec('0111111111111111'));
    set(handles.text_adcfifolevel,'String',sprintf('%u kB /  %u %%  /  %2.1f sec',fifolevel,floor(100*fifolevel/HWBUFFERSIZE_KB),fifolevel*1024/(ADCSAMPLERATE*2)));
end


write_monitor=0;
read_monitor=0;


%disp('end bw timer update');

end


