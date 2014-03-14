

function DAQ_autozerooffsetvoltage(obj,event,handles,phasenum)

DAQ_constants_include;

if show_debug_report == -1 || show_debug_report == 5
    if phasenum >= 0
        fprintf('autozero voltage phase %u \n',phasenum);
    end
end

delaytime = 1;

testV1 = 10e-3;


persistent measI1
persistent measI2


switch phasenum
    
    case 0,
        set(handles.btn_zero_voltage,'BackgroundColor',lightgreen);
        
        set(handles.text_biasvoltage,'String',testV1*1e3);
        DAQ_updateDAC(handles);
        
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
        
        measI1 = myIdc;
        
        if show_debug_report == -1 || show_debug_report == 5
            measI1
        end
        
        set(handles.btn_zero_voltage,'BackgroundColor',lightred);

        set(handles.text_biasvoltage,'String',0);
        DAQ_updateDAC(handles);
        
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
        measI2 = myIdc;

        if show_debug_report == -1 || show_debug_report == 5
            measI2
        end
        
        set(handles.btn_zero_voltage,'BackgroundColor',lightblue);       
        
        deltaI = measI1-measI2;
        measR = testV1/deltaI;
        
        if show_debug_report == -1 || show_debug_report == 5
            deltaI
            measR
        end
            
        setwireinvalue(handles.xem,EP_WIREIN_TEST1, EPBIT_GLOBALRESET, EPBIT_GLOBALRESET );    
        updatewireins(handles.xem);
        pause(0.1);
        setwireinvalue(handles.xem,EP_WIREIN_TEST1, 0, EPBIT_GLOBALRESET );    
        updatewireins(handles.xem);
        pause(0.1);
        
        oldmVoffset = str2double(get(handles.edit_mVoffset,'String'));
        newmVoffset = oldmVoffset + -measI2*measR*1e3;
%         if DAC_center_voltage/2 <= abs(newmVoffset*1e-3)
%             newmVoffset = nan;
%         end;

        if show_debug_report == -1 || show_debug_report == 5
            oldmVoffset
            newmVoffset
        end

        set(handles.edit_mVoffset,'String',sprintf('%4.1f',newmVoffset));
        
        set(handles.text_biasvoltage,'String',0);
        DAQ_updateDAC(handles);        
        
        nexttimer = timer('StartDelay', delaytime);
        nexttimer.TimerFcn = { @DAQ_autozerooffsetvoltage, handles, -1};
        start(nexttimer);
        
    otherwise,
        set(handles.btn_zero_voltage,'BackgroundColor',lightwhite);
        
        % debug report
        if show_debug_report == -1 || show_debug_report == 5
            disp([ char(10) 'autozero done' char(10)]);
        end
            
end








