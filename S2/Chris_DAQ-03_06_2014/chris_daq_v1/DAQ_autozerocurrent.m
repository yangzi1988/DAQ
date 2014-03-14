function DAQ_autozerocurrent(handles)

DAQ_constants_include;

set(handles.btn_zero_current,'BackgroundColor',lightgreen);
delaytime = 0.3;

pause(delaytime);

%myIdc
mypAoffset = str2double(get(handles.edit_pAoffset,'String'));

set(handles.edit_pAoffset,'String',mypAoffset-myIdc*1e12);

set(handles.btn_zero_current,'BackgroundColor',lightwhite);