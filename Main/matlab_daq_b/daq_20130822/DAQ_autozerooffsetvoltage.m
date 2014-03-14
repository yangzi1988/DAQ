

function DAQ_autozerooffsetvoltage(obj,event,handles,phasenum)

DAQ_constants_include;

fprintf('autozero voltage phase %u \n',phasenum);

delaytime = 1;

testV1 = 10e-3;


persistent measI1
persistent measI2


switch phasenum
    
    case 0,
        set(handles.text_biasvoltage,'String',testV1*1e3);
        DAQ_updateDACvalues1(handles);
        
        setwireinvalue(handles.xem,EP_WIREIN_TEST1, EPBIT_GLOBALRESET, EPBIT_GLOBALRESET );    
        updatewireins(handles.xem);
        pause(0.1);
        setwireinvalue(handles.xem,EP_WIREIN_TEST1, 0, EPBIT_GLOBALRESET );    
        updatewireins(handles.xem);
        pause(0.1);
        
        nexttimer = timer('StartDelay', delaytime);
        nexttimer.TimerFcn = { @DAQ_autozerooffsetvoltage, handles, phasenum+1};
        start(nexttimer);
        
        
    case 1,
        measI1 = myIdc
        
        set(handles.text_biasvoltage,'String',0);
        DAQ_updateDACvalues1(handles);
        
        setwireinvalue(handles.xem,EP_WIREIN_TEST1, EPBIT_GLOBALRESET, EPBIT_GLOBALRESET );    
        updatewireins(handles.xem);
        pause(0.1);
        setwireinvalue(handles.xem,EP_WIREIN_TEST1, 0, EPBIT_GLOBALRESET );    
        updatewireins(handles.xem);
        pause(0.1);
        
        nexttimer = timer('StartDelay', delaytime);
        nexttimer.TimerFcn = { @DAQ_autozerooffsetvoltage, handles, phasenum+1};
        start(nexttimer);
        
    case 2,
        measI2 = myIdc
        
        deltaI = measI1-measI2
        measR = testV1/deltaI
        
        
        setwireinvalue(handles.xem,EP_WIREIN_TEST1, EPBIT_GLOBALRESET, EPBIT_GLOBALRESET );    
        updatewireins(handles.xem);
        pause(0.1);
        setwireinvalue(handles.xem,EP_WIREIN_TEST1, 0, EPBIT_GLOBALRESET );    
        updatewireins(handles.xem);
        pause(0.1);
        
        oldmVoffset = str2double(get(handles.edit_mVoffset,'String'))
        newmVoffset = oldmVoffset + (-measI2*measR)*1e3
        set(handles.edit_mVoffset,'String',sprintf('%4.1f',newmVoffset));
        
        set(handles.text_biasvoltage,'String',0);
        DAQ_updateDACvalues1(handles);        
        
    otherwise,
        disp('autozero done');
end








